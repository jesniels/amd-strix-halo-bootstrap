#!/usr/bin/env bash
set -euo pipefail

echo "== Git =="

if ! command -v git &>/dev/null; then
  sudo dnf install -y git
fi

if ! git config --global --get user.name &>/dev/null; then
  git config --global user.name "Jesper Nielsen"
fi

if ! git config --global --get user.email &>/dev/null; then
  git config --global user.email "jesniels@gmail.com"
fi
