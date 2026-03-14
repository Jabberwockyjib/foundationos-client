#!/bin/bash

set -eEo pipefail

run_logged "$FOUNDATIONOS_INSTALL/packaging/foundation-base.sh"
run_logged "$FOUNDATIONOS_INSTALL/packaging/freeipa-client.sh"
run_logged "$FOUNDATIONOS_INSTALL/packaging/desktop-agent.sh"
