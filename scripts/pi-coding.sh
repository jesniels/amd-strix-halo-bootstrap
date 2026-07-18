#!/usr/bin/env bash
set -euo pipefail

echo "== Pi Coding CLI =="

if ! command -v pi &>/dev/null; then
  npm install -g --ignore-scripts @earendil-works/pi-coding-agent
fi

echo "== Pi modules =="

for mod in "npm:pi-web-access" "npm:@tintinweb/pi-subagents" "npm:pi-mcp-adapter" "npm:@diegopetrucci/pi-quiet-tools"; do
  if ! pi list 2>/dev/null | grep -q "$mod"; then
    pi install "$mod" >/dev/null 2>&1 || true
    echo "  Installed $mod"
  else
    echo "  $mod already installed"
  fi
done
