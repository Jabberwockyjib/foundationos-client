#!/bin/bash

set -eEo pipefail

script_dir="$(cd -- "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd -- "$script_dir/.." && pwd)"

docker_engine="${FOUNDATIONOS_DOCKER_ENGINE:-docker}"
docker_platform="${FOUNDATIONOS_DOCKER_PLATFORM:-linux/amd64}"
builder_tag="${FOUNDATIONOS_DOCKER_TAG:-foundationos-archiso-builder}"
profile="${FOUNDATIONOS_ISO_PROFILE:-production}"
iso_output="${FOUNDATIONOS_ISO_OUTPUT:-/workspace/out/iso}"
iso_name="${FOUNDATIONOS_ISO_NAME:-}"
source_revision="${FOUNDATIONOS_SOURCE_REVISION:-}"
source_repo="${FOUNDATIONOS_SOURCE_REPO:-https://github.com/Jabberwockyjib/foundationos-client}"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --profile)
      profile="$2"
      shift 2
      ;;
    --output)
      iso_output="$2"
      shift 2
      ;;
    --name)
      iso_name="$2"
      shift 2
      ;;
    *)
      echo "Unknown argument: $1" >&2
      exit 1
      ;;
  esac
done

if ! command -v "$docker_engine" >/dev/null 2>&1; then
  echo "Container engine not found: $docker_engine" >&2
  exit 1
fi

if [[ -z $source_revision ]]; then
  if git -C "$repo_root" rev-parse --verify HEAD >/dev/null 2>&1; then
    source_revision="$(git -C "$repo_root" rev-parse HEAD)"
  elif git -C "$repo_root/.." rev-parse --verify HEAD >/dev/null 2>&1; then
    source_revision="$(git -C "$repo_root/.." rev-parse HEAD)"
  else
    source_revision="unknown"
  fi
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
  -e FOUNDATIONOS_ISO_PROFILE="$profile" \
  -e FOUNDATIONOS_ISO_NAME="$iso_name" \
  -e FOUNDATIONOS_ISO_OUTPUT="$iso_output" \
  -e FOUNDATIONOS_RELEASE_ID="${FOUNDATIONOS_RELEASE_ID:-}" \
  -e FOUNDATIONOS_CHANNEL="${FOUNDATIONOS_CHANNEL:-}" \
  -e FOUNDATIONOS_SITE_REF="${FOUNDATIONOS_SITE_REF:-}" \
  -e FOUNDATIONOS_ISO_APPLICATION="${FOUNDATIONOS_ISO_APPLICATION:-}" \
  -e FOUNDATIONOS_ISO_PUBLISHER="${FOUNDATIONOS_ISO_PUBLISHER:-}" \
  -e FOUNDATIONOS_ISO_INSTALL_DIR="${FOUNDATIONOS_ISO_INSTALL_DIR:-}" \
  -e FOUNDATIONOS_SOURCE_REVISION="$source_revision" \
  -e FOUNDATIONOS_SOURCE_REPO="$source_repo" \
  -v "$repo_root":/workspace \
  "$builder_tag" \
  /workspace/iso/build-inside-container.sh
