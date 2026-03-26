#!/bin/bash
set -e

TS_SOCKET="/var/run/tailscale/tailscaled.sock"
TS_STATE="/var/lib/tailscale/tailscaled.state"

echo "Tailscale key: $TAIL_SCALE_AUTH_KEY"

echo "Starting tailscaled..."
tailscaled --state="$TS_STATE" --socket="$TS_SOCKET" &

# Wait a moment for tailscaled to start
sleep 3

echo "Bringing up Tailscale..."
tailscale --socket="$TS_SOCKET" up \
    --authkey="$TAIL_SCALE_AUTH_KEY" \
    --accept-routes \
    --hostname=gpu-container

echo "Starting app..."
exec python server.py
