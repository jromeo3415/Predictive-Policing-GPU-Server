#!/bin/bash
set -e

TS_SOCKET="/var/run/tailscale/tailscaled.sock"
TS_STATE="/var/lib/tailscale/tailscaled.state"

echo "Starting tailscaled..."
tailscaled --state=$TS_STATE --socket=$TS_SOCKET &

sleep 2

echo "Checking Tailscale status..."
if tailscale --socket=$TS_SOCKET status >/dev/null 2>&1; then
    echo "Tailscale already authenticated ✅"
else
    echo "Authenticating with Tailscale..."
    tailscale --socket=$TS_SOCKET up \
        --authkey=$TAIL_SCALE_AUTH_KEY \
        --accept-routes \
        --hostname=gpu-container
fi

echo "Starting FastAPI app..."
exec uvicorn app.main:app --host 0.0.0.0 --port 5000
