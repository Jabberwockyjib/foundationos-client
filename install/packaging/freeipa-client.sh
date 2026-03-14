#!/bin/bash

set -eEo pipefail

case "${FREEIPA_CLIENT_PACKAGE_MODE:-skip}" in
  pacman)
    foundationos_step "Installing FreeIPA client package"
    if command -v pacman >/dev/null 2>&1; then
      sudo pacman -S --noconfirm --needed "$FREEIPA_CLIENT_PACKAGE"
    else
      foundationos_warn "pacman is unavailable. Cannot install $FREEIPA_CLIENT_PACKAGE."
    fi
    ;;
  skip)
    foundationos_warn "FreeIPA client package install is skipped. Set FREEIPA_CLIENT_PACKAGE_MODE=pacman when a validated package source exists."
    ;;
  aur|artifact)
    foundationos_warn "FreeIPA client package mode '$FREEIPA_CLIENT_PACKAGE_MODE' requires an external artifact flow that is not available in this repo yet."
    ;;
  *)
    foundationos_warn "Unknown FreeIPA client package mode '$FREEIPA_CLIENT_PACKAGE_MODE'."
    ;;
esac
