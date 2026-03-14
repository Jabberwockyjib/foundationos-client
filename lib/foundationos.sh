#!/bin/bash

set -eEo pipefail

FOUNDATIONOS_LIB_DIR="$(cd -- "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FOUNDATIONOS_SOURCE_ROOT="$(cd -- "$FOUNDATIONOS_LIB_DIR/.." && pwd)"

foundationos::apply_defaults() {
  export FOUNDATIONOS_ROOT="${FOUNDATIONOS_ROOT:-$FOUNDATIONOS_SOURCE_ROOT}"
  export FOUNDATIONOS_PATH="${FOUNDATIONOS_PATH:-$FOUNDATIONOS_ROOT}"
  export OMARCHY_PATH="${OMARCHY_PATH:-$HOME/.local/share/omarchy}"
  export FOUNDATIONOS_INSTALL="${FOUNDATIONOS_INSTALL:-$FOUNDATIONOS_ROOT/install}"
  export FOUNDATIONOS_CONFIG_DIR="${FOUNDATIONOS_CONFIG_DIR:-$HOME/.config/foundationos}"
  export FOUNDATIONOS_CONFIG="${FOUNDATIONOS_CONFIG:-$FOUNDATIONOS_CONFIG_DIR/foundationos.conf}"
  export FOUNDATIONOS_STATE_DIR="${FOUNDATIONOS_STATE_DIR:-$HOME/.local/state/foundationos}"
  export FOUNDATIONOS_CACHE_DIR="${FOUNDATIONOS_CACHE_DIR:-$HOME/.cache/foundationos}"
  export FOUNDATIONOS_RUNTIME_DIR="${FOUNDATIONOS_RUNTIME_DIR:-${XDG_RUNTIME_DIR:-/tmp}/foundationos}"
  export FOUNDATIONOS_LOG_DIR="${FOUNDATIONOS_LOG_DIR:-$FOUNDATIONOS_STATE_DIR/logs}"
  export FOUNDATIONOS_SITE_REF="${FOUNDATIONOS_SITE_REF:-pilot}"
  export FOUNDATIONOS_CHANNEL="${FOUNDATIONOS_CHANNEL:-internal}"
  export FOUNDATIONOS_RELEASE_ID="${FOUNDATIONOS_RELEASE_ID:-dev-local}"
  export FOUNDATIONOS_UPSTREAM_REMOTE="${FOUNDATIONOS_UPSTREAM_REMOTE:-upstream}"
  export FOUNDATIONOS_UPSTREAM_BRANCH="${FOUNDATIONOS_UPSTREAM_BRANCH:-dev}"
  export FOUNDATIONOS_FORK_BRANCH="${FOUNDATIONOS_FORK_BRANCH:-main}"
  export FOUNDATIONOS_ROLE_BUNDLE_MAP="${FOUNDATIONOS_ROLE_BUNDLE_MAP:-$FOUNDATIONOS_ROOT/default/role-bundle-map.conf}"
  export FOUNDATIONOS_ROLE_BUNDLE_STATE="${FOUNDATIONOS_ROLE_BUNDLE_STATE:-$FOUNDATIONOS_STATE_DIR/active-role-bundle.env}"
  export FOUNDATIONOS_ENROLLMENT_STATE="${FOUNDATIONOS_ENROLLMENT_STATE:-$FOUNDATIONOS_STATE_DIR/enrollment.env}"
  export FOUNDATIONOS_LAST_UPDATE_STATE="${FOUNDATIONOS_LAST_UPDATE_STATE:-$FOUNDATIONOS_STATE_DIR/last-update.env}"
  export FOUNDATIONOS_CURL_TIMEOUT="${FOUNDATIONOS_CURL_TIMEOUT:-3}"
  export FOUNDATION_BASE_URL="${FOUNDATION_BASE_URL:-http://localhost:5173}"
  export FOUNDATION_API_BASE_URL="${FOUNDATION_API_BASE_URL:-http://localhost:4000}"
  export FOUNDATION_HEALTH_PATH="${FOUNDATION_HEALTH_PATH:-/health}"
  export FOUNDATION_SEARCH_PATH="${FOUNDATION_SEARCH_PATH:-/api/search}"
  export FOUNDATION_APPROVALS_PATH="${FOUNDATION_APPROVALS_PATH:-/approvals}"
  export FOUNDATION_CHAT_PATH="${FOUNDATION_CHAT_PATH:-/chat}"
  export FOUNDATION_FLOWS_PATH="${FOUNDATION_FLOWS_PATH:-/flows}"
  export FOUNDATION_PULSE_PATH="${FOUNDATION_PULSE_PATH:-/pulse}"
  export FOUNDATION_ENTITIES_PATH="${FOUNDATION_ENTITIES_PATH:-/entities}"
  export FOUNDATION_DESKTOP_SCHEME="${FOUNDATION_DESKTOP_SCHEME:-foundation://}"
  export FOUNDATION_SEARCH_FALLBACK_PATH="${FOUNDATION_SEARCH_FALLBACK_PATH:-/explore}"
  export FOUNDATION_AGENT_PACKAGE_MODE="${FOUNDATION_AGENT_PACKAGE_MODE:-skip}"
  export FOUNDATION_AGENT_PACKAGE="${FOUNDATION_AGENT_PACKAGE:-foundation-desktop-agent}"
  export FOUNDATION_AGENT_BINARY="${FOUNDATION_AGENT_BINARY:-foundation-desktop-agent}"
  export FOUNDATION_AGENT_SERVICE="${FOUNDATION_AGENT_SERVICE:-foundation-desktop-agent.service}"
  export FOUNDATION_AGENT_API_BASE_URL="${FOUNDATION_AGENT_API_BASE_URL:-http://127.0.0.1:47832}"
  export FOUNDATION_AGENT_HEALTH_PATH="${FOUNDATION_AGENT_HEALTH_PATH:-/health}"
  export FOUNDATION_AGENT_SEARCH_PATH="${FOUNDATION_AGENT_SEARCH_PATH:-/search}"
  export FOUNDATION_AGENT_OPEN_PATH="${FOUNDATION_AGENT_OPEN_PATH:-/open}"
  export FREEIPA_DOMAIN="${FREEIPA_DOMAIN:-example.internal}"
  export FREEIPA_REALM="${FREEIPA_REALM:-EXAMPLE.INTERNAL}"
  export FREEIPA_SERVER="${FREEIPA_SERVER:-ipa.example.internal}"
  export FREEIPA_HOST_GROUP="${FREEIPA_HOST_GROUP:-foundationos-clients}"
  export FREEIPA_ENROLLMENT_MODE="${FREEIPA_ENROLLMENT_MODE:-otp}"
  export FREEIPA_JOIN_COMMAND="${FREEIPA_JOIN_COMMAND:-ipa-client-install}"
  export FREEIPA_CLIENT_PACKAGE_MODE="${FREEIPA_CLIENT_PACKAGE_MODE:-skip}"
  export FREEIPA_CLIENT_PACKAGE="${FREEIPA_CLIENT_PACKAGE:-freeipa-client}"
  export ROLE_BUNDLE="${ROLE_BUNDLE:-}"
  export FOUNDATIONOS_DEFAULT_ROLE_BUNDLE="${FOUNDATIONOS_DEFAULT_ROLE_BUNDLE:-operations}"
}

foundationos::load_env() {
  foundationos::apply_defaults

  if [[ -f $FOUNDATIONOS_ROOT/config/foundationos/foundationos.conf ]]; then
    # shellcheck disable=SC1090
    source "$FOUNDATIONOS_ROOT/config/foundationos/foundationos.conf"
  fi

  if [[ -f $FOUNDATIONOS_CONFIG ]]; then
    # shellcheck disable=SC1090
    source "$FOUNDATIONOS_CONFIG"
  fi

  foundationos::apply_defaults

  mkdir -p \
    "$FOUNDATIONOS_CONFIG_DIR" \
    "$FOUNDATIONOS_STATE_DIR" \
    "$FOUNDATIONOS_CACHE_DIR" \
    "$FOUNDATIONOS_RUNTIME_DIR" \
    "$FOUNDATIONOS_LOG_DIR"
}

foundationos::log() {
  echo "[foundationos] $*"
}

foundationos::info() {
  echo "[foundationos][info] $*"
}

foundationos::warn() {
  echo "[foundationos][warn] $*" >&2
}

foundationos::error() {
  echo "[foundationos][error] $*" >&2
}

foundationos::die() {
  foundationos::error "$*"
  exit 1
}

foundationos::has_cmd() {
  command -v "$1" >/dev/null 2>&1
}

foundationos::browser_open() {
  local target="$1"

  if foundationos::has_cmd xdg-open; then
    xdg-open "$target" >/dev/null 2>&1 &
  else
    foundationos::warn "xdg-open is not available. Open this target manually: $target"
  fi
}

foundationos::launch_terminal() {
  local command="$1"

  if foundationos::has_cmd xdg-terminal-exec; then
    xdg-terminal-exec bash -lc "$command"
    return 0
  fi

  if foundationos::has_cmd alacritty; then
    alacritty -e bash -lc "$command"
    return 0
  fi

  if foundationos::has_cmd ghostty; then
    ghostty -e bash -lc "$command"
    return 0
  fi

  if foundationos::has_cmd kitty; then
    kitty bash -lc "$command"
    return 0
  fi

  if foundationos::has_cmd foot; then
    foot bash -lc "$command"
    return 0
  fi

  bash -lc "$command"
}

foundationos::json_escape() {
  local value="$1"

  value="${value//\\/\\\\}"
  value="${value//\"/\\\"}"
  value="${value//$'\n'/\\n}"
  value="${value//$'\r'/}"
  printf '%s' "$value"
}

foundationos::urlencode_query() {
  local raw="$1"

  if foundationos::has_cmd jq; then
    jq -nr --arg value "$raw" '$value|@uri'
    return 0
  fi

  if foundationos::has_cmd python3; then
    python3 -c 'import sys, urllib.parse; print(urllib.parse.quote(sys.argv[1]))' "$raw"
    return 0
  fi

  printf '%s' "${raw// /+}"
}

foundationos::current_user() {
  id -un 2>/dev/null || echo "unknown"
}

foundationos::current_groups() {
  id -nG 2>/dev/null || true
}

foundationos::role_bundle_from_groups() {
  local groups mapped_group bundle

  groups=" $(foundationos::current_groups) "

  if [[ -n $ROLE_BUNDLE ]]; then
    echo "$ROLE_BUNDLE"
    return 0
  fi

  if [[ -f $FOUNDATIONOS_ROLE_BUNDLE_STATE ]]; then
    # shellcheck disable=SC1090
    source "$FOUNDATIONOS_ROLE_BUNDLE_STATE"
    if [[ -n ${FOUNDATIONOS_ACTIVE_ROLE_BUNDLE:-} ]]; then
      echo "$FOUNDATIONOS_ACTIVE_ROLE_BUNDLE"
      return 0
    fi
  fi

  if [[ -f $FOUNDATIONOS_ROLE_BUNDLE_MAP ]]; then
    while IFS='=' read -r mapped_group bundle; do
      [[ -z $mapped_group || $mapped_group == \#* ]] && continue
      if [[ $groups == *" $mapped_group "* ]]; then
        echo "$bundle"
        return 0
      fi
    done < "$FOUNDATIONOS_ROLE_BUNDLE_MAP"
  fi

  echo "$FOUNDATIONOS_DEFAULT_ROLE_BUNDLE"
}

foundationos::role_bundle_path() {
  local bundle="${1:-$(foundationos::role_bundle_from_groups)}"
  echo "$FOUNDATIONOS_ROOT/default/role-bundles/$bundle.yaml"
}

foundationos::read_bundle_scalar() {
  local key="$1"
  local bundle_path="${2:-$(foundationos::role_bundle_path)}"

  awk -F': ' -v key="$key" '$1 == key { print $2; exit }' "$bundle_path"
}

foundationos::read_bundle_list() {
  local key="$1"
  local bundle_path="${2:-$(foundationos::role_bundle_path)}"

  awk -v key="$key" '
    $0 == key ":" {
      in_list = 1
      next
    }
    in_list && $0 ~ /^  - / {
      sub(/^  - /, "", $0)
      print $0
      next
    }
    in_list && $0 !~ /^  - / {
      exit
    }
  ' "$bundle_path"
}

foundationos::agent_binary_present() {
  foundationos::has_cmd "$FOUNDATION_AGENT_BINARY"
}

foundationos::agent_service_active() {
  if ! foundationos::has_cmd systemctl; then
    return 1
  fi

  systemctl --user is-active --quiet "$FOUNDATION_AGENT_SERVICE"
}

foundationos::agent_healthcheck() {
  curl --silent --show-error --fail \
    --max-time "$FOUNDATIONOS_CURL_TIMEOUT" \
    "${FOUNDATION_AGENT_API_BASE_URL%/}${FOUNDATION_AGENT_HEALTH_PATH}" \
    >/dev/null 2>&1
}

foundationos::foundation_healthcheck() {
  curl --silent --show-error --fail \
    --max-time "$FOUNDATIONOS_CURL_TIMEOUT" \
    "${FOUNDATION_API_BASE_URL%/}${FOUNDATION_HEALTH_PATH}" \
    >/dev/null 2>&1
}

foundationos::freeipa_joined() {
  if foundationos::has_cmd ipa; then
    ipa ping >/dev/null 2>&1 && return 0
  fi

  if foundationos::has_cmd realm; then
    realm list 2>/dev/null | grep -qi "^realm-name: ${FREEIPA_REALM}$" && return 0
  fi

  if foundationos::has_cmd sssctl; then
    sssctl domain-list 2>/dev/null | grep -qi "^${FREEIPA_DOMAIN}$" && return 0
  fi

  return 1
}

foundationos::deep_link_to_url() {
  local link="${1:-foundation://pulse}"
  local path remainder

  case "$link" in
    foundation://pulse|sndfoundation://pulse)
      echo "${FOUNDATION_BASE_URL%/}${FOUNDATION_PULSE_PATH}"
      ;;
    foundation://chat|sndfoundation://chat)
      echo "${FOUNDATION_BASE_URL%/}${FOUNDATION_CHAT_PATH}"
      ;;
    foundation://flows|sndfoundation://flows)
      echo "${FOUNDATION_BASE_URL%/}${FOUNDATION_FLOWS_PATH}"
      ;;
    foundation://approvals|sndfoundation://approvals)
      echo "${FOUNDATION_BASE_URL%/}${FOUNDATION_APPROVALS_PATH}"
      ;;
    foundation://entities/*|sndfoundation://entities/*)
      path="${link#*://entities/}"
      echo "${FOUNDATION_BASE_URL%/}${FOUNDATION_ENTITIES_PATH}/$path"
      ;;
    foundation://actions/*|sndfoundation://actions/*)
      remainder="${link#*://actions/}"
      echo "${FOUNDATION_BASE_URL%/}/actions/$remainder"
      ;;
    foundation://desktop/handoff/*|sndfoundation://desktop/handoff/*)
      remainder="${link#*://desktop/handoff/}"
      echo "${FOUNDATION_BASE_URL%/}/desktop/handoff/$remainder"
      ;;
    foundation://*|sndfoundation://*)
      path="${link#*://}"
      echo "${FOUNDATION_BASE_URL%/}/$path"
      ;;
    *)
      echo "$link"
      ;;
  esac
}

foundationos::search_fallback_url() {
  local query="$1"

  printf '%s%s?q=%s\n' \
    "${FOUNDATION_BASE_URL%/}" \
    "$FOUNDATION_SEARCH_FALLBACK_PATH" \
    "$(foundationos::urlencode_query "$query")"
}

foundationos::snapshot_create() {
  if foundationos::has_cmd omarchy-snapshot; then
    omarchy-snapshot create
    return 0
  fi

  if foundationos::has_cmd snapper; then
    sudo snapper create -d "FoundationOS ${FOUNDATIONOS_RELEASE_ID}"
    return 0
  fi

  foundationos::warn "No snapshot tool is available; proceeding without rollback checkpoint."
  return 127
}

foundationos::snapshot_restore() {
  if foundationos::has_cmd omarchy-snapshot; then
    omarchy-snapshot restore
    return 0
  fi

  if foundationos::has_cmd snapper; then
    foundationos::die "snapper is available, but automatic restore is not implemented. Use your cohort rollback runbook."
  fi

  foundationos::die "No snapshot restore command is available on this workstation."
}
