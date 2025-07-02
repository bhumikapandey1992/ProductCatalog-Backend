#!/usr/bin/env bash
set -e

HOST="$1"
PORT="$2"
shift 2  

echo "⏳ Waiting for database at $HOST:$PORT..."
until nc -z "$HOST" "$PORT"; do
  sleep 1
done

echo "✅ Database is up!"

exec "$@"