#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
source "$SCRIPT_DIR/config.sh"

echo "== PATH setup =="

if [ -d "$BOOTSTRAP_DIR" ]; then
  if ! grep -q "$BOOTSTRAP_DIR" "$HOME/.bashrc"; then
    echo "" >> "$HOME/.bashrc"
    echo "# Strix Halo bootstrap" >> "$HOME/.bashrc"
    echo "export PATH=\"\$PATH:$BOOTSTRAP_DIR\"" >> "$HOME/.bashrc"
  fi
fi
