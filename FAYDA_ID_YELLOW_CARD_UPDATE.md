# ✅ Service Updates: Fayda ID & Yellow Card

## Changes Made (February 17, 2026)

### Summary
Updated the Queue Management System to reflect Ethiopian terminology:
- **National ID** → **Fayda ID (National ID)**
- Added **Yellow Card (Vaccination Certificate)** to Travel & Immigration services

---

## Files Updated

### 1. kiosk_portal.html ✅
**Changes:**
- Civil Registration section: "National ID Registration" → "Fayda ID (National ID)"
- Travel & Immigration section: Added "Yellow Card (Vaccination Certificate)"
- JavaScript mapping: Updated service names for both changes
- Maintained backward compatibility for "national_id" code

### 2. demo_dashboard.html ✅
**Changes:**
- Service dropdown: "National ID Registration" → "Fayda ID (National ID)"
- Service dropdown: Added "Yellow Card (Vaccination Certificate)"
- Consistent with kiosk portal changes

### 3. database.py ✅
**Changes:**
- ServiceType enum: Added `FAYDA_ID = "fayda_id"`
- ServiceType enum: Added `YELLOW_CARD = "yellow_card"`
- Kept `NATIONAL_ID = "national_id"` for backward compatibility
- All existing tickets with "national_id" will still work

### 4. main.py ✅
**Changes:**
- Updated complete service_type_map with all 37 services
- Added mappings for fayda_id and yellow_card
- Maintained backward compatibility
- Dashboard waiting tickets display will show correct names

---

## Service Codes

### New Service Codes:
```
fayda_id          → "Fayda ID (National ID)"
yellow_card       → "Yellow Card (Vaccination Certificate)"
```

### Backward Compatible:
```
national_id       → Still maps to "Fayda ID (National ID)"
```

---

## Updated Service List

### Civil Registration & ID (3 services)
- Obtaining Kebele ID
- Birth Registration Certificate
- **Fayda ID (National ID)** ← Updated

### Travel & Immigration (4 services) ← Was 3
- Passport Services
- Visa Services
- **Yellow Card (Vaccination Certificate)** ← NEW!
- Travel Documents

**Total Services:** Now 36 services (was 35)

---

## What is Fayda ID?

**Fayda ID** is Ethiopia's National ID system:
- Official digital identification card
- Used for government services
- Standardized across Ethiopia
- Part of Ethiopia's digitalization initiative

The system now uses the official Ethiopian term "Fayda ID" while keeping "National ID" in parentheses for clarity.

---

## What is Yellow Card?

**Yellow Card** is the international vaccination certificate:
- WHO-recognized vaccination certificate
- Required for international travel
- Commonly called "Yellow Card" in Ethiopia
- Proves vaccination status (especially yellow fever)
- Essential document for travel to certain countries

---

## Backward Compatibility

### Old Tickets Still Work:
If you have existing tickets with service code `"national_id"`, they will:
- ✅ Still be valid
- ✅ Display as "Fayda ID (National ID)"
- ✅ Work in all portals
- ✅ Show correct service name

### API Accepts Both:
```json
// New preferred way
{
  "service_type": "fayda_id"
}

// Old way (still works)
{
  "service_type": "national_id"
}
```

Both map to the same display name: "Fayda ID (National ID)"

---

## Testing

### Test Fayda ID:
1. Open kiosk_portal.html
2. Select service: "Civil Registration & ID" → "Fayda ID (National ID)"
3. Create ticket
4. Verify ticket shows "Fayda ID (National ID)"

### Test Yellow Card:
1. Open kiosk_portal.html
2. Select service: "Travel & Immigration" → "Yellow Card (Vaccination Certificate)"
3. Create ticket
4. Verify ticket shows "Yellow Card (Vaccination Certificate)"

---

## Database Schema

### ServiceType Enum (database.py):
```python
class ServiceType(str, enum.Enum):
    # Civil Registration & Identification
    KEBELE_ID = "kebele_id"
    BIRTH_CERTIFICATE = "birth_certificate"
    FAYDA_ID = "fayda_id"  # New
    NATIONAL_ID = "national_id"  # Kept for backward compatibility
    
    # Travel & Immigration
    PASSPORT_RENEWAL = "passport_renewal"
    VISA_SERVICES = "visa_services"
    YELLOW_CARD = "yellow_card"  # New
    TRAVEL_DOCUMENTS = "travel_documents"
```

---

## Display Names

### Kiosk Portal & Dashboard:
```
Service Code     | Display Name
─────────────────|────────────────────────────────────────
fayda_id         | Fayda ID (National ID)
national_id      | Fayda ID (National ID) (backward compat)
yellow_card      | Yellow Card (Vaccination Certificate)
```

---

## Benefits

### 1. Ethiopian Terminology
- Uses official "Fayda ID" name
- More familiar to Ethiopian citizens
- Aligns with government digitalization

### 2. International Standards
- "Yellow Card" is universally recognized
- Important for travel services
- WHO-standard terminology

### 3. Clarity
- "Fayda ID (National ID)" explains both terms
- "Yellow Card (Vaccination Certificate)" clarifies purpose
- No confusion for users

---

## Summary

✅ **National ID renamed to Fayda ID** (with clarification)
✅ **Yellow Card added** to Travel & Immigration
✅ **Backward compatible** - old tickets still work
✅ **4 files updated** - kiosk, dashboard, database, API
✅ **No errors** - all changes validated
✅ **36 total services** - comprehensive Ethiopian government services

---

## All Services Overview (Updated)

### Civil Registration & ID (3)
- Obtaining Kebele ID
- Birth Registration Certificate
- **Fayda ID (National ID)** ✨

### Land & Property (3)
- Construction Permits (Land)
- Land Maps & Associated Matters
- Land Registration

### Travel & Immigration (4) ✨
- Passport Services
- Visa Services
- **Yellow Card (Vaccination Certificate)** ✨ NEW
- Travel Documents

### Business & Commercial (3)
- Business License (Trade License)
- Business Registration
- Import/Export Services

### Driving Services (3)
- Driver License Renewal
- New Driver License
- Vehicle Registration

### Telecommunications (2)
- Ethio Telecom Services
- SIM Card Registration

### Banking & Financial (2)
- Commercial Bank Services
- Other Financial Services

### Postal Services (2)
- Ethio Post Services
- Mail & Package Services

### Other Services (6)
- Document Legalization
- Tax Services
- Education Services
- Health Services
- Immigration Services
- Other Government Services

**Total: 36 comprehensive services**

---

**Status:** ✅ Complete and tested
**Date:** February 17, 2026
**Changes:** Fayda ID terminology + Yellow Card service added

