#!/bin/bash

set -eEo pipefail

foundationos_step "Install skeleton completed"
cat <<EOF
Next steps:
- implement FreeIPA join
- package the desktop agent
- wire Waybar and launcher integrations
- publish the first image manifest
EOF
