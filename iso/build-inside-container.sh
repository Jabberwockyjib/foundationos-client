#!/bin/bash

set -eEo pipefail

repo_root="/workspace"
profile_src="/usr/share/archiso/configs/releng"
work_root="/tmp/foundationos-archiso"
profile_dir="$work_root/profile"
work_dir="$work_root/work"
profile_name="${FOUNDATIONOS_ISO_PROFILE:-production}"
common_profile_dir="$repo_root/iso/profiles/common"
selected_profile_dir="$repo_root/iso/profiles/$profile_name"
profile_env="$selected_profile_dir/profile.env"
iso_name="${FOUNDATIONOS_ISO_NAME:-}"
output_dir="${FOUNDATIONOS_ISO_OUTPUT:-$repo_root/out/iso}"
built_at="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
release_id=""
channel=""
site_ref=""
iso_application=""
iso_publisher=""
iso_install_dir=""
iso_label_value=""

resolve_source_revision() {
  if [[ -n ${FOUNDATIONOS_SOURCE_REVISION:-} ]]; then
    printf '%s\n' "$FOUNDATIONOS_SOURCE_REVISION"
    return
  fi

  if git -C "$repo_root" rev-parse --verify HEAD >/dev/null 2>&1; then
    git -C "$repo_root" rev-parse HEAD
    return
  fi

  printf 'unknown\n'
}

resolve_source_repo() {
  if [[ -n ${FOUNDATIONOS_SOURCE_REPO:-} ]]; then
    printf '%s\n' "$FOUNDATIONOS_SOURCE_REPO"
    return
  fi

  printf 'https://github.com/Jabberwockyjib/foundationos-client\n'
}

copy_overlay_dir() {
  local src_dir="$1"
  local dest_dir="$2"

  if [[ -d $src_dir ]]; then
    rsync -a "$src_dir"/ "$dest_dir"/
  fi
}

set_profile_var() {
  local file="$1"
  local key="$2"
  local value="$3"

  if grep -q "^${key}=" "$file"; then
    sed -i "s|^${key}=.*|${key}=${value}|" "$file"
  else
    echo "${key}=${value}" >> "$file"
  fi
}

append_package_if_missing() {
  local file="$1"
  local package="$2"

  if ! grep -qx "$package" "$file"; then
    echo "$package" >> "$file"
  fi
}

append_packages_from_file() {
  local packages_file="$1"
  local target_file="$2"
  local package_name

  [[ -f $packages_file ]] || return 0

  while IFS= read -r package_name; do
    [[ -z $package_name || $package_name == \#* ]] && continue
    append_package_if_missing "$target_file" "$package_name"
  done < "$packages_file"
}

build_iso_label() {
  local profile_segment="$1"
  local stamp="$2"
  local short_profile
  local label

  case "$profile_segment" in
    production) short_profile="PROD" ;;
    bootstrap) short_profile="BOOT" ;;
    *) short_profile="$(printf '%s' "$profile_segment" | tr '[:lower:]-' '[:upper:]_' | cut -c1-4)" ;;
  esac

  label="FOS_${short_profile}_${stamp}"

  if ((${#label} > 16)); then
    label="$(printf '%s' "$label" | cut -c1-16)"
  fi

  printf '%s\n' "$label"
}

write_release_metadata() {
  local airootfs_dir="$1"
  local git_revision

  git_revision="$(resolve_source_revision)"

  cat > "$airootfs_dir/etc/foundationos-release.env" <<EOF
FOUNDATIONOS_ISO_PROFILE=$profile_name
FOUNDATIONOS_ISO_NAME=$iso_name
FOUNDATIONOS_RELEASE_ID=$release_id
FOUNDATIONOS_CHANNEL=$channel
FOUNDATIONOS_SITE_REF=$site_ref
FOUNDATIONOS_BUILT_AT=$built_at
FOUNDATIONOS_SOURCE_REVISION=$git_revision
EOF

  cat > "$airootfs_dir/etc/foundationos-live.conf" <<EOF
FOUNDATIONOS_SITE_REF=$site_ref
FOUNDATIONOS_CHANNEL=$channel
FOUNDATIONOS_RELEASE_ID=$release_id
EOF
}

write_host_artifacts() {
  local iso_path="$1"
  local iso_basename metadata_path checksum_path git_revision source_repo

  iso_basename="$(basename "$iso_path")"
  metadata_path="$output_dir/${iso_basename%.iso}.json"
  checksum_path="$output_dir/${iso_basename}.sha256"
  git_revision="$(resolve_source_revision)"
  source_repo="$(resolve_source_repo)"

  sha256sum "$iso_path" > "$checksum_path"

  cat > "$metadata_path" <<EOF
{
  "profile": "$profile_name",
  "iso_name": "$iso_basename",
  "release_id": "$release_id",
  "channel": "$channel",
  "site_ref": "$site_ref",
  "built_at": "$built_at",
  "source_revision": "$git_revision",
  "source_repo": "$source_repo"
}
EOF
}

if [[ $(uname -m) != x86_64 ]]; then
  echo "This builder expects an x86_64 container. Set FOUNDATIONOS_DOCKER_PLATFORM=linux/amd64." >&2
  exit 1
fi

if [[ ! -d $selected_profile_dir ]]; then
  echo "Unknown ISO profile: $profile_name" >&2
  exit 1
fi

if [[ -f $profile_env ]]; then
  # shellcheck disable=SC1090
  source "$profile_env"
fi

release_id="${FOUNDATIONOS_RELEASE_ID:-foundationos-client-live-dev}"
channel="${FOUNDATIONOS_CHANNEL:-pilot}"
site_ref="${FOUNDATIONOS_SITE_REF:-production}"
iso_application="${FOUNDATIONOS_ISO_APPLICATION:-FoundationOS Live ISO}"
iso_publisher="${FOUNDATIONOS_ISO_PUBLISHER:-2ndFOUNDATION <https://github.com/Jabberwockyjib/foundationos-client>}"
iso_install_dir="${FOUNDATIONOS_ISO_INSTALL_DIR:-foundationos}"

if [[ -z $iso_name ]]; then
  iso_name="${FOUNDATIONOS_ISO_NAME:-foundationos-$profile_name}"
fi

iso_label_value="$(build_iso_label "$profile_name" "$(date +%Y%m)")"

rm -rf "$work_root"
mkdir -p "$profile_dir" "$output_dir"

cp -a "$profile_src"/. "$profile_dir"/

set_profile_var "$profile_dir/profiledef.sh" iso_name "\"$iso_name\""
set_profile_var "$profile_dir/profiledef.sh" iso_label "\"$iso_label_value\""
set_profile_var "$profile_dir/profiledef.sh" iso_publisher "\"$iso_publisher\""
set_profile_var "$profile_dir/profiledef.sh" iso_application "\"$iso_application\""
set_profile_var "$profile_dir/profiledef.sh" install_dir "\"$iso_install_dir\""

append_packages_from_file "$common_profile_dir/packages.x86_64.append" "$profile_dir/packages.x86_64"
append_packages_from_file "$selected_profile_dir/packages.x86_64.append" "$profile_dir/packages.x86_64"

# Arch's current releng set can pull libxtables through packages that leave the
# provider ambiguous. Pin one explicitly so pacstrap stays non-interactive.
if ! grep -Eq '^(iptables|iptables-nft)$' "$profile_dir/packages.x86_64"; then
  append_package_if_missing "$profile_dir/packages.x86_64" "iptables"
fi

mkdir -p "$profile_dir/airootfs/opt/foundationos-client"

rsync -a \
  --delete \
  --exclude '.git' \
  --exclude 'out' \
  --exclude 'iso/work' \
  --exclude 'iso/profile' \
  "$repo_root"/ \
  "$profile_dir/airootfs/opt/foundationos-client"/

copy_overlay_dir "$common_profile_dir/airootfs" "$profile_dir/airootfs"
copy_overlay_dir "$selected_profile_dir/airootfs" "$profile_dir/airootfs"

mkdir -p \
  "$profile_dir/airootfs/etc" \
  "$profile_dir/airootfs/etc/systemd/system/multi-user.target.wants"

write_release_metadata "$profile_dir/airootfs"

if [[ -f $profile_dir/airootfs/etc/systemd/system/foundationos-live-prepare.service ]]; then
  ln -snf ../foundationos-live-prepare.service \
    "$profile_dir/airootfs/etc/systemd/system/multi-user.target.wants/foundationos-live-prepare.service"
fi

set +o pipefail
yes '' | mkarchiso -v -w "$work_dir" -o "$output_dir" "$profile_dir"
mkarchiso_status=${PIPESTATUS[1]}
set -o pipefail

if (( mkarchiso_status != 0 )); then
  exit "$mkarchiso_status"
fi

iso_path="$(find "$output_dir" -maxdepth 1 -type f -name '*.iso' | sort | tail -1)"

if [[ -z ${iso_path:-} ]]; then
  echo "mkarchiso completed without producing an ISO artifact." >&2
  exit 1
fi

write_host_artifacts "$iso_path"

echo
echo "FoundationOS $profile_name ISO created under $output_dir"
