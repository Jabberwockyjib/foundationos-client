#!/bin/bash

set -eEo pipefail

if [[ -f $FOUNDATIONOS_INSTALL/login/upstream.sh ]]; then
  source "$FOUNDATIONOS_INSTALL/login/upstream.sh"
fi

source "$FOUNDATIONOS_INSTALL/login/configure-sssd.sh"
