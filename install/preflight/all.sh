#!/bin/bash

set -eEo pipefail

if [[ -f $FOUNDATIONOS_INSTALL/preflight/upstream.sh ]]; then
  pushd "$FOUNDATIONOS_INSTALL" >/dev/null
  source "$FOUNDATIONOS_INSTALL/preflight/upstream.sh"
  popd >/dev/null
fi

source "$FOUNDATIONOS_INSTALL/preflight/check-arch.sh"
source "$FOUNDATIONOS_INSTALL/preflight/check-network.sh"
