#!/bin/bash

set -eEo pipefail

if [[ -f $FOUNDATIONOS_INSTALL/preflight/upstream.sh ]]; then
  source "$FOUNDATIONOS_INSTALL/preflight/upstream.sh"
fi

source "$FOUNDATIONOS_INSTALL/preflight/check-arch.sh"
source "$FOUNDATIONOS_INSTALL/preflight/check-network.sh"
