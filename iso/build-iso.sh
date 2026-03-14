#!/bin/bash

set -eEo pipefail

script_dir="$(cd -- "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd -- "$script_dir/.." && pwd)"

docker_engine="${FOUNDATIONOS_DOCKER_ENGINE:-docker}"
docker_platform="${FOUNDATIONOS_DOCKER_PLATFORM:-linux/amd64}"
builder_tag="${FOUNDATIONOS_DOCKER_TAG:-foundationos-archiso-builder}"

if ! command -v "$docker_engine" >/dev/null 2>&1; then
  echo "Container engine not found: $docker_engine" >&2
  exit 1
fi

"$docker_engine" build \
  --platform "$docker_platform" \
  -t "$builder_tag" \
  -f "$script_dir/Dockerfile" \
  "$script_dir"

"$docker_engine" run \
  --rm \
  --privileged \
  --platform "$docker_platform" \
  -e FOUNDATIONOS_ISO_NAME="${FOUNDATIONOS_ISO_NAME:-foundationos-bootstrap}" \
  -e FOUNDATIONOS_ISO_OUTPUT="${FOUNDATIONOS_ISO_OUTPUT:-/workspace/out/iso}" \
  -v "$repo_root":/workspace \
  "$builder_tag" \
  /workspace/iso/build-inside-container.sh
