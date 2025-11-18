#!/bin/bash

# Simple startup script for the Smart Logistics Streaming System

echo "🚀 Starting Smart Logistics Streaming System"
echo "=============================================="
echo ""

# Activate virtual environment
if [ -d ".venv" ]; then
    source .venv/bin/activate
    echo "✅ Virtual environment activated"
else
    echo "❌ .venv not found"
    exit 1
fi
echo ""

# Check if running from correct directory
if [ ! -f "backend/websocket.py" ]; then
    echo "❌ Error: Run this script from the project root directory"
    exit 1
fi

echo "📋 Starting components in order:"
echo ""

# 1. Start WebSocket Server
echo "1️⃣  Starting WebSocket Server (port 8000)..."
python backend/websocket.py &
WS_PID=$!
sleep 3

# 2. Start TCP Bridge
echo "2️⃣  Starting TCP Bridge (port 9999)..."
python bridge/tcp_connect.py &
BRIDGE_PID=$!
sleep 2

# 3. Start Spark Streaming
echo "3️⃣  Starting Spark Streaming Predictions..."
echo ""
python streaming/streaming.py

# Cleanup on exit
echo ""
echo "🛑 Shutting down..."
kill $WS_PID $BRIDGE_PID 2>/dev/null
echo "✅ All components stopped"
