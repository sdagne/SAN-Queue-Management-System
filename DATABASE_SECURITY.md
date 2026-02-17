# 🗄️ Database Structure & Security for Queue Management System

## Overview

The system uses **SQLite** database with 5 main tables. Each portal accesses different parts of the database.

---

## 📊 The 5 Database Tables

### **Table 1: Citizens**

Stores information about citizens who use the system.

```sql
CREATE TABLE citizens (
    id: INTEGER PRIMARY KEY
    id_number_hash: STRING (HASHED) - Unique ID
    full_name: STRING
    phone_number: STRING (Optional)
    created_at: DATETIME
    is_blacklisted: BOOLEAN
    blacklist_reason: STRING
)
```

**What it stores:**
- Hashed ID (not plain text!)
- Citizen's name
- Phone number
- When they first used system
- Blacklist status (fraud detection)

**Privacy note:** ID is HASHED, not stored plainly.

---

### **Table 2: Tickets**

The core table - every ticket created goes here.

```sql
CREATE TABLE tickets (
    id: INTEGER PRIMARY KEY
    ticket_number: STRING UNIQUE - Like "DL-026"
    citizen_id: INTEGER - Links to citizens table
    id_number_hash: STRING - Which ID this ticket is for
    full_name: STRING - Citizen name
    service_type: ENUM - immigration, passport_renewal, etc.
    status: ENUM - waiting, called, serving, completed, expired, cancelled
    counter_number: INTEGER - Which counter is serving (if called)
    
    created_at: DATETIME - When created
    called_at: DATETIME - When called to counter
    served_at: DATETIME - When started serving
    completed_at: DATETIME - When finished
    expires_at: DATETIME - When ticket expires
    
    qr_code: STRING - QR code data (for scanning)
)
```

**Critical columns:**
- `status` - Tracks if waiting, being served, or completed
- `citizen_id` - Links to who this ticket belongs to
- `counter_number` - Which counter is serving it
- `id_number_hash` - Verification at counter

---

### **Table 3: Counters**

Information about service counters.

```sql
CREATE TABLE counters (
    id: INTEGER PRIMARY KEY
    counter_number: INTEGER UNIQUE - 1, 2, 3, etc.
    counter_name: STRING - "Immigration Counter 1"
    service_types: STRING - "immigration,passport_renewal"
    is_active: BOOLEAN - Is counter operating?
    current_ticket_id: INTEGER - What's being served now
    staff_name: STRING - Who's working the counter
)
```

**What it tracks:**
- Which counter (1, 2, 3...)
- What services it handles
- Who's currently being served
- Staff member working there

---

### **Table 4: AuditLog**

**Security log** - Records every important action.

```sql
CREATE TABLE audit_logs (
    id: INTEGER PRIMARY KEY
    action: STRING - "TICKET_CREATED", "TICKET_CALLED", etc.
    citizen_id: INTEGER - Who did it
    ticket_id: INTEGER - Which ticket involved
    counter_id: INTEGER - Which counter involved
    details: STRING - Extra info about the action
    ip_address: STRING - Where the request came from
    timestamp: DATETIME - When it happened
    is_suspicious: BOOLEAN - Flagged as fraud?
)
```

**This is the security log!** Every action is recorded here.

---

## 🎯 Portal Database Usage

### **Portal 1: KIOSK PORTAL (kiosk_portal.html)**

**What it READS:**
- Nothing (except to check if citizen already has active ticket)

**What it WRITES:**
- ✅ Creates new row in `Citizen` table
- ✅ Creates new row in `Ticket` table
- ✅ Writes to `AuditLog` table

**Operations:**
```python
# Citizen scans ID
INSERT INTO citizens (id_number_hash, full_name, phone_number)
INSERT INTO tickets (ticket_number, citizen_id, status="waiting", ...)
INSERT INTO audit_logs (action="TICKET_CREATED", ...)
```

**Cannot modify:**
- ❌ Cannot change existing tickets
- ❌ Cannot change citizen info
- ❌ Cannot delete anything

---

### **Portal 2: COUNTER PORTAL (counter_portal.html)**

**What it READS:**
- ✅ Reads `Ticket` table (to show queue)
- ✅ Reads `Counter` table (to know counter info)
- ✅ Reads statistics

**What it WRITES:**
- ✅ Updates `Ticket` status (waiting → called → serving → completed)
- ✅ Updates `Counter` current_ticket_id
- ✅ Writes to `AuditLog` (logs every action)

**Operations:**
```python
# Staff calls next ticket
UPDATE tickets SET status="called", counter_number=1, called_at=NOW()
UPDATE counters SET current_ticket_id=123
INSERT INTO audit_logs (action="TICKET_CALLED", ...)

# Staff verifies ID
# (No DB write - just API validation)

# Staff completes service
UPDATE tickets SET status="completed", completed_at=NOW()
UPDATE counters SET current_ticket_id=NULL
INSERT INTO audit_logs (action="TICKET_COMPLETED", ...)
```

**Cannot:**
- ❌ Change ticket numbers
- ❌ Change citizen names
- ❌ Delete tickets
- ❌ Access citizen personal info

---

### **Portal 3: DISPLAY PORTAL (display_portal.html)**

**What it READS:**
- ✅ Reads `Ticket` table (status=called or serving)
- ✅ Reads `Counter` table (counter numbers)
- ✅ Reads statistics only

**What it WRITES:**
- ❌ NOTHING! Read-only!

**Operations:**
```python
# Display just reads:
SELECT * FROM tickets WHERE status IN ('called', 'serving')
SELECT * FROM counters WHERE is_active=true
```

**Cannot:**
- ❌ Write anything
- ❌ Update anything
- ❌ Delete anything
- ❌ Modify any data

---

### **Portal 4: DEMO DASHBOARD (demo_dashboard.html)**

**What it READS:**
- ✅ Reads all tables (for reporting and management)

**What it WRITES:**
- ✅ Can create tickets (testing)
- ✅ Can update tickets
- ✅ Can cancel tickets
- ✅ Can manage counters
- ✅ Writes to `AuditLog`

**Operations:**
```python
# Admin creates ticket manually
INSERT INTO tickets (...)
INSERT INTO audit_logs (action="TICKET_CREATED_BY_ADMIN", ...)

# Admin cancels ticket
UPDATE tickets SET status="cancelled"
INSERT INTO audit_logs (action="TICKET_CANCELLED", ...)

# Admin views waiting tickets
SELECT * FROM tickets WHERE status="waiting"
```

**Can:**
- ✅ View everything
- ✅ Create/modify/delete tickets (admin only)
- ✅ Manage counters
- ✅ View logs

---

## 🚨 Security: What If Staff Modifies Database Directly?

This is an important security concern. Let me explain the risks and protections:

### **Scenario 1: Staff Directly Updates Ticket Status**

**What they might try:**
```sql
UPDATE tickets SET status='completed' WHERE ticket_number='DL-026'
-- Pretend they served someone without actually serving them
```

**Consequences:**
- ✅ **Caught by Audit Log!**
  - The modification would appear in `AuditLog`
  - Timestamp would show when done
  - IP address would be logged
  - Could trace back to which staff member

- ✅ **Caught by counter verification!**
  - Next ticket issued wouldn't match
  - If they try to issue same ticket again, system detects duplicate

---

### **Scenario 2: Staff Changes Citizen Name**

**What they might try:**
```sql
UPDATE citizens SET full_name='Different Name'
-- Try to impersonate someone else's ticket
```

**Consequences:**
- ✅ **Verification at counter fails!**
  - When citizen shows actual ID, it won't match DB name
  - Counter portal verifies: `ID hash == recorded ID hash`
  - Verification fails, citizen is rejected

- ✅ **Audit log shows the change!**
  - Manager can see when name was changed
  - Can trace back to staff member

---

### **Scenario 3: Staff Deletes Ticket Records**

**What they might try:**
```sql
DELETE FROM tickets WHERE ticket_number='DL-026'
-- Erase evidence of a ticket
```

**Consequences:**
- ✅ **Can't delete from AuditLog!**
  - Every action is logged before deletion
  - Log shows: "TICKET_DELETED by staff member X"
  - Cannot delete the audit log without admin access

- ✅ **SQL Audit Trail!**
  - Database itself can log SQL changes
  - DBA can see deleted records

---

### **Scenario 4: Staff Changes Ticket Counter Number**

**What they might try:**
```sql
UPDATE tickets SET counter_number=2 WHERE ticket_number='DL-026'
-- Pretend they served at wrong counter
```

**Consequences:**
- ✅ **Audit log shows the change!**
  - Shows timestamp and which staff did it
  - Manager can investigate

- ✅ **Display portal shows mismatch!**
  - If ticket was already served at Counter 1
  - But DB says Counter 2
  - Discrepancy shows up in reports

---

## 🔐 Built-in Security Protections

### **Protection 1: Audit Logging**

Every action is logged:
```
- TICKET_CREATED
- TICKET_CALLED
- TICKET_COMPLETED
- TICKET_CANCELLED
- TICKET_VERIFIED
- ID_VERIFICATION_FAILED
```

### **Protection 2: ID Hashing**

Citizen ID is hashed, not plaintext:
```python
id_number_hash = hash(ID_NUMBER)  # One-way encryption
# Cannot reverse to find original ID
```

### **Protection 3: Verification at Counter**

When called, citizen must show physical ID:
```python
# Staff enters ID
provided_id_hash = hash(PROVIDED_ID)

# System checks
if provided_id_hash == ticket.id_number_hash:
    ✅ Verification successful
else:
    ❌ Verification failed - reject ticket
```

### **Protection 4: Timestamp Verification**

Times must make logical sense:
```
created_at < called_at < served_at < completed_at
# If times are wrong, can detect fraud
```

### **Protection 5: Counter Assignment Logic**

Counter number only set by call-next system:
```python
# Only Counter Portal can call tickets
# Automatically assigns counter_number
# Staff cannot manually change it (safely)
```

---

## 📋 Database Access Levels

### **Level 1: Kiosk (Limited)**
- Can: Create citizens, create tickets, log actions
- Cannot: Read existing tickets, modify anything

### **Level 2: Counter Portal (Moderate)**
- Can: Read queue, update ticket status, log actions
- Cannot: Delete tickets, modify citizen info

### **Level 3: Display Portal (Read-Only)**
- Can: Read ticket list, read counter info
- Cannot: Write anything, modify anything

### **Level 4: Demo Dashboard (Full Admin)**
- Can: Everything (for testing/management)
- Logged and audited

### **Level 5: Direct DB Access (Dangerous!)**
- ❌ Should NOT have direct access
- ❌ All changes are logged
- ❌ Can be traced back
- ⚠️ This is why Audit Log exists!

---

## 🛡️ What Staff CANNOT Do

Even if they access database directly:

| Action | Protection |
|--------|-----------|
| Delete tickets | Audit log shows deletion |
| Change citizen names | ID verification catches it |
| Complete tickets they didn't serve | Timestamp/counter mismatch |
| Forge QR codes | API validates against DB |
| Create fake tickets | Database integrity checks |
| Change timestamps | Logical sequence errors |
| Hide actions | Audit log records everything |

---

## 🎯 Recommended Security Measures

### **1. Database-Level Access Control**
```sql
-- Staff should NOT have direct database access
-- Only through API
-- API enforces business rules
```

### **2. Read-Only Replicas**
```
Main Database: Write access (API only)
Read Replica: For reporting/display (no write)
```

### **3. Regular Audit Log Review**
```
Manager reviews AuditLog weekly
Looks for suspicious patterns
Investigates anomalies
```

### **4. Database Backup & Recovery**
```
Daily backups
Can restore if fraud detected
Timestamps show when fraud occurred
```

### **5. User Activity Monitoring**
```
Monitor who logs in when
Track which portal is used
Flag unusual activity
```

---

## 📊 Real Example: Fraud Detection

**Scenario:**
Staff member "completes" tickets without serving them.

**Detection:**
```
1. Audit log shows: "TICKET_COMPLETED"
2. Database shows: completed_at = 14:30
3. Counter log shows: staff member X at counter 2
4. But citizen says: "I never came at 14:30"
5. Manager checks: Physical citizen list doesn't match DB

Result: ✅ Fraud detected and traced back to staff member X
```

---

## 🔒 Summary: Direct DB Modification

**Question:** What if staff modifies database directly?

**Answer:**
1. ✅ All modifications are logged in AuditLog
2. ✅ Cannot hide the change (logged before deletion)
3. ✅ ID verification catches mismatches
4. ✅ Timestamp logic reveals inconsistencies
5. ✅ Can trace back to which staff member
6. ✅ Discrepancies show up in reports

**Best Practice:**
- Staff should NEVER have direct database access
- All operations should go through API/Portals
- API enforces business rules
- Database is just data storage
- Audit Log is the security layer

---

**Status: Database is reasonably secure for this use case.**

The Audit Log and verification procedures make it very difficult for staff to commit fraud without being detected.

For maximum security, pair this with:
- Role-based access control (RBAC)
- Monthly audit reviews
- Backup & recovery procedures
- User activity logging

---

*Updated: February 17, 2026*
*Database: SQLite with 5 tables*
*Security: Protected by AuditLog + Verification + API Enforcement*

