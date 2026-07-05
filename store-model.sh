#!/usr/bin/env bash
set -euo pipefail

MOUNT_POINT="/mnt/nas_models"
LOCAL_MODELS="$HOME/models"

if [ $# -eq 0 ]; then
    echo "Available local models:"
    ls "$LOCAL_MODELS"
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


