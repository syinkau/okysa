#!/bin/bash

# Pastikan variabel lingkungan tersedia
if [[ -z "$HEROKU_API_TOKEN" || -z "$APP_NAME" ]]; then
  echo "HEROKU_API_TOKEN or APP_NAME is not set. Exiting."
  exit 1
fi

# Restart 100 dynos menggunakan API Heroku
echo "Restarting 100 Heroku dynos for app: $APP_NAME"

for i in {1..100}; do
  echo "Restarting dyno web.$i..."
  curl -X DELETE "https://api.heroku.com/apps/$APP_NAME/dynos/web.$i" \
       -H "Content-Type: application/json" \
       -H "Accept: application/vnd.heroku+json; version=3" \
       -H "Authorization: Bearer $HEROKU_API_TOKEN" &
done

# Tunggu hingga semua proses selesai
wait

echo "Successfully restarted 100 dynos for app: $APP_NAME"
