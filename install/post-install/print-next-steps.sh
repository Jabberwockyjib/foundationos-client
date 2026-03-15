#!/bin/bash

set -eEo pipefail

foundationos_step "FoundationOS install scaffolding completed"
cat <<EOF
Next steps:
- review ~/.config/foundationos/foundationos.conf
- run foundationos-upstream-status to configure upstream desktop tracking
- run foundationos-enroll --stage-only to inspect enrollment flow
- merge ~/.config/foundationos/waybar/foundation-module.jsonc into the active Waybar config
- publish a signed desktop-agent artifact and FreeIPA enrollment credential flow
EOF
