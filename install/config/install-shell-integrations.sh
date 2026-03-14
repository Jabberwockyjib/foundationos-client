#!/bin/bash

set -eEo pipefail

foundationos_step "Staging shell integration assets"

mkdir -p \
  "$HOME/.config/environment.d" \
  "$HOME/.config/foundationos/waybar" \
  "$HOME/.config/foundationos/walker" \
  "$HOME/.local/share/applications"

install -m 0644 \
  "$FOUNDATIONOS_PATH/config/environment.d/90-foundationos.conf" \
  "$HOME/.config/environment.d/90-foundationos.conf"
install -m 0644 \
  "$FOUNDATIONOS_PATH/config/waybar/foundation-module.jsonc" \
  "$HOME/.config/foundationos/waybar/foundation-module.jsonc"
install -m 0644 \
  "$FOUNDATIONOS_PATH/default/waybar/style.css" \
  "$HOME/.config/foundationos/waybar/style.css"
install -m 0644 \
  "$FOUNDATIONOS_PATH/config/walker/foundation-provider.toml" \
  "$HOME/.config/foundationos/walker/foundation-provider.toml"

for desktop_file in "$FOUNDATIONOS_PATH"/applications/*.desktop; do
  install -m 0644 "$desktop_file" "$HOME/.local/share/applications/$(basename "$desktop_file")"
done

if command -v update-desktop-database >/dev/null 2>&1; then
  update-desktop-database "$HOME/.local/share/applications" >/dev/null 2>&1 || true
fi

if [[ -f $HOME/.config/waybar/config.jsonc ]] && ! grep -q 'custom/foundation' "$HOME/.config/waybar/config.jsonc"; then
  foundationos_warn "Waybar integration is staged at ~/.config/foundationos/waybar/foundation-module.jsonc. Merge the custom/foundation module into your main Waybar config."
fi

if [[ -f $HOME/.config/walker/config.toml ]] && ! grep -q 'foundation' "$HOME/.config/walker/config.toml"; then
  foundationos_warn "Walker provider config is staged at ~/.config/foundationos/walker/foundation-provider.toml. Register it in your main Walker config when ready."
fi
