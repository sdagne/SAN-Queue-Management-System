# ✅ Quick Action Checklist: Test Ticket LR-036

## Your Test Case

**Created:** Ticket LR-036  
**ID:** EP001  
**Name:** Tesfaye Getachew  
**Service:** Land Registration  

---

## 🎯 What to Do Now (Step-by-Step)

### **STEP 1: ✅ DONE - Ticket Created**

You already created ticket LR-036 with ID EP001 at the kiosk.

---

### **STEP 2: 🏢 Go to Counter Portal**

**Action:** Open `counter_portal.html`

**What you'll see:**
```
┌────────────────────────────────────┐
│ Counter Staff Portal               │
│ Counter 1                          │
│                                    │
│ Waiting: [number]                  │
│ Served Today: [number]             │
│                                    │
│ [CALL NEXT PERSON] 🔵             │
└────────────────────────────────────┘
```

---

### **STEP 3: 📞 Call Next Person**

**Action:** Click the big blue **[CALL NEXT PERSON]** button

**What happens:**
- System fetches next waiting ticket (LR-036)
- Assigns it to Counter 1
- Status changes: WAITING → CALLED
- Display screen updates

**What you'll see on counter portal:**
```
┌────────────────────────────────────┐
│ NOW SERVING:                       │
│                                    │
│ Ticket: LR-036                     │
│ Name: Tesfaye Getachew             │
│                                    │
│ Status: CALLED                     │
└────────────────────────────────────┘
```

**What display_portal.html shows:**
```
📺 NOW SERVING
   LR-036 → COUNTER 1
   Tesfaye Getachew
```

---

### **STEP 4: 🔐 Verify ID**

**Scenario:** Citizen (Tesfaye) comes to your counter

**Staff says:** "Please show me your ID card"

**Citizen shows:** Physical ID card with number **EP001**

**Action in counter_portal.html:**

Scroll down to the verification section:

```
Verify Ticket: [LR-036        ]  ← Type your ticket number
Verify ID:     [EP001         ]  ← Type the ID from citizen's card
               
[VERIFY ID] 🔵  ← Click this button
```

**Step-by-step:**
1. In "Verify Ticket" field, type: **LR-036**
2. In "Verify ID" field, type: **EP001**
3. Click the **[VERIFY ID]** button

**Expected Result:**
```
✅ Verification Successful!
Ticket LR-036 verified
You may now provide the service
```

**If you get error:**
- Make sure you typed **EP001** exactly (no spaces)
- Case sensitive: EP001 (not ep001)
- Must match the ID used at kiosk

---

### **STEP 5: 💼 Provide Service (Simulate)**

**In real world:**
- Staff would help with land registration
- Process documents
- Answer questions
- Complete the service

**For testing:**
- Just wait a few seconds (simulate service time)
- Pretend you helped with land registration

---

### **STEP 6: ✅ Mark as Completed**

**Action in counter_portal.html:**

Scroll down to the completion section:

```
Complete Service: [LR-036        ]  ← Type your ticket number
               
[MARK AS COMPLETED] 🔵  ← Click this button
```

**Step-by-step:**
1. In "Complete Service" field, type: **LR-036**
2. Click the **[MARK AS COMPLETED]** button

**Expected Result:**
```
✅ Service completed successfully!
Ticket LR-036 marked as completed
Counter is now available
```

**What happens:**
- Ticket status: CALLED → COMPLETED
- Counter is freed
- Statistics updated (Served Today +1)
- Ready for next person

---

### **STEP 7: 🎉 Done! Call Next Person**

**Action:** Click **[CALL NEXT PERSON]** again to serve the next waiting ticket

The cycle repeats!

---

## 📋 Quick Reference Card for Testing

### **Your Ticket Details:**
```
Ticket: LR-036
ID: EP001
Name: Tesfaye Getachew
Service: Land Registration
```

### **Counter Portal Actions:**
```
1. Click: [CALL NEXT PERSON]
   → System shows: LR-036 - Tesfaye Getachew

2. Enter Verify Ticket: LR-036
   Enter Verify ID: EP001
   Click: [VERIFY ID]
   → Result: ✅ Verification successful!

3. (Provide service - simulate)

4. Enter Complete Service: LR-036
   Click: [MARK AS COMPLETED]
   → Result: ✅ Service completed!

5. Click: [CALL NEXT PERSON]
   → Ready for next ticket!
```

---

## 🔄 Alternative: Check Other Portals

### **Before Going to Counter:**

**Optional 1: Check Display Portal**
- Open `display_portal.html`
- See waiting tickets on display screen
- This is what citizens see in waiting area

**Optional 2: Check Dashboard**
- Open `demo_dashboard.html`
- Scroll to "All Waiting Tickets"
- See LR-036 in the waiting list with:
  - Position in queue
  - Your name: Tesfaye Getachew
  - Service: Land Registration
  - ID partial hash
  - Created time with date

**But for testing, you can go straight to counter_portal.html!**

---

## ⚠️ Important Notes

### **The ID Number (EP001):**

- ✅ You must remember it or write it down
- ✅ You'll need it for verification at counter
- ✅ Staff gets it from citizen's physical ID card
- ❌ Staff cannot see it in the system beforehand
- ❌ This is for security (prevents fraud)

### **If Verification Fails:**

**Error:** "ID does not match ticket. Verification failed."

**Reasons:**
- You typed wrong ID
- You typed EP001 with spaces
- You typed lowercase: ep001

**Solution:**
- Type exactly: **EP001**
- No spaces, correct case
- Should work!

---

## 🎯 Your Next Actions

### **Now that you created ticket LR-036:**

**Action 1:** Open `counter_portal.html`

**Action 2:** Click `[CALL NEXT PERSON]` button

**Action 3:** See LR-036 displayed

**Action 4:** Verify with ID: **EP001**

**Action 5:** Mark as completed

**Action 6:** Test complete! ✅

---

## 📱 Optional: Create More Tickets

Want to test with multiple tickets?

**Create another ticket:**
1. Go back to kiosk_portal.html
2. Use different ID: **EP002**
3. Name: Another Name
4. Service: Different service
5. Get new ticket number

**At counter:**
1. Call first ticket (LR-036) → Verify with EP001
2. Complete LR-036
3. Call second ticket → Verify with EP002
4. Complete second ticket

Test multiple ticket flow!

---

## ✅ Summary: What to Do Now

**You are here:** ✅ Ticket LR-036 created

**Next step:** 🏢 Go to counter_portal.html

**Actions at counter:**
1. Click [CALL NEXT PERSON] → Shows LR-036
2. Enter Verify ID: EP001 → Verification successful
3. Click [MARK AS COMPLETED] → Service done
4. Repeat for next ticket!

---

**That's it! Simple workflow!** 🎉

---

*Quick Action Guide*  
*Your Ticket: LR-036*  
*Your ID: EP001*  
*Ready to test at counter!*

