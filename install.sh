#!/bin/bash

set -eEo pipefail

export FOUNDATIONOS_PATH="${FOUNDATIONOS_PATH:-$HOME/.local/share/foundationos}"
export FOUNDATIONOS_INSTALL="$FOUNDATIONOS_PATH/install"
export PATH="$FOUNDATIONOS_PATH/bin:$PATH"

source "$FOUNDATIONOS_INSTALL/helpers/all.sh"
source "$FOUNDATIONOS_INSTALL/preflight/all.sh"
source "$FOUNDATIONOS_INSTALL/config/all.sh"
source "$FOUNDATIONOS_INSTALL/login/all.sh"
source "$FOUNDATIONOS_INSTALL/post-install/all.sh"
