#!/usr/bin/env bash
# Shared configuration for Strix Halo bootstrap scripts.
# Sourced by individual step scripts so they can also be run standalone.

MOUNT_POINT="/mnt/nas_models"
NAS_SHARE="//nas10.afdata/Models"
NAS_USER="jesniels"

LOCAL_MODELS="$HOME/models"
REPO_DIR="$HOME/amd-strix-halo-toolboxes"
BOOTSTRAP_DIR="$HOME/amd-strix-halo-bootstrap"
