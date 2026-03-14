#!/bin/bash

set -eEo pipefail

foundationos_step "Staging desktop agent integration"
"$FOUNDATIONOS_PATH/bin/foundationos-install-agent" --stage-only || foundationos_warn "Desktop agent staging reported a blocker."
