#!/bin/bash

set -eEo pipefail

export FOUNDATIONOS_PATH="${FOUNDATIONOS_PATH:-$(cd -- "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"
export FOUNDATIONOS_ROOT="${FOUNDATIONOS_ROOT:-$FOUNDATIONOS_PATH}"
export FOUNDATIONOS_INSTALL="$FOUNDATIONOS_PATH/install"
export FOUNDATIONOS_INSTALL_LOG_FILE="${FOUNDATIONOS_INSTALL_LOG_FILE:-/var/log/foundationos-install.log}"
export PATH="$FOUNDATIONOS_PATH/bin:$PATH"

source "$FOUNDATIONOS_INSTALL/helpers/all.sh"
source "$FOUNDATIONOS_INSTALL/preflight/all.sh"
source "$FOUNDATIONOS_INSTALL/packaging/all.sh"
source "$FOUNDATIONOS_INSTALL/config/all.sh"
source "$FOUNDATIONOS_INSTALL/login/all.sh"
source "$FOUNDATIONOS_INSTALL/post-install/all.sh"
