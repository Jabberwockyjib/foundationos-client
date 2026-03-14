#!/bin/bash

set -eEo pipefail

case "${FOUNDATION_AGENT_PACKAGE_MODE:-skip}" in
  pacman)
    foundationos_step "Installing Foundation desktop agent package"
    if command -v pacman >/dev/null 2>&1; then
      sudo pacman -S --noconfirm --needed "$FOUNDATION_AGENT_PACKAGE"
    else
      foundationos_warn "pacman is unavailable. Cannot install $FOUNDATION_AGENT_PACKAGE."
    fi
    ;;
  skip)
    foundationos_warn "Desktop agent package install is skipped. Set FOUNDATION_AGENT_PACKAGE_MODE=pacman when a validated package source exists."
    ;;
  aur|artifact)
    foundationos_warn "Desktop agent package mode '$FOUNDATION_AGENT_PACKAGE_MODE' requires an external artifact flow that is not available in this repo yet."
    ;;
  *)
    foundationos_warn "Unknown desktop agent package mode '$FOUNDATION_AGENT_PACKAGE_MODE'."
    ;;
esac
