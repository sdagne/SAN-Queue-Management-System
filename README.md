# 🇪🇹 Queue Management System - Ethiopia

A secure, personalized ticketing and queue management system designed specifically for Ethiopia, preventing ticket reselling and improving public service efficiency.

## 🌟 Features

- **Identity-Based Ticketing**: One ticket per person, tied to their ID
- **Anti-Fraud Protection**: Prevents ticket reselling and broker activities
- **Real-time Queue Management**: Live display of current queue status
- **Multi-Counter Support**: Multiple service counters with different service types
- **Ticket Expiration**: Time-limited tickets to prevent hoarding
- **Verification System**: ID verification at service counter
- **Audit Trail**: Complete logging for security and analytics
- **QR Code Support**: Each ticket includes a QR code for quick scanning

## 🚀 Quick Start

### 1. Install Dependencies

```bash
pip install -r requirements.txt
```

### 2. Configure Environment

Copy `.env.example` to `.env` and update settings:

```bash
cp .env.example .env
```

### 3. Run the Application

```bash
python main.py
```

The server will start on `http://localhost:8000`

### 4. Access API Documentation

- Swagger UI: `http://localhost:8000/docs`
- ReDoc: `http://localhost:8000/redoc`

## 📋 API Endpoints

### Kiosk Endpoints (Ticket Issuing)

- `POST /api/tickets` - Create new ticket
- `GET /api/tickets/{ticket_number}` - Get ticket status

### Counter Endpoints (Service Staff)

- `POST /api/counters` - Create service counter
- `GET /api/counters` - List all counters
- `POST /api/counters/{counter_id}/call-next` - Call next person in queue
- `POST /api/counters/{counter_id}/verify` - Verify citizen ID at counter
- `POST /api/counters/{counter_id}/complete` - Mark service as completed

### Display Endpoints (Public Screens)

- `GET /api/display/queue-status` - Get current queue status for display

### Statistics Endpoints (Admin Dashboard)

- `GET /api/statistics` - Get system statistics and analytics

## 🏗️ Project Structure

```
Queue Management Standard/
├── main.py                 # FastAPI application
├── database.py            # Database models and configuration
├── models.py              # Pydantic request/response models
├── utils.py               # Utility functions
├── config.py              # Configuration settings
├── requirements.txt       # Python dependencies
├── .env.example          # Environment variables template
└── README.md             # This file
```

## 💾 Database Schema

### Tables

1. **citizens** - Citizen/user information (hashed IDs for privacy)
2. **tickets** - All ticket records with status tracking
3. **counters** - Service counter configuration
4. **audit_logs** - Security and fraud detection logs

## 🔐 Security Features

1. **ID Hashing**: All ID numbers are hashed using SHA-256
2. **One Active Ticket Rule**: Prevents multiple ticket requests
3. **Ticket Expiration**: Automatically expires after configured time
4. **Verification Required**: Must verify ID at counter
5. **Suspicious Activity Detection**: Flags unusual patterns
6. **Audit Logging**: Complete trail of all actions

## 🎯 Usage Examples

### Creating a Ticket (Kiosk)

```python
import requests

response = requests.post("http://localhost:8000/api/tickets", json={
    "id_number": "ABC123456",
    "full_name": "Tesfaye Bekele",
    "service_type": "immigration",
    "phone_number": "+251911234567"
})

ticket = response.json()
print(f"Ticket Number: {ticket['ticket_number']}")
print(f"Queue Position: {ticket['queue_position']}")
```

### Calling Next Ticket (Counter)

```python
response = requests.post("http://localhost:8000/api/counters/1/call-next")
result = response.json()
print(f"Now serving: {result['ticket_number']} at Counter {result['counter_number']}")
```

### Verifying Ticket (Counter)

```python
response = requests.post("http://localhost:8000/api/counters/1/verify", json={
    "ticket_number": "IM-023",
    "id_number": "ABC123456"
})
```

## 🛠️ Configuration

Edit `config.py` or `.env` file:

```python
# Ticket expiration time (hours)
TICKET_EXPIRY_HOURS=2

# Maximum queue size
MAX_QUEUE_SIZE=500

# Server configuration
HOST=0.0.0.0
PORT=8000
```

## 📊 Service Types

- Birth Certificate (`birth_certificate`)
- Tax Service (`tax_service`)
- Immigration (`immigration`)
- Business License (`business_license`)
- Passport Renewal (`passport_renewal`)
- Document Legalization (`document_legalization`)
- Other (`other`)

## 🔄 Ticket Status Flow

```
WAITING → CALLED → SERVING → COMPLETED
           ↓
        EXPIRED
        CANCELLED
```

## 🚦 Anti-Fraud Rules

1. **One Active Ticket**: Can't request another ticket while one is active
2. **Ticket Expiration**: Valid for 2 hours only
3. **ID Verification**: Must match at counter
4. **Rate Limiting**: Prevents rapid multiple requests
5. **Blacklist Support**: Can block problematic users

## 📈 Future Enhancements (Phase 2 & 3)

- [ ] Wait time prediction using AI
- [ ] Crowd analytics and peak hour detection
- [ ] Voice assistant in Amharic
- [ ] Integration with Fayda National ID
- [ ] SMS notifications
- [ ] Mobile app for citizens
- [ ] Advanced fraud detection with ML
- [ ] Multi-language support
- [ ] Thermal printer integration
- [ ] NFC card reader support

## 🤝 Contributing

This is a prototype/MVP implementation. Contributions are welcome!

## 📄 License

Proprietary - Queue Management Standard Ethiopia

## 📞 Support

For questions or support, please contact the development team.

---

**Built for Ethiopia 🇪🇹 | Making Public Services Fair and Efficient**

