#!/bin/bash

set -eEo pipefail

foundationos_step "Applying FoundationOS config overlays"

mkdir -p "$HOME/.config/foundationos"

if [[ ! -f $HOME/.config/foundationos/foundationos.conf ]]; then
  install -m 0644 \
    "$FOUNDATIONOS_PATH/config/foundationos/foundationos.conf" \
    "$HOME/.config/foundationos/foundationos.conf"
else
  foundationos_info "Keeping existing user config at $HOME/.config/foundationos/foundationos.conf"
fi

install -m 0644 \
  "$FOUNDATIONOS_PATH/default/role-bundle-map.conf" \
  "$HOME/.config/foundationos/role-bundle-map.conf"

foundationos_step "Config overlay applied"
