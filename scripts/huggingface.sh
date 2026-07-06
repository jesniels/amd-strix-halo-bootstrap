#!/usr/bin/env bash
set -euo pipefail

echo "== HuggingFace tooling =="

python3.12 -m pip install --user -U huggingface-hub || true
