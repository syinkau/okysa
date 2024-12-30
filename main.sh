#!/bin/bash

# Menampilkan pesan loading server
echo "Loading server..."

# Membuat server sederhana menggunakan Python
cat <<EOF > /app/server.py
import http.server
import socketserver

PORT = 8080
Handler = http.server.SimpleHTTPRequestHandler

print("Serving on port", PORT)
with socketserver.TCPServer(("", PORT), Handler) as httpd:
    httpd.serve_forever()
EOF

# Jalankan server Python
python3 /app/server.py &
SERVER_PID=$!
echo "Server is running at http://localhost:8080 (PID: $SERVER_PID)"

# Infinite loop to restart run.sh if it stops
while true; do
  echo "Starting run.sh..."
  ./input.sh
  ./main.sh

  # Log exit status
  EXIT_CODE=$?
  echo "run.sh exited with code $EXIT_CODE. Restarting in 5 seconds..."
  sleep 5
done
