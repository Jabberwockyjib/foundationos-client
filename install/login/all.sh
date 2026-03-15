#!/bin/bash

set -eEo pipefail

if [[ -f $FOUNDATIONOS_INSTALL/login/upstream.sh ]]; then
  pushd "$FOUNDATIONOS_INSTALL" >/dev/null
  source "$FOUNDATIONOS_INSTALL/login/upstream.sh"
  popd >/dev/null
fi

source "$FOUNDATIONOS_INSTALL/login/configure-sssd.sh"
