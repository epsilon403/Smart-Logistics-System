
import asyncio
import json
import random
from datetime import datetime
from fastapi import FastAPI, WebSocket, WebSocketDisconnect
import uvicorn

app = FastAPI()
clients = set()


def generate_event():

    return {
        "order_id": random.randint(100000, 999999),
        "Customer City": random.choice(["Agadir", "Safi", "Casablanca"]),
        "Order Country": random.choice(["MA", "FR", "ES"]),
        "Days for shipment (scheduled)": random.randint(1, 15),
        "Benefit per order": round(random.uniform(5.0, 200.0), 2),
        "Sales per customer": round(random.uniform(10.0, 1000.0), 2),

        "event_time": datetime.utcnow().isoformat() + "Z"
    }

@app.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    await websocket.accept()
    clients.add(websocket)
    try:
        while True:

            await asyncio.sleep(0.1)
    except WebSocketDisconnect:
        clients.remove(websocket)


@app.post("/start_stream")
async def start_stream(rate_per_sec: float = 5.0):
    async def broadcaster():
        try:
            while True:
                event = generate_event()
                msg = json.dumps(event)
                to_remove = []
                for ws in list(clients):
                    try:
                        await ws.send_text(msg)
                    except Exception:
                        to_remove.append(ws)
                for ws in to_remove:
                    clients.discard(ws)
                await asyncio.sleep(1.0 / rate_per_sec)
        except asyncio.CancelledError:
            pass

    asyncio.create_task(broadcaster())
    return {"status": "started", "rate_per_sec": rate_per_sec}

if __name__ == "__main__":

    uvicorn.run("fastapi_generator:app", host="0.0.0.0", port=8000, log_level="info")
