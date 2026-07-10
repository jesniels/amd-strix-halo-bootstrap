#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
source "$SCRIPT_DIR/config.sh"

echo "== PATH setup =="

if [ -d "$BOOTSTRAP_DIR" ]; then
  if grep -q "$BOOTSTRAP_DIR" "$HOME/.bashrc" && ! grep -q "model-scripts" "$HOME/.bashrc"; then
    # Upgrade existing entry to include model-scripts
    sed -i "s|export PATH=.*$BOOTSTRAP_DIR.*|export PATH=\"\$PATH:$BOOTSTRAP_DIR:$BOOTSTRAP_DIR/model-scripts\"|" "$HOME/.bashrc"
  elif ! grep -q "$BOOTSTRAP_DIR" "$HOME/.bashrc"; then
    echo "" >> "$HOME/.bashrc"
    echo "# Strix Halo bootstrap" >> "$HOME/.bashrc"
    echo "export PATH=\"\$PATH:$BOOTSTRAP_DIR:$BOOTSTRAP_DIR/model-scripts\"" >> "$HOME/.bashrc"
  fi
fi

# Also apply to the current shell session (works when this script is sourced)
case ":$PATH:" in
  *":$BOOTSTRAP_DIR/model-scripts:"*) ;;
  *) export PATH="$PATH:$BOOTSTRAP_DIR:$BOOTSTRAP_DIR/model-scripts" ;;
esac
