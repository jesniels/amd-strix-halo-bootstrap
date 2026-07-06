#!/usr/bin/env bash
set -euo pipefail

echo "== Python 3.12 =="

if ! command -v python3.12 &>/dev/null; then
  sudo dnf install -y python3.12

  python3.12 -m ensurepip --upgrade || true
  python3.12 -m pip install --upgrade pip || true
fi
