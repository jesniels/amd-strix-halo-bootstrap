#!/usr/bin/env bash
set -euo pipefail

echo "== Strix Halo bootstrap installer =="

SCRIPT_DIR="$(dirname "$(realpath "$0")")"

########################################
# Steps — add or reorder here to change
# what install.sh runs and in what order.
########################################
steps=(
  "python.sh"
  "base-dependencies.sh"
  "huggingface.sh"
  "toolbox-repo.sh"
  "kernel-parameters.sh"
  "models-directory.sh"
  "path-setup.sh"
  "nas-setup.sh"
)

total=${#steps[@]}

for i in "${!steps[@]}"; do
  step_num=$((i + 1))
  script="$SCRIPT_DIR/scripts/${steps[$i]}"
  name=$(basename "$script" .sh | tr '-' ' ')
  echo ""
  echo "[$step_num/$total] $name"
  if [[ "${steps[$i]}" == "path-setup.sh" ]]; then
    # Source instead of bash so PATH exports affect the current shell
    # shellcheck source=scripts/path-setup.sh
    . "$script"
  else
    bash "$script"
  fi
done

echo ""
echo "== DONE =="
echo "Ready ✔"
