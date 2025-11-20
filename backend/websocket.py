
"""
Simple WebSocket Server for Logistics Data Streaming
Generates random shipment events matching the df_cleaned schema
"""
import asyncio
import json
import random
from contextlib import asynccontextmanager
from datetime import datetime, timedelta
from fastapi import FastAPI, WebSocket, WebSocketDisconnect
import uvicorn

connected_clients = set()
broadcast_task = None


async def broadcast_events(rate_per_sec: float = 2.0):
    
    
    
    while True:
        if connected_clients:
            event = generate_shipment_event()
            message = json.dumps(event)
            
            disconnected = []
            for client in connected_clients:
                try:
                    await client.send_text(message)
                except Exception as e:
                    print(f"⚠️  Error sending to client: {e}")
                    disconnected.append(client)

            for client in disconnected:
                connected_clients.discard(client)
        
        await asyncio.sleep(1.0 / rate_per_sec)


@asynccontextmanager
async def lifespan(app: FastAPI):
    """Lifespan event handler - starts/stops background tasks"""
    global broadcast_task
    
    print("🚀 Starting background event broadcaster...")
    broadcast_task = asyncio.create_task(broadcast_events(rate_per_sec=2.0))
    
    yield
    

    print("🛑 Stopping background event broadcaster...")
    if broadcast_task:
        broadcast_task.cancel()
        try:
            await broadcast_task
        except asyncio.CancelledError:
            pass



    

app = FastAPI(title="Logistics Event Stream", lifespan=lifespan)


def generate_shipment_event():
    """Generate a random shipment event with columns from df_cleaned"""
    return {

        "Type": random.choice(["DEBIT", "PAYMENT", "TRANSFER"]),
        "Days for shipment (scheduled)": random.randint(2, 7),
        "Benefit per order": round(random.uniform(5.0, 200.0), 2),
        "Sales per customer": round(random.uniform(50.0, 1000.0), 2),
        "Late_delivery_risk": random.choice([0, 1]),

        "Customer City": random.choice(["Agadir", "Casablanca", "Rabat", "Marrakech", "Fes"]),
        "Customer Country": "Morocco",
        "Latitude": round(random.uniform(30.0, 35.0), 6),
        "Longitude": round(random.uniform(-8.0, -4.0), 6),
        "Market": random.choice(["Africa", "Europe", "LATAM"]),
        "Order City": random.choice(["Agadir", "Casablanca", "Rabat"]),
        "Order Country": "Morocco",
        "Order Region": random.choice(["North", "South", "Central"]),
        "Order State": random.choice(["Active", "Processing", "Delivered"]),

        "Department Id": random.randint(1, 10),  # ✅ ADDED: Required by VectorAssembler
        "Product Category Id": random.randint(1, 20),
        "Product Price": round(random.uniform(10.0, 500.0), 2),
        "Product Status": random.choice([0, 1]),
        
        "Shipping Mode": random.choice(["Standard Class", "First Class", "Second Class", "Same Day"]),
        "shipping date (DateOrders)": (datetime.now() + timedelta(days=random.randint(1, 7))).strftime("%m/%d/%Y %H:%M"),

        "Order Item Quantity": random.randint(1, 10),
        "Order Item Discount Rate": round(random.uniform(0.0, 0.3), 2),  # ✅ ADDED: Required by VectorAssembler
        "Sales": round(random.uniform(100.0, 2000.0), 2),
        "Order Status": random.choice(["COMPLETE", "PENDING", "PROCESSING"]),
        
        "event_time": datetime.utcnow().isoformat() + "Z"
    }


@app.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    await websocket.accept()
    connected_clients.add(websocket)
    print(f"✅ Client connected. Total clients: {len(connected_clients)}")
    
    try:

        while True:
            await asyncio.sleep(1)
    except WebSocketDisconnect:
        connected_clients.remove(websocket)
        print(f"❌ Client disconnected. Total clients: {len(connected_clients)}")


@app.get("/")
async def root():
    """Health check endpoint"""
    return {
        "status": "running",
        "connected_clients": len(connected_clients),
        "websocket_url": "ws://localhost:8000/ws"
    }


if __name__ == "__main__":
    print("🌐 Starting WebSocket Server...")
    print("📡 WebSocket URL: ws://localhost:8000/ws")
    print("🔗 API Docs: http://localhost:8000/docs")
    uvicorn.run(app, host="0.0.0.0", port=8000, log_level="info")
