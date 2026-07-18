#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
source "$SCRIPT_DIR/../scripts/config.sh"

echo "== Kill existing models & toolboxes =="

########################################
# 1. Kill llama-server and inference processes
########################################

for pattern in llama-server \
               "python.*-m.*server" \
               ollama \
               vllm \
               text-generation-server; do
  pids=$(ps -eo pid,args | grep -v grep | grep "$pattern" | awk '{print $1}' 2>/dev/null || true)
  for pid in $pids; do
    if kill -0 "$pid" 2>/dev/null; then
      kill "$pid" 2>/dev/null || true
      echo "  Killed $pattern (PID $pid)"
    fi
  done
done

# Also kill anything listening on the default model port
for port in 8080; do
  fuser "$port/tcp" 2>/dev/null | awk '{print $1}' | while read -r pid; do
    if [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null; then
      kill "$pid" 2>/dev/null || true
      echo "  Killed process on port $port (PID $pid)"
    fi
  done
done

########################################
# 2. Stop toolbox containers
########################################

if command -v toolbox &>/dev/null; then
  for container in $(toolbox list 2>/dev/null | grep -E 'llama|ds4' | awk '{print $2}' 2>/dev/null || true); do
    if toolbox stop "$container" 2>/dev/null; then
      echo "  Stopped toolbox container: $container"
    fi
  done
fi

########################################
# 3. Kill any remaining python model servers
########################################

pids=$(ps -eo pid,args | grep -v grep | grep -E "hf.*server|llama\.cpp|llama\.py|gradio.*model" | awk '{print $1}' 2>/dev/null || true)
for pid in $pids; do
  if kill -0 "$pid" 2>/dev/null; then
    kill "$pid" 2>/dev/null || true
    echo "  Killed leftover (PID $pid)"
  fi
done

echo "  Done ✔"
