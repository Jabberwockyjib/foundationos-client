#!/bin/bash

set -eEo pipefail

foundationos_step "Installing FoundationOS base packages"

if ! command -v pacman >/dev/null 2>&1; then
  foundationos_warn "pacman is unavailable. Skipping package installation."
  exit 0
fi

mapfile -t packages < <(grep -v '^#' "$FOUNDATIONOS_INSTALL/foundationos-base.packages" | grep -v '^$')

if (( ${#packages[@]} == 0 )); then
  foundationos_warn "No FoundationOS base packages are defined."
  exit 0
fi

sudo pacman -S --noconfirm --needed "${packages[@]}"
