#!/bin/bash

set -eEo pipefail

source "$FOUNDATIONOS_INSTALL/helpers/log.sh"

helper_root="${OMARCHY_INSTALL:-$FOUNDATIONOS_INSTALL}/helpers"

source_helper_if_present() {
  local helper_name="$1"
  local helper_path="$helper_root/$helper_name"

  if [[ -f $helper_path ]]; then
    # shellcheck disable=SC1090
    source "$helper_path"
  fi
}

source_helper_if_present chroot.sh
source_helper_if_present presentation.sh
source_helper_if_present errors.sh
source_helper_if_present logging.sh
