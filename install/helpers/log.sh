#!/bin/bash

set -eEo pipefail

foundationos_step() {
  echo "[foundationos] $*"
}

foundationos_info() {
  echo "[foundationos][info] $*"
}

foundationos_warn() {
  echo "[foundationos][warn] $*" >&2
}

foundationos_error() {
  echo "[foundationos][error] $*" >&2
}

foundationos_die() {
  foundationos_error "$*"
  exit 1
}

run_logged() {
  local script="$1"

  foundationos_step "Running $(basename "$script")"
  "$script"
}
