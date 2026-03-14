#!/bin/bash

set -eEo pipefail

foundationos_step "Staging shell integration assets"

mkdir -p \
  "$HOME/.config/environment.d" \
  "$HOME/.config/fastfetch" \
  "$HOME/.config/foundationos/walker/themes/foundationos-default" \
  "$HOME/.config/foundationos/waybar" \
  "$HOME/.config/foundationos/branding" \
  "$HOME/.config/foundationos/walker" \
  "$HOME/.config/hypr" \
  "$HOME/.config/omarchy/branding" \
  "$HOME/.config/uwsm" \
  "$HOME/.config/walker" \
  "$HOME/.config/waybar" \
  "$HOME/.local/share/applications" \
  "$HOME/.local/share/icons/hicolor/scalable/apps"

install -m 0644 \
  "$FOUNDATIONOS_PATH/config/environment.d/90-foundationos.conf" \
  "$HOME/.config/environment.d/90-foundationos.conf"
install -m 0644 \
  "$FOUNDATIONOS_PATH/config/fastfetch/config.jsonc" \
  "$HOME/.config/fastfetch/config.jsonc"
install -m 0644 \
  "$FOUNDATIONOS_PATH/config/hypr/bindings.conf" \
  "$HOME/.config/hypr/bindings.conf"
install -m 0644 \
  "$FOUNDATIONOS_PATH/config/uwsm/env" \
  "$HOME/.config/uwsm/env"
install -m 0644 \
  "$FOUNDATIONOS_PATH/config/waybar/config.jsonc" \
  "$HOME/.config/waybar/config.jsonc"
install -m 0644 \
  "$FOUNDATIONOS_PATH/config/waybar/style.css" \
  "$HOME/.config/waybar/style.css"
install -m 0644 \
  "$FOUNDATIONOS_PATH/config/walker/config.toml" \
  "$HOME/.config/walker/config.toml"
install -m 0644 \
  "$FOUNDATIONOS_PATH/config/waybar/foundation-module.jsonc" \
  "$HOME/.config/foundationos/waybar/foundation-module.jsonc"
install -m 0644 \
  "$FOUNDATIONOS_PATH/default/waybar/style.css" \
  "$HOME/.config/foundationos/waybar/style.css"
install -m 0644 \
  "$FOUNDATIONOS_PATH/config/walker/foundation-provider.toml" \
  "$HOME/.config/foundationos/walker/foundation-provider.toml"
install -m 0644 \
  "$FOUNDATIONOS_PATH/default/walker/themes/foundationos-default/style.css" \
  "$HOME/.config/foundationos/walker/themes/foundationos-default/style.css"
install -m 0644 \
  "$FOUNDATIONOS_PATH/default/walker/themes/foundationos-default/layout.xml" \
  "$HOME/.config/foundationos/walker/themes/foundationos-default/layout.xml"
install -m 0644 \
  "$FOUNDATIONOS_PATH/config/foundationos/branding/about.txt" \
  "$HOME/.config/foundationos/branding/about.txt"
install -m 0644 \
  "$FOUNDATIONOS_PATH/config/foundationos/branding/screensaver.txt" \
  "$HOME/.config/foundationos/branding/screensaver.txt"
install -m 0644 \
  "$FOUNDATIONOS_PATH/config/foundationos/branding/foundationos-mark.svg" \
  "$HOME/.config/foundationos/branding/foundationos-mark.svg"
install -m 0644 \
  "$FOUNDATIONOS_PATH/config/foundationos/branding/foundationos-wordmark.svg" \
  "$HOME/.config/foundationos/branding/foundationos-wordmark.svg"
install -m 0644 \
  "$FOUNDATIONOS_PATH/config/omarchy/branding/about.txt" \
  "$HOME/.config/omarchy/branding/about.txt"
install -m 0644 \
  "$FOUNDATIONOS_PATH/config/omarchy/branding/screensaver.txt" \
  "$HOME/.config/omarchy/branding/screensaver.txt"
install -m 0644 \
  "$FOUNDATIONOS_PATH/config/foundationos/branding/foundationos-mark.svg" \
  "$HOME/.local/share/icons/hicolor/scalable/apps/foundationos.svg"
install -m 0644 \
  "$FOUNDATIONOS_PATH/config/foundationos/branding/foundationos-mark.svg" \
  "$HOME/.local/share/icons/hicolor/scalable/apps/foundation-launcher.svg"
install -m 0644 \
  "$FOUNDATIONOS_PATH/config/foundationos/branding/foundationos-mark.svg" \
  "$HOME/.local/share/icons/hicolor/scalable/apps/foundation-chat.svg"
install -m 0644 \
  "$FOUNDATIONOS_PATH/config/foundationos/branding/foundationos-mark.svg" \
  "$HOME/.local/share/icons/hicolor/scalable/apps/foundation-pulse.svg"
install -m 0644 \
  "$FOUNDATIONOS_PATH/config/foundationos/branding/foundationos-mark.svg" \
  "$HOME/.local/share/icons/hicolor/scalable/apps/foundation-approvals.svg"
install -m 0644 \
  "$FOUNDATIONOS_PATH/config/foundationos/branding/foundationos-mark.svg" \
  "$HOME/.local/share/icons/hicolor/scalable/apps/foundation-diagnostics.svg"
install -m 0644 \
  "$FOUNDATIONOS_PATH/config/foundationos/branding/foundationos-mark.svg" \
  "$HOME/.local/share/icons/hicolor/scalable/apps/foundation-protocol-handler.svg"

cat > "$HOME/.config/foundationos/session.env" <<EOF
FOUNDATIONOS_PATH=$FOUNDATIONOS_PATH
FOUNDATIONOS_ROOT=$FOUNDATIONOS_ROOT
EOF

for desktop_file in "$FOUNDATIONOS_PATH"/applications/*.desktop; do
  install -m 0644 "$desktop_file" "$HOME/.local/share/applications/$(basename "$desktop_file")"
done

if command -v update-desktop-database >/dev/null 2>&1; then
  update-desktop-database "$HOME/.local/share/applications" >/dev/null 2>&1 || true
fi

if command -v gtk-update-icon-cache >/dev/null 2>&1; then
  gtk-update-icon-cache -f -q "$HOME/.local/share/icons/hicolor" >/dev/null 2>&1 || true
fi

if [[ -f $HOME/.config/waybar/config.jsonc ]] && ! grep -q 'custom/foundation' "$HOME/.config/waybar/config.jsonc"; then
  foundationos_warn "Waybar integration is staged at ~/.config/foundationos/waybar/foundation-module.jsonc. Merge the custom/foundation module into your main Waybar config."
fi

if [[ -f $HOME/.config/walker/config.toml ]] && ! grep -qi 'foundation' "$HOME/.config/walker/config.toml"; then
  foundationos_warn "Walker provider config is staged at ~/.config/foundationos/walker/foundation-provider.toml. Register it in your main Walker config when ready."
fi
