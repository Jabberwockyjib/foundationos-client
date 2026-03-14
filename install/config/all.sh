#!/bin/bash

set -eEo pipefail

source "$FOUNDATIONOS_INSTALL/config/apply-foundation-config.sh"
source "$FOUNDATIONOS_INSTALL/config/install-shell-integrations.sh"
source "$FOUNDATIONOS_INSTALL/config/install-desktop-agent.sh"
