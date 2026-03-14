#!/bin/bash

set -eEo pipefail

foundationos_step "Checking network reachability"

if ! command -v curl >/dev/null 2>&1; then
  foundationos_warn "curl is missing. Install it before implementing enrollment and API checks."
fi
