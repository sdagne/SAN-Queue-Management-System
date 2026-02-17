# 📊 Database Data Flow Diagram

## Visual Overview of What Each Portal Accesses

```
┌─────────────────────────────────────────────────────────────────┐
│                         DATABASE (SQLite)                       │
│                                                                 │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐         │
│  │  Citizens    │  │   Tickets    │  │  Counters    │         │
│  │              │  │              │  │              │         │
│  │ id_hash      │  │ ticket_#     │  │ counter_#    │         │
│  │ full_name    │  │ citizen_id   │  │ counter_name │         │
│  │ phone        │  │ status       │  │ services     │         │
│  │ blacklist    │  │ counter_#    │  │ is_active    │         │
│  │              │  │ timestamps   │  │ staff_name   │         │
│  └──────────────┘  └──────────────┘  └──────────────┘         │
│                                                                 │
│  ┌────────────────────────────────────────────────────────┐   │
│  │           AUDIT_LOGS (Security Layer)                 │   │
│  │   action | who | when | what | ip | is_suspicious    │   │
│  │   ✓ Every action logged                               │   │
│  │   ✓ Cannot be hidden                                  │   │
│  └────────────────────────────────────────────────────────┘   │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
     ▲                    ▲                    ▲              ▲
     │                    │                    │              │
     │ LIMITED            │ MODERATE           │ READ-ONLY    │ FULL
     │ ACCESS             │ ACCESS             │ ACCESS       │ ADMIN
     │                    │                    │              │
┌────┴─────┐      ┌──────┴──────┐      ┌─────┴─────┐   ┌────┴────┐
│  KIOSK   │      │  COUNTER    │      │ DISPLAY   │   │  DEMO   │
│ PORTAL   │      │ PORTAL      │      │ PORTAL    │   │DASHBOARD│
└──────────┘      └─────────────┘      │           │   └─────────┘
   CREATE            READ/UPDATE         READ ONLY
   TICKET            TICKET STATUS       MONITORING
   VERIFY            CALL NEXT           STATISTICS
   CITIZEN           COMPLETE
```

---

## Data Flow: Citizen's Journey

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│  1. KIOSK PORTAL                                               │
│     │                                                           │
│     ├─ Citizen scans ID                                        │
│     ├─ System hashes ID → hash("EP2121")                      │
│     ├─ INSERT Citizens (id_hash, name, phone)                 │
│     ├─ INSERT Tickets (citizen_id, status=waiting)           │
│     └─ INSERT AuditLog (action=TICKET_CREATED)               │
│                                                                 │
│        DB Now Contains:                                        │
│        Citizens: [EP2121***, Shewan Dagne, ...]              │
│        Tickets: [DL-026, waiting, EP2121***, ...]           │
│                                                                 │
│  2. DISPLAY PORTAL                                             │
│     │                                                           │
│     ├─ SELECT Tickets WHERE status IN (called, serving)     │
│     ├─ Shows: "DL-026 - WAITING"                             │
│     └─ Auto-refreshes every 3 seconds                        │
│                                                                 │
│        (READ-ONLY - No changes to DB)                         │
│                                                                 │
│  3. COUNTER PORTAL (Staff calls ticket)                       │
│     │                                                           │
│     ├─ SELECT Tickets WHERE status=waiting ORDER BY created  │
│     ├─ Click "CALL NEXT PERSON" → DL-026                   │
│     ├─ UPDATE Tickets SET status=called, counter_#=1        │
│     ├─ UPDATE Counters SET current_ticket_id=123            │
│     ├─ INSERT AuditLog (action=TICKET_CALLED)               │
│     └─ Display shows: "DL-026 at COUNTER 1"                │
│                                                                 │
│        DB Now Contains:                                        │
│        Tickets: [DL-026, called, EP2121***, counter=1, ...]  │
│        AuditLog: [..., TICKET_CALLED, ...]                  │
│                                                                 │
│  4. COUNTER PORTAL (Verify ID)                                │
│     │                                                           │
│     ├─ Staff enters ID that citizen shows: EP2121            │
│     ├─ System hashes it: hash("EP2121")                     │
│     ├─ VERIFY: hash("EP2121") == Tickets.id_number_hash   │
│     ├─ Result: ✓ MATCH                                       │
│     └─ INSERT AuditLog (action=VERIFICATION_SUCCESS)        │
│                                                                 │
│        (NO DB CHANGE - just verification)                     │
│                                                                 │
│  5. COUNTER PORTAL (Complete Service)                         │
│     │                                                           │
│     ├─ Staff provides service...                             │
│     ├─ Click "MARK AS COMPLETED"                            │
│     ├─ UPDATE Tickets SET status=completed, completed_at   │
│     ├─ UPDATE Counters SET current_ticket_id=NULL          │
│     ├─ INSERT AuditLog (action=TICKET_COMPLETED)           │
│     └─ Display updates: "DL-026 is COMPLETED"              │
│                                                                 │
│        DB Now Contains:                                        │
│        Tickets: [DL-026, completed, ...]                    │
│        AuditLog: [..., TICKET_COMPLETED, timestamp, ...]   │
│                                                                 │
│  6. DEMO DASHBOARD (Manager Reviews)                          │
│     │                                                           │
│     ├─ Manager checks AuditLog                              │
│     ├─ Sees: TICKET_CREATED → TICKET_CALLED → VERIFIED →  │
│     │         TICKET_COMPLETED                               │
│     ├─ All timestamps are logical                            │
│     ├─ Citizen was served correctly                          │
│     └─ Everything checks out! ✓                             │
│                                                                 │
│        (FULL VIEW of system)                                  │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Security Check Points

```
┌─────────────────────────────────────────────────────────────────┐
│                   SECURITY LAYERS                              │
│                                                                 │
│  Layer 1: API Validation                                       │
│  ├─ All data goes through API (FastAPI)                      │
│  ├─ API enforces business rules                              │
│  ├─ Cannot skip verification                                 │
│  └─ Invalid requests rejected                                │
│                                                                 │
│  Layer 2: Database Constraints                                │
│  ├─ Unique constraints (no duplicate tickets)               │
│  ├─ Foreign key constraints                                  │
│  ├─ Status enum (only valid values)                         │
│  └─ Timestamp validation                                     │
│                                                                 │
│  Layer 3: Audit Trail                                         │
│  ├─ Every action logged                                      │
│  ├─ Who did it, what they did, when, from where            │
│  ├─ Suspicious flags set automatically                      │
│  └─ Cannot be deleted (is security layer)                   │
│                                                                 │
│  Layer 4: ID Verification                                     │
│  ├─ ID hashed (one-way encryption)                          │
│  ├─ Must match at verification                              │
│  ├─ Mismatch = ticket rejected                              │
│  └─ Physical ID must be shown                               │
│                                                                 │
│  Layer 5: Access Control                                      │
│  ├─ Kiosk: Limited (create only)                            │
│  ├─ Counter: Moderate (read/update status)                  │
│  ├─ Display: Read-only (no modifications)                   │
│  ├─ Demo: Full admin (but logged)                           │
│  └─ Direct DB: NOT RECOMMENDED                              │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## What Happens If Staff Tries to Cheat

```
FRAUD ATTEMPT: Mark ticket as completed without serving

┌──────────────────────────────────────────────────────────────┐
│  Staff directly updates database:                             │
│  UPDATE tickets SET status='completed' WHERE ticket='DL-026'│
└──────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌──────────────────────────────────────────────────────────────┐
│  System Detects:                                             │
│                                                               │
│  1. AuditLog shows:                                          │
│     action: UPDATE_TICKET_DIRECT                            │
│     timestamp: 14:30:45                                     │
│     ip_address: 192.168.1.100                              │
│     staff_id: 5                                             │
│     ↓ Flag: is_suspicious = TRUE                            │
│                                                               │
│  2. Timestamp Check:                                         │
│     created_at: 10:00:00                                   │
│     called_at: NULL (was never called!)                    │
│     completed_at: 14:30:45 (just now)                      │
│     ↓ Inconsistency detected!                              │
│                                                               │
│  3. Citizen Verification:                                    │
│     Citizen never came to counter                           │
│     No ID verification recorded                             │
│     No "VERIFICATION_SUCCESS" in AuditLog                  │
│     ↓ Mismatch!                                            │
│                                                               │
│  4. Next Ticket Issue:                                       │
│     System tries to call next ticket                        │
│     But citizen for DL-026 comes asking "Where am I?"      │
│     They never went to counter                             │
│     ↓ Citizen complaint!                                   │
│                                                               │
└──────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌──────────────────────────────────────────────────────────────┐
│  Manager Catches Fraud:                                       │
│                                                               │
│  Daily AuditLog Review:                                      │
│  ✓ Found suspicious action                                  │
│  ✓ Found timestamp inconsistency                            │
│  ✓ Found no verification record                             │
│  ✓ Found citizen complaint                                  │
│  ✓ Traced back to staff member                              │
│                                                               │
│  Investigation:                                              │
│  • Query AuditLog for staff member's actions               │
│  • Find pattern: 20 tickets marked complete with no calls  │
│  • Cross-reference with citizen complaints                  │
│  • Verify with physical sign-in sheets                     │
│                                                               │
│  Result: FRAUD DETECTED & TRACED                           │
│                                                               │
└──────────────────────────────────────────────────────────────┘
                            │
                            ▼
              Disciplinary Action Against Staff
```

---

## Table Structure Details

### Citizens Table
```
id (Primary Key)      | Unique ID in system
id_number_hash        | Hashed citizen ID (one-way)
full_name             | Citizen's name
phone_number          | Contact number
created_at            | When first registered
is_blacklisted        | Fraud flag
blacklist_reason      | Why blacklisted
```

### Tickets Table (Most Important)
```
id (PK)               | Unique ticket ID
ticket_number         | Display number (DL-026)
citizen_id (FK)       | Links to Citizens table
id_number_hash        | Copy of hashed ID (for verification)
full_name             | Copy of name
service_type          | Type of service
status                | waiting, called, serving, completed, etc.
counter_number        | Which counter is/was serving
created_at            | When created
called_at             | When called to counter
served_at             | When started serving
completed_at          | When finished
expires_at            | When ticket expires
qr_code               | QR code data for scanning
```

### Counters Table
```
id (PK)               | Unique counter ID
counter_number        | Display number (1, 2, 3...)
counter_name          | Friendly name
service_types         | Services offered
is_active             | Is counter operating?
current_ticket_id     | What's being served now
staff_name            | Staff member's name
```

### AuditLog Table (Security!)
```
id (PK)               | Log entry ID
action                | TICKET_CREATED, TICKET_CALLED, etc.
citizen_id (FK)       | Who's involved
ticket_id (FK)        | Which ticket
counter_id (FK)       | Which counter
details               | Additional info
ip_address            | Where request came from
timestamp             | Exact time of action
is_suspicious         | Fraud flag
```

---

## Access Pattern Summary

```
KIOSK: W──R────────────────────────────
       Write new → Read to verify exists

COUNTER: ──R────→U──────→U──────────────
         Read queue → Update status → Update counter

DISPLAY: ──────R──────────────────────R─
         Read only, auto-refresh

DEMO: ───────RRR──────UUUUU──────────UU─
      Full access for admin/testing

AUDIT: ─────────────────────────────────
       Always recording (background)
```

---

**Key Takeaway:** The database is protected by multiple layers of security. Even if staff tries to modify data directly, the audit trail and verification procedures will catch them.


