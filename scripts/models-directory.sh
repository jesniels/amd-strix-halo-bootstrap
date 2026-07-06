#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
source "$SCRIPT_DIR/config.sh"

echo "== Models directory =="

mkdir -p "$LOCAL_MODELS"
