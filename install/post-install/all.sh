#!/bin/bash

set -eEo pipefail

if [[ -f $FOUNDATIONOS_INSTALL/post-install/upstream.sh ]]; then
  pushd "$FOUNDATIONOS_INSTALL" >/dev/null
  source "$FOUNDATIONOS_INSTALL/post-install/upstream.sh"
  popd >/dev/null
fi

source "$FOUNDATIONOS_INSTALL/post-install/print-next-steps.sh"
