#!/bin/bash

set -eEo pipefail

repo_root="/workspace"
profile_src="/usr/share/archiso/configs/releng"
work_root="/tmp/foundationos-archiso"
profile_dir="$work_root/profile"
work_dir="$work_root/work"
iso_name="${FOUNDATIONOS_ISO_NAME:-foundationos-bootstrap}"
output_dir="${FOUNDATIONOS_ISO_OUTPUT:-$repo_root/out/iso}"

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

if [[ $(uname -m) != x86_64 ]]; then
  echo "This builder expects an x86_64 container. Set FOUNDATIONOS_DOCKER_PLATFORM=linux/amd64." >&2
  exit 1
fi

rm -rf "$work_root"
mkdir -p "$profile_dir" "$output_dir"

cp -a "$profile_src"/. "$profile_dir"/

set_profile_var "$profile_dir/profiledef.sh" iso_name "\"$iso_name\""
set_profile_var "$profile_dir/profiledef.sh" iso_label "\"${iso_name}-$(date +%Y%m)\""
set_profile_var "$profile_dir/profiledef.sh" iso_publisher "\"2ndFOUNDATION <https://github.com/Jabberwockyjib/foundationos-client>\""
set_profile_var "$profile_dir/profiledef.sh" iso_application "\"FoundationOS Bootstrap ISO\""
set_profile_var "$profile_dir/profiledef.sh" install_dir "\"foundationos\""

append_package_if_missing "$profile_dir/packages.x86_64" git
append_package_if_missing "$profile_dir/packages.x86_64" rsync
append_package_if_missing "$profile_dir/packages.x86_64" jq
append_package_if_missing "$profile_dir/packages.x86_64" curl

mkdir -p \
  "$profile_dir/airootfs/opt/foundationos-client" \
  "$profile_dir/airootfs/usr/local/bin" \
  "$profile_dir/airootfs/etc"

rsync -a \
  --delete \
  --exclude '.git' \
  --exclude 'out' \
  --exclude 'iso/work' \
  --exclude 'iso/profile' \
  "$repo_root"/ \
  "$profile_dir/airootfs/opt/foundationos-client"/

install -m 0755 \
  "$repo_root/iso/root/foundationos-live-stage" \
  "$profile_dir/airootfs/usr/local/bin/foundationos-live-stage"
install -m 0644 \
  "$repo_root/iso/root/motd" \
  "$profile_dir/airootfs/etc/motd"

mkarchiso -v -w "$work_dir" -o "$output_dir" "$profile_dir"

echo
echo "FoundationOS bootstrap ISO created under $output_dir"
