#!/bin/bash

set -eEo pipefail

if [[ -f $FOUNDATIONOS_INSTALL/post-install/upstream.sh ]]; then
  source "$FOUNDATIONOS_INSTALL/post-install/upstream.sh"
fi

source "$FOUNDATIONOS_INSTALL/post-install/print-next-steps.sh"
