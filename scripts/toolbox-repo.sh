#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
source "$SCRIPT_DIR/config.sh"

echo "== Cloning toolbox =="

if [ ! -d "$REPO_DIR" ]; then
  git clone https://github.com/kyuz0/amd-strix-halo-toolboxes.git "$REPO_DIR"
fi
