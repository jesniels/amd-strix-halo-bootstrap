#!/usr/bin/env bash
set -euo pipefail

echo "== Base dependencies =="

sudo dnf install -y \
  git cmake gcc gcc-c++ \
  kernel-devel \
  mesa-dri-drivers mesa-vulkan-drivers \
  clinfo rocminfo \
  samba-client cifs-utils \
  systemd util-linux rsync
