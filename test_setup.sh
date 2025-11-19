#!/bin/bash

echo "🧪 Testing Smart Logistics System Components"
echo "=============================================="
echo ""

# Activate virtual environment
if [ -d ".venv" ]; then
    source .venv/bin/activate
    echo "✅ Virtual environment activated"
else
    echo "❌ .venv not found. Create it first."
    exit 1
fi
echo ""

# Test 1: Check if Python dependencies are installed
echo "1️⃣  Checking dependencies..."
python -c "import fastapi, uvicorn, websockets, pyspark" 2>/dev/null
if [ $? -eq 0 ]; then
    echo "   ✅ All dependencies installed"
else
    echo "   ❌ Missing dependencies. Install with:"
    echo "      pip install fastapi uvicorn websockets pyspark"
    exit 1
fi

# Test 2: Check if models exist
echo ""
echo "2️⃣  Checking ML models..."
if [ -d "data/preprocessing_model_spark" ] && [ -d "data/gbt_model_spark" ]; then
    echo "   ✅ Models found"
else
    echo "   ❌ Models not found in data/ directory"
    exit 1
fi

# Test 3: Check ports are available
echo ""
echo "3️⃣  Checking ports..."
lsof -i :8000 > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "   ⚠️  Port 8000 is in use (WebSocket)"
else
    echo "   ✅ Port 8000 available"
fi

lsof -i :9999 > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "   ⚠️  Port 9999 is in use (TCP Bridge)"
else
    echo "   ✅ Port 9999 available"
fi

echo ""
echo "=============================================="
echo "✅ System is ready!"
echo ""
echo "Run: ./start.sh"
echo "Or manually start each component in order:"
echo "  1. python backend/websocket.py"
echo "  2. python bridge/tcp_connect.py"
echo "  3. python streaming/streaming.py"
