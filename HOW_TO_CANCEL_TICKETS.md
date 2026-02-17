# 🗑️ How to Cancel/Kill Stuck Tickets

## Problem: "You already have an active ticket"

When you see this error:
```
❌ Failed to create ticket: You already have an active ticket: IM-001. 
   Please wait to be served.
```

This means you (or that ID) already has an active ticket in the system.

---

## 🚀 SOLUTIONS (4 Ways)

### ✅ METHOD 1: Use Demo Dashboard (EASIEST)

1. **Open**: `demo_dashboard.html`
2. **Go to**: "🗑️ Ticket Management" section
3. **Enter**: Your ID number
4. **Click**: "🔍 Check Active Tickets" to see what you have
5. **Click**: "🗑️ Cancel All Tickets" to remove them
6. **Done!** Now you can create a new ticket

---

### ✅ METHOD 2: Use Cancel Ticket Script

**Option A: Double-click the batch file**
```
📁 Double-click: CANCEL_TICKET.bat
Follow the prompts
```

**Option B: Run from console**
```powershell
cd "D:\Queue Management Standard"
python cancel_ticket.py quick
```

**Quick commands:**
```powershell
# Check active tickets for an ID
python cancel_ticket.py check ABC123456

# Cancel all tickets for an ID
python cancel_ticket.py cancel ABC123456
```

---

### ✅ METHOD 3: Use API Directly

**Check what tickets exist:**
```powershell
curl "http://localhost:8000/api/tickets/active/ABC123456"
```

**Cancel all tickets for an ID:**
```powershell
curl -X DELETE "http://localhost:8000/api/tickets/cancel-by-id?id_number=ABC123456"
```

**Cancel specific ticket:**
```powershell
curl -X DELETE "http://localhost:8000/api/tickets/IM-001/cancel?id_number=ABC123456"
```

---

### ✅ METHOD 4: Reset Database (Nuclear Option)

**If nothing else works:**
```powershell
cd "D:\Queue Management Standard"

# Stop server (CTRL+C)

# Delete database
Remove-Item queue_management.db

# Restart server
python run_server.py
```

⚠️ **Warning**: This deletes ALL tickets and data!

---

## 📚 New API Endpoints Added

### 1. Check Active Tickets
```http
GET /api/tickets/active/{id_number}
```
Returns all active tickets for a given ID.

### 2. Cancel All Tickets by ID
```http
DELETE /api/tickets/cancel-by-id?id_number={id}
```
Cancels ALL active tickets for an ID (most useful for stuck tickets).

### 3. Cancel Specific Ticket
```http
DELETE /api/tickets/{ticket_number}/cancel?id_number={id}
```
Cancel a specific ticket (requires ID verification).

### 4. Force Expire Ticket
```http
POST /api/tickets/{ticket_number}/expire
```
Admin function to force expire a ticket.

---

## 🎯 Step-by-Step Example

### Scenario: User "ABC123" has stuck ticket "IM-001"

**Step 1: Check what tickets exist**
```powershell
curl http://localhost:8000/api/tickets/active/ABC123
```

**Response:**
```json
{
  "message": "Found 1 active ticket(s)",
  "tickets": [
    {
      "ticket_number": "IM-001",
      "service_type": "immigration",
      "status": "waiting",
      "created_at": "2026-02-17T08:30:00",
      "expires_at": "2026-02-17T10:30:00"
    }
  ]
}
```

**Step 2: Cancel the ticket**
```powershell
curl -X DELETE "http://localhost:8000/api/tickets/cancel-by-id?id_number=ABC123"
```

**Response:**
```json
{
  "message": "Cancelled 1 ticket(s)",
  "cancelled_tickets": ["IM-001"]
}
```

**Step 3: Create new ticket**
```powershell
# Now you can create a new ticket successfully!
```

---

## 🔧 Troubleshooting

### Q: Can't cancel ticket - "ID does not match"
**A:** You need to use the SAME ID number that was used to create the ticket.

### Q: Cancelled but still getting error
**A:** Wait 2-3 seconds and try again. Or refresh the page/restart.

### Q: Don't know which ID was used
**A:** Use METHOD 4 (reset database) or check the database directly.

### Q: Script says "Server not running"
**A:** Start the server first:
```powershell
python run_server.py
```

---

## 📋 Quick Reference Card

```
┌────────────────────────────────────────────────────────┐
│  STUCK TICKET? HERE'S HOW TO FIX IT                   │
├────────────────────────────────────────────────────────┤
│                                                        │
│  EASIEST:                                             │
│  1. Open demo_dashboard.html                          │
│  2. Use "Ticket Management" section                   │
│  3. Enter ID → Click "Cancel All Tickets"            │
│                                                        │
│  CONSOLE:                                             │
│  python cancel_ticket.py quick                        │
│                                                        │
│  BATCH FILE:                                          │
│  Double-click CANCEL_TICKET.bat                       │
│                                                        │
│  API:                                                 │
│  curl -X DELETE "http://localhost:8000/               │
│    api/tickets/cancel-by-id?id_number=YOUR_ID"       │
│                                                        │
└────────────────────────────────────────────────────────┘
```

---

## 🎓 Understanding Ticket Status

**Active Statuses** (blocks new tickets):
- `waiting` - In queue
- `called` - Called to counter
- `serving` - Being served

**Inactive Statuses** (allows new tickets):
- `completed` - Service finished
- `cancelled` - Cancelled by user
- `expired` - Ticket expired

---

## 🚀 Prevention Tips

1. **Complete service workflow**: Always mark tickets as complete after serving
2. **Set shorter expiry**: Reduce ticket expiration time if needed (edit `config.py`)
3. **Auto-cleanup**: Consider adding a cron job to expire old tickets
4. **User education**: Teach users to cancel if they leave

---

## 📞 Need Help?

1. Check `demo_dashboard.html` - Visual tool with cancel button
2. Run `python cancel_ticket.py` - Interactive menu
3. Check server logs - See what's happening
4. Read API docs - http://localhost:8000/docs

---

## ✅ Summary

**Problem**: Active ticket blocking new ticket creation  
**Solution**: Cancel the active ticket using one of 4 methods  
**Easiest**: Use demo dashboard or CANCEL_TICKET.bat  
**Result**: Can create new tickets again  

---

*Last Updated: February 17, 2026*  
*Part of Queue Management System Documentation*

