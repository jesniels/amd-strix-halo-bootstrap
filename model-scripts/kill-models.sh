#!/usr/bin/env bash
set -euo pipefail

echo "== Kill existing models"

########################################
# 1. Kill llama-server processes
########################################

pids=$(ps -eo pid,args | grep -v grep | grep "llama-server" | awk '{print $1}' 2>/dev/null || true)
for pid in $pids; do
  if kill -0 "$pid" 2>/dev/null; then
    kill "$pid" 2>/dev/null || true
    echo "  Killed llama-server (PID $pid)"
  fi
done

########################################
# 2. Stop toolbox containers
########################################

echo "== Kill existing toolboxes =="


if command -v podman &>/dev/null; then
  for container in $(podman ps --filter "name=llama" --filter "name=ds4" --format '{{.Names}}' 2>/dev/null || true); do
    podman stop "$container" >/dev/null 2>&1 && echo "  Stopped toolbox container: $container"
  done
fi

echo "  Done ✔"
