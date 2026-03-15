#!/bin/bash

set -eEo pipefail

if ! declare -F foundationos_step >/dev/null 2>&1; then
  foundationos_step() {
    echo "[foundationos] $*"
  }
fi

if ! declare -F foundationos_info >/dev/null 2>&1; then
  foundationos_info() {
    echo "[foundationos][info] $*"
  }
fi

if ! declare -F foundationos_warn >/dev/null 2>&1; then
  foundationos_warn() {
    echo "[foundationos][warn] $*" >&2
  }
fi

if ! declare -F foundationos_error >/dev/null 2>&1; then
  foundationos_error() {
    echo "[foundationos][error] $*" >&2
  }
fi

if ! declare -F foundationos_die >/dev/null 2>&1; then
  foundationos_die() {
    foundationos_error "$*"
    exit 1
  }
fi

if ! declare -F run_logged >/dev/null 2>&1; then
  run_logged() {
    local script="$1"

    foundationos_step "Running $(basename "$script")"
    "$script"
  }
fi
