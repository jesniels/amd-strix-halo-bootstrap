#!/usr/bin/env bash
set -euo pipefail

echo "== Strix Halo bootstrap installer =="

########################################
# CONFIG
########################################
MOUNT_POINT="/mnt/nas_models"
NAS_SHARE="//nas10.afdata/Models"
NAS_USER="jesniels"

LOCAL_MODELS="$HOME/models"
REPO_DIR="$HOME/amd-strix-halo-toolboxes"
BOOTSTRAP_DIR="$HOME/amd-strix-halo-bootstrap"

########################################
# 1. Python 3.12
########################################
echo "[1/8] Python 3.12"

if ! command -v python3.12 &>/dev/null; then
  sudo dnf install -y python3.12

  python3.12 -m ensurepip --upgrade || true
  python3.12 -m pip install --upgrade pip || true
fi

########################################
# 2. Base dependencies
########################################
echo "[2/8] Base dependencies"

sudo dnf install -y \
  git cmake gcc gcc-c++ \
  kernel-devel \
  mesa-dri-drivers mesa-vulkan-drivers \
  clinfo rocminfo \
  samba-client cifs-utils \
  systemd util-linux rsync

########################################
# 3. HuggingFace
########################################
echo "[3/8] HuggingFace tooling"

python3.12 -m pip install --user -U huggingface-hub || true

########################################
# 4. Toolbox repo
########################################
echo "[4/8] Cloning toolbox"

if [ ! -d "$REPO_DIR" ]; then
  git clone https://github.com/kyuz0/amd-strix-halo-toolboxes.git "$REPO_DIR"
fi

########################################
# 5. Kernel parameters
########################################
echo "[5/8] Kernel configuration"

bash ./update-kernel-parameters.sh

########################################
# 6. Models directory
########################################
echo "[6/8] Models directory"

mkdir -p "$LOCAL_MODELS"

########################################
# 7. PATH setup (no duplicates)
########################################
echo "[7/8] PATH setup"

if [ -d "$BOOTSTRAP_DIR" ]; then
  if ! grep -q "$BOOTSTRAP_DIR" "$HOME/.bashrc"; then
    echo "" >> "$HOME/.bashrc"
    echo "# Strix Halo bootstrap" >> "$HOME/.bashrc"
    echo "export PATH=\"\$PATH:$BOOTSTRAP_DIR\"" >> "$HOME/.bashrc"
  fi
fi

########################################
# 8. NAS setup (SMART + NO DUPLICATE PROMPT)
########################################

echo "[8/8] NAS setup"

sudo mkdir -p "$MOUNT_POINT"
sudo mkdir -p /run/secrets

test_nas() {
  sudo mount -t cifs "$NAS_SHARE" "$MOUNT_POINT" \
    -o vers=3.0,iocharset=utf8,uid=1000,gid=1000,credentials=/run/secrets/nas-cred \
    >/dev/null 2>&1
}

validate_existing() {
  [ -f /run/secrets/nas-cred ] && test_nas
}

echo "Checking existing NAS credentials..."

if validate_existing; then
  echo "NAS credentials valid ✔ (no prompt needed)"
  sudo umount "$MOUNT_POINT" || true

else
  echo "NAS credentials missing/invalid → prompting"

  while true; do

    read -s -p "NAS password for $NAS_USER: " NAS_PASS
    echo ""

    echo "username=$NAS_USER
password=$NAS_PASS" | sudo tee /run/secrets/nas-cred > /dev/null

    sudo chmod 600 /run/secrets/nas-cred

    echo "Testing NAS..."

    if test_nas; then
      echo "NAS authentication SUCCESS ✔"
      sudo umount "$MOUNT_POINT" || true
      break
    else
      echo "NAS authentication FAILED ❌"
      sudo umount "$MOUNT_POINT" || true
    fi

  done
fi

########################################
# systemd persistent mount
########################################

SERVICE_FILE="/etc/systemd/system/mnt-nas_models.mount"
AUTOMOUNT_FILE="/etc/systemd/system/mnt-nas_models.automount"

cat <<EOF | sudo tee "$SERVICE_FILE" > /dev/null
[Unit]
Description=NAS Models Share

[Mount]
What=$NAS_SHARE
Where=$MOUNT_POINT
Type=cifs
Options=vers=3.0,iocharset=utf8,uid=1000,gid=1000,credentials=/run/secrets/nas-cred

[Install]
WantedBy=multi-user.target
EOF

cat <<EOF | sudo tee "$AUTOMOUNT_FILE" > /dev/null
[Unit]
Description=Automount NAS Models Share

[Automount]
Where=$MOUNT_POINT

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable mnt-nas_models.automount

echo ""
echo "== DONE =="
echo "Models: $LOCAL_MODELS"
echo "NAS: $MOUNT_POINT"
echo "Ready ✔"
