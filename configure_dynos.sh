#!/bin/bash

# Pastikan variabel lingkungan tersedia
if [[ -z "$HEROKU_API_TOKEN" || -z "$APP_NAME" ]]; then
  echo "HEROKU_API_TOKEN or APP_NAME is not set. Exiting."
  exit 1
fi

# Mengatur jumlah dynos menjadi 100
echo "Scaling dynos to 100 (standard-1x) for app: $APP_NAME"
curl -X PATCH "https://api.heroku.com/apps/$APP_NAME/formation" \
     -H "Content-Type: application/json" \
     -H "Accept: application/vnd.heroku+json; version=3" \
     -H "Authorization: Bearer $HEROKU_API_TOKEN" \
     -d '{
       "updates": [
         {
           "type": "web",
           "quantity": 100,
           "size": "standard-1x"
         }
       ]
     }'

echo "Dynos scaled successfully!"
