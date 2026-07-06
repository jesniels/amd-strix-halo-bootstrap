#!/usr/bin/env bash
set -euo pipefail

MOUNT_POINT="/mnt/nas_models"
LOCAL_MODELS="$HOME/models"

if [ $# -eq 0 ]; then
    read -p "Check and sync all models to NAS? (yes/no): " ANSWER
    if [ "$ANSWER" != "yes" ]; then
        echo "Aborted."
        exit 0
    fi

    if ! mountpoint -q "$MOUNT_POINT" 2>/dev/null; then
        echo "ERROR: NAS is not mounted at $MOUNT_POINT"
        exit 1
    fi

    shopt -s nullglob
    model_dirs=("$LOCAL_MODELS"/*/)
    shopt -u nullglob

    if [ ${#model_dirs[@]} -eq 0 ]; then
        echo "No local models found in $LOCAL_MODELS"
        exit 0
    fi

    synced=0
    up_to_date=0
    failed=0

    for model_dir in "${model_dirs[@]}"; do
        model=$(basename "$model_dir")
        src="$LOCAL_MODELS/$model/"
        dst="$MOUNT_POINT/$model/"

        echo ""
        echo "Checking $model..."

        # Dry-run: collect files that would be transferred.
        # mapfile + || true keeps set -euo pipefail happy if rsync exits non-zero.
        mapfile -t pending_files < <(rsync -rn --out-format="%n" "$src" "$dst" 2>/dev/null || true)
        pending=${#pending_files[@]}

        if [ "$pending" -eq 0 ]; then
            echo "  ✔ Already in sync"
            up_to_date=$((up_to_date + 1))
        else
            echo "  $pending file(s) out of sync → syncing..."
            if rsync -avh --progress "$src" "$dst/"; then
                echo "  ✔ Synced"
                synced=$((synced + 1))
            else
                echo "  ❌ Failed"
                failed=$((failed + 1))
            fi
        fi
    done

    echo ""
    echo "== Summary =="
    echo "Synced:       $synced"
    echo "Up to date:   $up_to_date"
    echo "Failed:       $failed"
    exit 0
fi

MODEL_NAME="$1"

SRC="$LOCAL_MODELS/$MODEL_NAME"
DST="$MOUNT_POINT/$MODEL_NAME"

if [ ! -d "$SRC" ]; then
    echo "Model not found locally: $MODEL_NAME"
    exit 1
fi

echo "Uploading $MODEL_NAME to NAS..."

rsync -avh --progress "$SRC/" "$DST/"

echo "Done ✔"


