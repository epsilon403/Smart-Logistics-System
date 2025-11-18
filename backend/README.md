# Backend - Real-time Logistics Event Streaming

## 📡 WebSocket Server

Simple FastAPI-based WebSocket server that generates and streams random shipment events.

### Features

- ✅ **Real-time streaming** - 2 events per second by default
- ✅ **Multiple clients** - Supports concurrent WebSocket connections
- ✅ **Auto-start** - Begins streaming on server startup
- ✅ **Clean schema** - Matches `df_cleaned` columns from the notebook
- ✅ **Health check** - REST endpoint at `/`

---

## 🚀 Quick Start

### 1. Install Dependencies

```bash
pip install fastapi uvicorn websockets
```

### 2. Start the Server

```bash
cd backend
python websocket.py
```

You should see:
```
🌐 Starting WebSocket Server...
📡 WebSocket URL: ws://localhost:8000/ws
🔗 API Docs: http://localhost:8000/docs
INFO:     Started server process
INFO:     Uvicorn running on http://0.0.0.0:8000
```

### 3. Test the Stream

In another terminal:

```bash
python test_client.py
```

---

## 📊 Event Schema

Each event contains:

```json
{
  "Type": "DEBIT",
  "Days for shipment (scheduled)": 4,
  "Benefit per order": 125.50,
  "Sales per customer": 450.75,
  "Late_delivery_risk": 1,
  "Customer City": "Casablanca",
  "Customer Country": "Morocco",
  "Latitude": 33.5731,
  "Longitude": -7.5898,
  "Market": "Africa",
  "Order City": "Agadir",
  "Order Country": "Morocco",
  "Order Region": "North",
  "Order State": "Active",
  "Product Category Id": 12,
  "Product Price": 89.99,
  "Product Status": 1,
  "Shipping Mode": "Standard Class",
  "shipping date (DateOrders)": "11/22/2025 14:30",
  "Order Item Quantity": 3,
  "Sales": 850.00,
  "Order Status": "COMPLETE",
  "event_time": "2025-11-19T08:30:45.123456Z"
}
```

---

## 🔧 API Endpoints

### WebSocket

- **URL:** `ws://localhost:8000/ws`
- **Purpose:** Connect to receive real-time events

### REST

- **GET** `/` - Health check
  ```json
  {
    "status": "running",
    "connected_clients": 2,
    "websocket_url": "ws://localhost:8000/ws"
  }
  ```

- **GET** `/docs` - Interactive API documentation (Swagger UI)

---

## 💡 Usage Examples

### Python Client

```python
import asyncio
import websockets
import json

async def consume_events():
    async with websockets.connect("ws://localhost:8000/ws") as ws:
        while True:
            message = await ws.recv()
            event = json.loads(message)
            print(f"Late Risk: {event['Late_delivery_risk']}, "
                  f"City: {event['Customer City']}")

asyncio.run(consume_events())
```

### JavaScript Client

```javascript
const ws = new WebSocket('ws://localhost:8000/ws');

ws.onmessage = (event) => {
  const data = JSON.parse(event.data);
  console.log(`Risk: ${data.Late_delivery_risk}, City: ${data['Customer City']}`);
};
```

---

## ⚙️ Configuration

To change the event rate, modify this line in `websocket.py`:

```python
asyncio.create_task(broadcast_events(rate_per_sec=2.0))  # Change 2.0 to desired rate
```

---

## 📁 Files

```
backend/
├── websocket.py      # Main WebSocket server
├── test_client.py    # Test client to verify streaming
├── streaming.ipynb   # Spark Streaming integration (TODO)
└── README.md         # This file
```

---

## 🔗 Integration with Spark

To consume this stream with Spark Streaming, see `streaming.ipynb`.

---

## 🐛 Troubleshooting

**Server won't start:**
- Check if port 8000 is already in use: `lsof -i :8000`
- Kill existing process: `kill -9 <PID>`

**No events received:**
- Check server logs for errors
- Verify client is connected: visit `http://localhost:8000/`
- Check `connected_clients` count

**Connection drops:**
- Normal for idle connections
- Client should implement reconnection logic

---

**Author:** epsilon403  
**Project:** Smart Logistics System  
**Last Updated:** November 19, 2025
