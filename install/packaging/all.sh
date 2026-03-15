#!/bin/bash

set -eEo pipefail

if [[ -f $FOUNDATIONOS_INSTALL/packaging/upstream.sh ]]; then
  pushd "$FOUNDATIONOS_INSTALL" >/dev/null
  source "$FOUNDATIONOS_INSTALL/packaging/upstream.sh"
  popd >/dev/null
fi

run_logged "$FOUNDATIONOS_INSTALL/packaging/foundation-base.sh"
run_logged "$FOUNDATIONOS_INSTALL/packaging/freeipa-client.sh"
run_logged "$FOUNDATIONOS_INSTALL/packaging/desktop-agent.sh"
