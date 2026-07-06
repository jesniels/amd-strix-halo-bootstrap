#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
source "$SCRIPT_DIR/config.sh"

# Persistent credentials file — survives reboots (unlike /run which is tmpfs)
CRED_FILE="/etc/nas-credentials"

echo "== NAS setup =="

sudo mkdir -p "$MOUNT_POINT"

# Stop any running automount/mount units first — they hold the mount point
# via kernel autofs and will cause EBUSY on any manual mount attempt.
sudo systemctl stop mnt-nas_models.automount mnt-nas_models.mount 2>/dev/null || true

test_nas() {
  sudo mount -t cifs "$NAS_SHARE" "$MOUNT_POINT" \
    -o vers=3.0,iocharset=utf8,uid=1000,gid=1000,credentials="$CRED_FILE" \
    >/dev/null 2>&1
}

validate_existing() {
  [ -f "$CRED_FILE" ] && test_nas
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

    printf 'username=%s\npassword=%s\n' "$NAS_USER" "$NAS_PASS" \
      | sudo tee "$CRED_FILE" > /dev/null

    sudo chown root:root "$CRED_FILE"
    sudo chmod 600 "$CRED_FILE"

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
Options=vers=3.0,iocharset=utf8,uid=1000,gid=1000,credentials=$CRED_FILE

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
sudo systemctl enable --now mnt-nas_models.automount

echo "Models: $LOCAL_MODELS"
echo "NAS:    $MOUNT_POINT"
