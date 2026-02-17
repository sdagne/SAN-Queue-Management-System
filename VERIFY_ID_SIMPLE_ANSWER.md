# ✅ VERIFY ID - What to Enter (Simple Answer)

## 🎯 Quick Answer to Your Question

**Question:** "In counter_portal when I verify ID, what should I use if you hash it?"

**Answer:** Enter the **PLAIN/ORIGINAL ID number** - the system automatically hashes it for you!

---

## ✅ What to Enter in "Verify ID" Field

### **DO NOT enter the hash! Enter the ORIGINAL ID:**

**Example:**

**WRONG:** ❌
```
Verify ID: a3f7b9c2e4d1f6*** (trying to enter the hash)
```

**CORRECT:** ✅
```
Verify ID: EP2121 (the original ID number)
```

---

## 🔄 How It Actually Works

### **Behind the Scenes:**

```
Step 1: You enter in counter_portal:
  Verify Ticket: DL-026
  Verify ID: EP2121  ← You enter PLAIN ID

Step 2: System automatically hashes it:
  id_hash = hash_id_number("EP2121")
  id_hash = "a3f7b9c2e4d1f6..."

Step 3: System compares hashes:
  provided_hash == stored_hash?
  "a3f7b9c2..." == "a3f7b9c2..."?
  YES! ✅ Match!

Step 4: System responds:
  "✅ Verification successful!"
```

---

## 💡 The Code (From main.py)

```python
@app.post("/api/counters/{counter_id}/verify")
async def verify_ticket_id(
    counter_id: int,
    request: TicketVerifyRequest,
    db: Session = Depends(get_db)
):
    # Get ticket from database
    ticket = db.query(Ticket).filter(
        Ticket.ticket_number == request.ticket_number
    ).first()
    
    # Hash the ID you entered
    id_hash = hash_id_number(request.id_number)  ← System hashes it!
    
    # Compare with stored hash
    if ticket.id_number_hash != id_hash:
        raise HTTPException(
            status_code=403,
            detail="ID does not match ticket. Verification failed."
        )
    
    return {"message": "Verification successful"}
```

**Key Line:**
```python
id_hash = hash_id_number(request.id_number)  # System hashes it for you!
```

---

## 📋 Complete Example

### **Scenario: Your Ticket DL-026**

#### **At Kiosk (Yesterday):**
```
You entered:
  ID Number: EP2121
  Full Name: Shewan Dagne
  Service: Document Legalization

System stored in database:
  ticket_number: "DL-026"
  id_number_hash: hash("EP2121") = "a3f7b9c2e4d1f6..."
  full_name: "Shewan Dagne"
```

#### **At Counter (Today):**
```
You enter in counter_portal:
  Verify Ticket: DL-026
  Verify ID: EP2121  ← Enter PLAIN ID (not the hash!)

System processes:
  1. Hash the provided ID: hash("EP2121") = "a3f7b9c2e4d1f6..."
  2. Get stored hash for DL-026: "a3f7b9c2e4d1f6..."
  3. Compare: "a3f7b9c2..." == "a3f7b9c2..."?
  4. Result: YES! ✅

System returns:
  ✅ Verification successful!
```

---

## 🎯 Simple Rule

### **Always Enter the ORIGINAL/PLAIN ID Number**

**From citizen's physical ID card:**
- Fayda ID: FAY123456789
- Kebele ID: KEE/2023/12345
- Passport: EP2121
- Driver License: DL789456

**The system handles hashing automatically!**

---

## ❌ Common Mistakes

### **Mistake 1: Trying to Enter the Hash**
```
❌ WRONG:
Verify ID: a3f7b9c2e4d1f6***

Why wrong?
- You see hash in the "All Waiting Tickets" table
- You think you need to enter the hash
- But system expects PLAIN ID!

✅ CORRECT:
Verify ID: EP2121
```

### **Mistake 2: Entering Different ID**
```
❌ WRONG:
Ticket created with: EP2121
You enter: EP1234

Why wrong?
- Different ID number
- Hashes won't match

✅ CORRECT:
Ticket created with: EP2121
You enter: EP2121 (exact same)
```

### **Mistake 3: Extra Spaces**
```
❌ WRONG:
Ticket created with: EP2121
You enter: EP 2121 (space in middle)

Why wrong?
- System sees "EP 2121" ≠ "EP2121"
- Different strings = different hashes

✅ CORRECT:
Ticket created with: EP2121
You enter: EP2121 (no spaces)
```

---

## 🔐 Security Flow

### **Complete Security Process:**

```
┌─────────────────────────────────────────────────────────────┐
│  KIOSK: Citizen enters plain ID                            │
│  Input: EP2121                                             │
│  System: hash("EP2121") → Store: "a3f7b9c2..."            │
└─────────────────────────────────────────────────────────────┘
                          ⬇
                    DATABASE STORES
                    (hashed version)
                          ⬇
┌─────────────────────────────────────────────────────────────┐
│  COUNTER: Staff enters plain ID                            │
│  Input: EP2121                                             │
│  System: hash("EP2121") → Compare: "a3f7b9c2..."         │
│  Match? ✅ Success!                                        │
└─────────────────────────────────────────────────────────────┘
```

**You always enter plain ID - system handles hashing!**

---

## 📊 What Shows Where

### **In Demo Dashboard "All Waiting Tickets" Table:**

Shows partial HASH (for privacy):
```
ID Number column: a3f7b9c2***
```

This is just for DISPLAY/REFERENCE. You cannot use this hash!

### **In Counter Portal "Verify ID" Field:**

Enter PLAIN ID (system hashes it):
```
Verify ID: EP2121  ← Plain ID from physical card
```

---

## 🧪 Testing: Correct Way

### **Step-by-Step Test:**

**1. Create Ticket at Kiosk:**
```
Open: kiosk_portal.html
Enter ID: TEST12345  ← Remember this!
Enter Name: Test User
Service: Any service
Get ticket: [Note the ticket number, e.g., IM-031]
```

**2. View in Dashboard (Optional):**
```
Open: demo_dashboard.html
Scroll to: All Waiting Tickets
See: IM-031 with ID hash like "b8e4d1***"
```

**3. Verify at Counter:**
```
Open: counter_portal.html
Click: "CALL NEXT PERSON"
Shows: IM-031 - Test User

Enter Verify Ticket: IM-031
Enter Verify ID: TEST12345  ← PLAIN ID (same as Step 1!)
Click: "VERIFY ID"

Expected Result: ✅ Verification successful!
```

**4. Complete Service:**
```
Enter Complete Service: IM-031
Click: "MARK AS COMPLETED"
Done! ✅
```

---

## 🎯 Key Takeaway

### **YOU ALWAYS ENTER PLAIN ID, NOT THE HASH!**

**Why?**
- System automatically hashes it for comparison
- You don't need to do any hashing manually
- Just read the ID from citizen's physical card
- Type it exactly as shown
- System handles the rest!

**Code handles hashing:**
```python
# This happens automatically in the backend:
id_hash = hash_id_number(request.id_number)
```

---

## ✅ Summary

**Question:** What should I use for Verify ID if you hash it?

**Answer:** Use the **PLAIN/ORIGINAL ID number** (e.g., EP2121)

**DON'T use:** The hash you see in the dashboard (e.g., a3f7b9c2***)

**System does:** Automatic hashing when you click "VERIFY ID"

**You just:** Type the ID from the citizen's physical ID card

---

## 📖 Real-World Example

**Citizen comes to counter:**

**Staff:** "Please show me your ID card"

**Citizen shows:** Fayda ID with number FAY0012345678

**Staff types in counter portal:**
```
Verify Ticket: PR-045
Verify ID: FAY0012345678  ← Exactly as shown on ID card
```

**Staff clicks:** "VERIFY ID"

**System does (automatically):**
```
1. Hash the provided ID: hash("FAY0012345678")
2. Get stored hash for ticket PR-045
3. Compare hashes
4. If match: ✅ Success!
```

**Staff sees:** "✅ Verification successful!"

---

**No manual hashing needed! Just enter the plain ID from the physical card!** ✅

---

*Updated: February 17, 2026*
*Topic: Counter Portal - What to Enter in Verify ID*
*Answer: PLAIN ID (system hashes automatically)*

