#!/bin/bash

set -eEo pipefail

foundationos_step "Running Arch preflight checks"

if ! command -v pacman >/dev/null 2>&1; then
  foundationos_warn "pacman is not available. This skeleton assumes an Arch-based client image."
fi
