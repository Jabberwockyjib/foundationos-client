#!/bin/bash

set -eEo pipefail

if [[ -f $FOUNDATIONOS_INSTALL/config/upstream.sh ]]; then
  pushd "$FOUNDATIONOS_INSTALL" >/dev/null
  source "$FOUNDATIONOS_INSTALL/config/upstream.sh"
  popd >/dev/null
fi

source "$FOUNDATIONOS_INSTALL/config/apply-foundation-config.sh"
source "$FOUNDATIONOS_INSTALL/config/install-shell-integrations.sh"
source "$FOUNDATIONOS_INSTALL/config/install-visual-theme.sh"
source "$FOUNDATIONOS_INSTALL/config/install-desktop-agent.sh"
