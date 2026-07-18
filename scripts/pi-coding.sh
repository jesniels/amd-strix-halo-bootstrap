#!/usr/bin/env bash
set -euo pipefail

echo "== Pi Coding CLI =="

if ! command -v pi &>/dev/null; then
  npm install -g --ignore-scripts @earendil-works/pi-coding-agent
fi
