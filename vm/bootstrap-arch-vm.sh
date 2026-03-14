#!/bin/bash

set -eEo pipefail

if [[ $EUID -eq 0 ]]; then
  echo "Run this script as your normal user, not root." >&2
  exit 1
fi

if ! command -v sudo >/dev/null 2>&1; then
  echo "sudo is required." >&2
  exit 1
fi

if ! command -v pacman >/dev/null 2>&1; then
  echo "This script expects an Arch-based guest." >&2
  exit 1
fi

repo_dir="${1:-$HOME/sndfoundation}"
client_dir="$repo_dir/foundationos-client"
target_dir="${FOUNDATIONOS_VM_TARGET:-$HOME/.local/share/foundationos-vm}"

sudo pacman -Syu --noconfirm --needed git rsync jq curl base-devel networkmanager
sudo systemctl enable --now NetworkManager

if [[ ! -d $repo_dir/.git ]]; then
  echo "Expected repo checkout at $repo_dir" >&2
  echo "Clone your repo first, then rerun:" >&2
  echo "  git clone <repo-url> $repo_dir" >&2
  exit 1
fi

if [[ ! -x $client_dir/bin/foundationos-vm-stage ]]; then
  echo "FoundationOS client checkout not found at $client_dir" >&2
  exit 1
fi

"$client_dir/bin/foundationos-vm-stage" --target "$target_dir"

FOUNDATIONOS_ROOT="$target_dir" \
FOUNDATIONOS_PATH="$target_dir" \
bash "$target_dir/install.sh"

cat <<EOF

FoundationOS VM staging complete.

Next checks:
  foundationos-status
  foundationos-update plan
  foundationos-enroll --stage-only
  fastfetch

EOF
