#!/bin/bash

set -eEo pipefail

foundationos_step "Applying FoundationOS config overlays"

mkdir -p "$HOME/.config/foundationos"
install -m 0644 "$FOUNDATIONOS_PATH/config/foundationos/foundationos.conf" "$HOME/.config/foundationos/foundationos.conf"

foundationos_step "Config overlay applied"
