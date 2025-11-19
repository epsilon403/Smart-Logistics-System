"""
Simple TCP Server Bridge
Listens for Spark connections and forwards WebSocket events
"""
import asyncio
import websockets
import socket
import threading
import json

WS_URL = "ws://localhost:8000/ws"
TCP_PORT = 9999

spark_client = None

def tcp_server():
    """TCP server that waits for Spark to connect"""
    global spark_client
    
    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    server.bind(("localhost", TCP_PORT))
    server.listen(1)
    
    print(f"🟢 TCP server listening on localhost:{TCP_PORT}")
    print("⏳ Waiting for Spark to connect...")
    
    spark_client, addr = server.accept()
    print(f"✅ Spark connected from {addr}")

async def forward_websocket_to_tcp():
    """Read from WebSocket and send to Spark via TCP"""
    global spark_client

    while spark_client is None:
        await asyncio.sleep(0.5)
    
    print("🔗 Connecting to WebSocket...")
    async with websockets.connect(WS_URL) as websocket:
        print("✅ Connected to WebSocket")
        print("🔄 Forwarding events to Spark...\n")
        
        count = 0
        try:
            async for message in websocket:

                spark_client.send((message + "\n").encode("utf-8"))
                
                count += 1
                if count % 5 == 0:

                    event = json.loads(message)
                    print(f"📤 Sent {count} events | Last: {event['Customer City']} -> Risk={event['Late_delivery_risk']}")
                    
        except Exception as e:
            print(f"❌ Error: {e}")
        finally:
            if spark_client:
                spark_client.close()

if __name__ == "__main__":
    print("=" * 60)
    print("🌉 WebSocket-to-TCP Bridge")
    print("=" * 60)
    

    threading.Thread(target=tcp_server, daemon=True).start()
    

    try:
        asyncio.run(forward_websocket_to_tcp())
    except KeyboardInterrupt:
        print("\n🛑 Bridge stopped")
    finally:
        if spark_client:
            spark_client.close()