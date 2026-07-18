#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
source "$SCRIPT_DIR/config.sh"

echo "== Models config =="

TARGET_DIR="$HOME/pi/agent"
TARGET_FILE="$TARGET_DIR/models.json"
TEMPLATE="$SCRIPT_DIR/../templates/models.json"

if [ -f "$TARGET_FILE" ]; then
  echo "Already present — skipping"
else
  mkdir -p "$TARGET_DIR"
  cp "$TEMPLATE" "$TARGET_FILE"
fi
