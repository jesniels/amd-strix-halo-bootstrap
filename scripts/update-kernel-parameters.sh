#!/usr/bin/env bash
set -euo pipefail

echo "== Strix Halo kernel parameter updater =="

GRUB_FILE="/etc/default/grub"

if [ ! -f "$GRUB_FILE" ]; then
  echo "ERROR: $GRUB_FILE not found"
  exit 1
fi

########################################
# Read current kernel params
########################################
CURRENT_LINE=$(grep '^GRUB_CMDLINE_LINUX=' "$GRUB_FILE")

echo ""
echo "CURRENT (FROM):"
echo "$CURRENT_LINE"
echo ""

EXISTING_PARAMS=$(echo "$CURRENT_LINE" | sed 's/GRUB_CMDLINE_LINUX="\([^"]*\)"/\1/')

########################################
# Required parameters
########################################
REQ_IOMMU="amd_iommu=off"
# previously iommu=pt
REQ_GTT="amdgpu.gttsize=126976"
REQ_TTM="ttm.pages_limit=32505856"

########################################
# helper: check if param exists
########################################
contains() {
  [[ "$1" == *"$2"* ]]
}

########################################
# build new param set (non-destructive)
########################################
NEW_PARAMS="$EXISTING_PARAMS"

if ! contains "$NEW_PARAMS" "$REQ_IOMMU"; then
  NEW_PARAMS="$NEW_PARAMS $REQ_IOMMU"
fi

if ! contains "$NEW_PARAMS" "$REQ_GTT"; then
  NEW_PARAMS="$NEW_PARAMS $REQ_GTT"
fi

if ! contains "$NEW_PARAMS" "$REQ_TTM"; then
  NEW_PARAMS="$NEW_PARAMS $REQ_TTM"
fi

########################################
# normalize whitespace
########################################
NEW_PARAMS=$(echo "$NEW_PARAMS" | xargs)

echo ""
echo "NEW (TO):"
echo "GRUB_CMDLINE_LINUX=\"$NEW_PARAMS\""
echo ""

########################################
# CRITICAL FIX: no-op detection
########################################
if [ "$NEW_PARAMS" = "$EXISTING_PARAMS" ]; then
  echo "No changes required ✔ (kernel params already correct)"
  exit 0
fi

########################################
# confirmation gate
########################################
read -p "Apply these kernel parameter changes? (type 'yes' to continue): " CONFIRM

if [ "$CONFIRM" != "yes" ]; then
  echo "Aborted. No changes made."
  exit 0
fi

########################################
# backup + apply
########################################
sudo cp "$GRUB_FILE" "$GRUB_FILE.bak.$(date +%s)"

sudo sed -i "s|^GRUB_CMDLINE_LINUX=\".*\"|GRUB_CMDLINE_LINUX=\"$NEW_PARAMS\"|" "$GRUB_FILE"

echo "Regenerating GRUB config..."

if [ -d /boot/grub2 ]; then
  sudo grub2-mkconfig -o /boot/grub2/grub.cfg
elif [ -d /boot/efi/EFI/fedora ]; then
  sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg
fi

echo "DONE ✔ Kernel parameters updated"
echo "********** REBOOT RECOMMENDED ***************"
