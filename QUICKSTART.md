# 🚀 Quick Start Guide

## Simple 3-Step Startup

### Option 1: Automated (Recommended)

```bash
./start.sh
```

This will start all components automatically in the correct order.

---

### Option 2: Manual (for debugging)

Open **3 separate terminals**:

**Terminal 1 - WebSocket Server:**
```bash
python backend/websocket.py
```

**Terminal 2 - TCP Bridge:**
```bash
python bridge/tcp_connect.py
```

**Terminal 3 - Spark Streaming:**
```bash
python streaming/streaming.py
```

---

## 📊 What You'll See

### Terminal 1 (WebSocket):
```
🌐 Starting WebSocket Server...
📡 WebSocket URL: ws://localhost:8000/ws
✅ Client connected. Total clients: 1
```

### Terminal 2 (Bridge):
```
🟢 TCP server listening on localhost:9999
✅ Spark connected from ('127.0.0.1', 54321)
🔗 Connecting to WebSocket...
✅ Connected to WebSocket
📤 Sent 5 events | Last: Casablanca -> Risk=1
```

### Terminal 3 (Spark Predictions):
```
📦 Loading models...
✅ Models loaded successfully!
🚀 STREAMING PREDICTIONS ACTIVE

+-------------+----------+-----------------------------+-------------+------------------+----------+----------------+
|Customer City|Order City|Days for shipment (scheduled)|Shipping Mode|Late_delivery_risk|prediction|risk_probability|
+-------------+----------+-----------------------------+-------------+------------------+----------+----------------+
|Casablanca   |Agadir    |4                            |Standard Class|1                |1.0       |0.85            |
|Rabat        |Casablanca|2                            |First Class  |0                |0.0       |0.12            |
```

---

## ❓ Troubleshooting

### No predictions showing?

**Check if data is flowing:**

1. WebSocket should show: `✅ Client connected`
2. Bridge should show: `📤 Sent X events`
3. Spark should show batches every 2 seconds

**Common issues:**

- **Port already in use:** Kill existing processes
  ```bash
  lsof -i :8000  # WebSocket
  lsof -i :9999  # TCP Bridge
  kill -9 <PID>
  ```

- **Models not found:** Check paths in `streaming/streaming.py`

- **Wrong order:** Start in order: WebSocket → Bridge → Spark

---

## 🛑 Stop All Services

Press `Ctrl+C` in each terminal, or:

```bash
pkill -f websocket.py
pkill -f tcp_connect.py
pkill -f streaming.py
```

---

## 📁 Architecture

```
WebSocket Server (8000)     →  TCP Bridge (9999)  →  Spark Streaming
  Generates Events              Forwards Events       Makes Predictions
```

1. **WebSocket** generates 2 random shipment events/sec
2. **Bridge** forwards JSON events to TCP socket
3. **Spark** reads from socket, applies ML model, shows predictions

---

## 🧪 Test Individual Components

**Test WebSocket:**
```bash
python backend/test_client.py
```

**Test Bridge:**
```bash
# Start bridge first, then:
nc localhost 9999  # Should see JSON events
```

**Test Spark:**
```bash
# Make sure bridge is running, then:
python streaming/streaming.py
```

---

**Need help?** Check the logs for error messages in each terminal.
