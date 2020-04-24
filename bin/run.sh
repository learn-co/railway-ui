#!/bin/sh

set -e
echo "Installing npm assets..."
npm install --prefix assets

until psql -h db -U "postgres" -c '\q' 2>/dev/null; do
  >&2 echo "Postgres is unavailable - sleeping 😴"
  sleep 1
done

echo "Starting phoenix server..."
iex -S mix phx.server
