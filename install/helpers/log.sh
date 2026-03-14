#!/bin/bash

set -eEo pipefail

foundationos_step() {
  echo "[foundationos] $*"
}

foundationos_warn() {
  echo "[foundationos][warn] $*" >&2
}
