#!/bin/bash

foundationos::ui::toggle_existing_menu() {
  if foundationos::has_cmd walker && pgrep -f "walker.*--dmenu" >/dev/null 2>&1; then
    walker --close >/dev/null 2>&1
    exit 0
  fi
}

foundationos::ui::menu() {
  local prompt="$1"
  local options="$2"
  local extra="${3:-}"
  local preselect="${4:-}"
  local index

  if [[ -n ${FOUNDATIONOS_UI_SELECTION:-} ]]; then
    printf '%s\n' "$FOUNDATIONOS_UI_SELECTION"
    return 0
  fi

  if foundationos::has_cmd omarchy-launch-walker; then
    local args=()
    read -r -a args <<<"$extra"

    if [[ -n $preselect ]]; then
      index="$(echo -e "$options" | grep -nxF "$preselect" | cut -d: -f1)"
      if [[ -n $index ]]; then
        args+=("-c" "$index")
      fi
    fi

    echo -e "$options" | omarchy-launch-walker --dmenu --width 320 --minheight 1 --maxheight 640 -p "$prompt" "${args[@]}" 2>/dev/null
    return 0
  fi

  if foundationos::has_cmd walker; then
    echo -e "$options" | walker --dmenu -p "$prompt"
    return 0
  fi

  if foundationos::has_cmd rofi; then
    echo -e "$options" | rofi -dmenu -p "$prompt"
    return 0
  fi

  if foundationos::has_cmd wofi; then
    echo -e "$options" | wofi --dmenu --prompt "$prompt"
    return 0
  fi

  foundationos::die "No supported launcher is available. Install Walker, Rofi, or Wofi."
}

foundationos::ui::open_in_editor() {
  local target="$1"

  if foundationos::has_cmd notify-send; then
    notify-send "Editing config file" "$target"
  fi

  if foundationos::has_cmd omarchy-launch-editor; then
    omarchy-launch-editor "$target"
    return 0
  fi

  if [[ -n ${EDITOR:-} ]] && foundationos::has_cmd "$EDITOR"; then
    "$EDITOR" "$target"
    return 0
  fi

  foundationos::browser_open "$target"
}

foundationos::ui::present_terminal() {
  local command="$1"
  foundationos::launch_terminal "$command"
}

foundationos::ui::present_terminal_notice() {
  local command="$1"
  foundationos::launch_terminal "$command; printf '\nPress Enter to close...'; read -r _"
}
