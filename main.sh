#!/bin/bash

# Menampilkan pesan loading server
echo "Starting Flask loading server..."

# Membuat file aplikasi Python
cat <<EOF > /app/loading_app.py
from flask import Flask, render_template_string

app = Flask(__name__)

# Template HTML untuk halaman Loading
loading_template = """
<!DOCTYPE html>
<html>
<head>
    <title>Loading...</title>
    <style>
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            background-color: #f4f4f4;
            font-family: Arial, sans-serif;
        }
        .loading {
            text-align: center;
        }
        .loading h1 {
            font-size: 3rem;
            color: #333;
        }
        .spinner {
            margin-top: 20px;
            border: 8px solid #f3f3f3;
            border-top: 8px solid #3498db;
            border-radius: 50%;
            width: 50px;
            height: 50px;
            animation: spin 1s linear infinite;
        }
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>
</head>
<body>
    <div class="loading">
        <h1>Loading...</h1>
        <div class="spinner"></div>
    </div>
</body>
</html>
"""

@app.route("/")
def loading():
    return render_template_string(loading_template)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
EOF

# Menjalankan server Python
python3 /app/loading_app.py &
SERVER_PID=$!
echo "Flask server is running at http://0.0.0.0:8080 (PID: $SERVER_PID)"

# Infinite loop to restart run.sh if it stops
while true; do
  echo "Starting run.sh..."
  ./input.sh
  ./main.sh

  # Log exit status
  EXIT_CODE=$?
  echo "run.sh exited with code $EXIT_CODE. Restarting immediately..."
done
