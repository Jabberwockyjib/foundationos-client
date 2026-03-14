#!/bin/bash

set -eEo pipefail

foundationos_step "Preparing login and identity integration"

if [[ ${FOUNDATIONOS_AUTO_ENROLL:-false} == true ]]; then
  foundationos_info "FOUNDATIONOS_AUTO_ENROLL is enabled; attempting unattended FreeIPA join."
  "$FOUNDATIONOS_PATH/bin/foundationos-join-freeipa" || foundationos_warn "Automatic FreeIPA join did not complete."
else
  "$FOUNDATIONOS_PATH/bin/foundationos-join-freeipa" --stage-only
  foundationos_warn "FreeIPA join is staged but not executed. Provide enrollment credentials or OTP and run foundationos-enroll."
fi
