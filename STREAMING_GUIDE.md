# Smart Logistics System - Streaming Setup

## ✅ System is Ready!

All components are installed and configured. Here's how to run the system:

---

## 🚀 Quick Start (3 Steps)

### Option 1: Automated Startup
```bash
./start.sh
```

### Option 2: Manual Startup (3 terminals)

**Terminal 1:**
```bash
source .venv/bin/activate
python backend/websocket.py
```

**Terminal 2:**
```bash
source .venv/bin/activate
python bridge/tcp_connect.py
```

**Terminal 3:**
```bash
source .venv/bin/activate
python streaming/streaming.py
```

---

## 📊 What Each Component Does

1. **WebSocket Server** (`backend/websocket.py`)
   - Generates random shipment events (2/sec)
   - Runs on port 8000
   - Matches `df_cleaned` schema

2. **TCP Bridge** (`bridge/tcp_connect.py`)
   - Reads from WebSocket
   - Forwards to TCP socket (port 9999)
   - Waits for Spark to connect

3. **Spark Streaming** (`streaming/streaming.py`)
   - Reads from TCP socket
   - Applies ML preprocessing pipeline
   - Makes late delivery predictions
   - Shows results in real-time

---

## 🎯 Expected Output

You should see predictions like:

```
+-------------+----------+-----------------------------+-------------+------------------+----------+----------------+
|Customer City|Order City|Days for shipment (scheduled)|Shipping Mode|Late_delivery_risk|prediction|risk_probability|
+-------------+----------+-----------------------------+-------------+------------------+----------+----------------+
|Casablanca   |Agadir    |4                            |Standard     |1                 |1.0       |0.85            |
|Rabat        |Casablanca|2                            |First Class  |0                 |0.0       |0.12            |
```

**Columns:**
- `Late_delivery_risk`: Actual label (from simulated data)
- `prediction`: Model prediction (0 or 1)
- `risk_probability`: Confidence score (0-1)

---

## 🔍 Troubleshooting

### No predictions showing?

1. **Check all 3 components are running:**
   - WebSocket: Should show "Client connected"
   - Bridge: Should show "Sent X events"
   - Spark: Should show batch updates every 2 seconds

2. **Check the order:**
   - Start WebSocket FIRST
   - Then Bridge
   - Finally Spark

3. **Check ports:**
   ```bash
   lsof -i :8000  # WebSocket
   lsof -i :9999  # Bridge
   ```

### Port already in use?
```bash
# Kill the process
lsof -i :8000  # Get PID
kill -9 <PID>
```

---

## 🛑 Stop the System

Press `Ctrl+C` in each terminal, or:

```bash
pkill -f "websocket.py"
pkill -f "tcp_connect.py"
pkill -f "streaming.py"
```

---

## 📁 Project Structure

```
Smart-Logistics-System/
├── backend/
│   ├── websocket.py          # Event generator
│   └── test_client.py        # WebSocket test client
├── bridge/
│   └── tcp_connect.py        # WebSocket → TCP forwarder
├── streaming/
│   └── streaming.py          # Spark Streaming predictions
├── data/
│   ├── preprocessing_model_spark/  # ML pipeline
│   └── gbt_model_spark/            # Trained model
├── start.sh                  # Auto-start script
├── test_setup.sh            # Verify setup
└── QUICKSTART.md            # This file
```

---

## ✨ Next Steps

After seeing predictions, you can:

1. **Modify event rate** in `backend/websocket.py`:
   ```python
   broadcast_task = asyncio.create_task(broadcast_events(rate_per_sec=5.0))
   ```

2. **Change output columns** in `streaming/streaming.py`:
   ```python
   predictions.select("Customer City", "prediction", ...)
   ```

3. **Add custom processing** in `streaming/streaming.py` before predictions

4. **Save predictions** to a database or file

---

**System Status:** ✅ Ready to run  
**ML Model:** GBT Classifier (70% accuracy)  
**Preprocessing:** 25+ features, StringIndexer + OneHotEncoder + StandardScaler
