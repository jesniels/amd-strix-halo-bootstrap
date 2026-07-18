#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

echo "== Kernel configuration =="

bash "$SCRIPT_DIR/update-kernel-parameters.sh"
