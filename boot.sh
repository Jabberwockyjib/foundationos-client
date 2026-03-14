#!/bin/bash

set -eEo pipefail

export FOUNDATIONOS_REF="${FOUNDATIONOS_REF:-main}"
export FOUNDATIONOS_REPO="${FOUNDATIONOS_REPO:-sndfoundation/foundationos-client}"
export FOUNDATIONOS_PATH="${FOUNDATIONOS_PATH:-$HOME/.local/share/foundationos}"
export PATH="$FOUNDATIONOS_PATH/bin:$PATH"

echo "Cloning FoundationOS from https://github.com/${FOUNDATIONOS_REPO}.git"
rm -rf "$FOUNDATIONOS_PATH"
git clone "https://github.com/${FOUNDATIONOS_REPO}.git" "$FOUNDATIONOS_PATH"

cd "$FOUNDATIONOS_PATH"
git fetch origin "$FOUNDATIONOS_REF"
git checkout "$FOUNDATIONOS_REF"

echo "Starting FoundationOS install from branch $FOUNDATIONOS_REF"
source "$FOUNDATIONOS_PATH/install.sh"
