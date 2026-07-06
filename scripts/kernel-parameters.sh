#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname "$(realpath "$0")")"

echo "== Kernel configuration =="

bash "$SCRIPT_DIR/update-kernel-parameters.sh"
