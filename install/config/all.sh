#!/bin/bash

set -eEo pipefail

if [[ -f $FOUNDATIONOS_INSTALL/config/upstream.sh ]]; then
  source "$FOUNDATIONOS_INSTALL/config/upstream.sh"
fi

source "$FOUNDATIONOS_INSTALL/config/apply-foundation-config.sh"
source "$FOUNDATIONOS_INSTALL/config/install-shell-integrations.sh"
source "$FOUNDATIONOS_INSTALL/config/install-desktop-agent.sh"
