#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
source "$SCRIPT_DIR/config.sh"

echo "== Cloning toolbox =="

for repo_info in "$AMD_REPO_DIR|https://github.com/kyuz0/amd-strix-halo-toolboxes.git" \
                  "$DS4_REPO_DIR|https://github.com/kyuz0/strix-halo-ds4-toolbox.git"; do
  IFS='|' read -r repo_dir repo_url <<< "$repo_info"

  if [ -d "$repo_dir/.git" ]; then
    echo "Updating $repo_dir ..."
    (cd "$repo_dir" && git pull --ff-only 2>/dev/null) || true
  else
    echo "Cloning $repo_url ..."
    git clone "$repo_url" "$repo_dir"
  fi
done
