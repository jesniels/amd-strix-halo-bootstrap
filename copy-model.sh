#!/usr/bin/env bash
set -euo pipefail

MOUNT_POINT="/mnt/nas_models"
LOCAL_MODELS="$HOME/models"

if [ $# -eq 0 ]; then
    echo "Available models on NAS:"
    ls "$MOUNT_POINT"
    exit 0
fi

MODEL_NAME="$1"

SRC="$MOUNT_POINT/$MODEL_NAME"
DST="$LOCAL_MODELS/$MODEL_NAME"

if [ ! -d "$SRC" ]; then
    echo "Model not found on NAS: $MODEL_NAME"
    exit 1
fi

echo "Copying $MODEL_NAME to local storage..."

rsync -avh --progress "$SRC/" "$DST/"

echo "Done ✔"

