#!/usr/bin/env bash
set -euo pipefail

echo "== Node.js / npm =="

if ! command -v node &>/dev/null || ! command -v npm &>/dev/null; then
  sudo dnf install -y nodejs npm
fi
