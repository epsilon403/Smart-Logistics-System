import socket

HOST = "localhost"
PORT = 9999

server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server_socket.bind((HOST, PORT))
server_socket.listen(1)
print(f"🟢 TCP server listening on {HOST}:{PORT}")

conn, addr = server_socket.accept()
print(f"🔗 Connection from {addr}")

while True:
    data = conn.recv(1024)
    if not data:
        break
    print("📨 Received:", data.decode("utf-8"))
