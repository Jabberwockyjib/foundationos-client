#!/bin/bash

set -eEo pipefail

foundationos_step "Installing FoundationOS visual theme"

theme_name="foundationos-default"
theme_dir="$HOME/.config/omarchy/themes/$theme_name"
background_dir="$theme_dir/backgrounds"

generate_foundation_grid_background() {
  local output_path="$1"
  local width=320
  local height=180
  local x y r g b band glow

  {
    printf 'P3\n'
    printf '# FoundationOS generated background 1\n'
    printf '%d %d\n' "$width" "$height"
    printf '255\n'

    for ((y = 0; y < height; y++)); do
      for ((x = 0; x < width; x++)); do
        r=$((16 + (x * 18 / width) + (y * 6 / height)))
        g=$((18 + (x * 26 / width) + (y * 14 / height)))
        b=$((22 + (x * 10 / width) + (y * 20 / height)))
        band=$(( (x + y * 2) % 47 ))
        glow=$(( (x * 3 + y) % 71 ))

        if (( band < 2 )); then
          r=$((r + 36))
          g=$((g + 42))
          b=$((b + 20))
        fi

        if (( glow == 0 || glow == 1 )); then
          r=$((r + 18))
          g=$((g + 28))
          b=$((b + 10))
        fi

        (( r > 255 )) && r=255
        (( g > 255 )) && g=255
        (( b > 255 )) && b=255

        printf '%d %d %d\n' "$r" "$g" "$b"
      done
    done
  } > "$output_path"
}

generate_foundation_blocks_background() {
  local output_path="$1"
  local width=320
  local height=180
  local x y r g b horizon

  {
    printf 'P3\n'
    printf '# FoundationOS generated background 2\n'
    printf '%d %d\n' "$width" "$height"
    printf '255\n'

    for ((y = 0; y < height; y++)); do
      for ((x = 0; x < width; x++)); do
        r=$((14 + (y * 20 / height)))
        g=$((18 + (y * 24 / height)))
        b=$((22 + (x * 14 / width) + (y * 16 / height)))
        horizon=$(( height * 62 / 100 ))

        if (( y > horizon )); then
          r=$((r + 10))
          g=$((g + 14))
          b=$((b + 8))
        fi

        if (( x > width / 6 && x < width * 5 / 6 && y > height / 3 && y < height * 8 / 10 )); then
          if (( x > width / 4 && x < width * 3 / 4 && y > height / 2 )); then
            r=$((r + 22))
            g=$((g + 28))
            b=$((b + 14))
          fi

          if (( x > width / 3 && x < width * 2 / 3 && y > height * 3 / 5 )); then
            r=$((r + 18))
            g=$((g + 22))
            b=$((b + 12))
          fi
        fi

        if (( (x + y) % 53 == 0 )); then
          r=$((r + 14))
          g=$((g + 18))
          b=$((b + 9))
        fi

        (( r > 255 )) && r=255
        (( g > 255 )) && g=255
        (( b > 255 )) && b=255

        printf '%d %d %d\n' "$r" "$g" "$b"
      done
    done
  } > "$output_path"
}

mkdir -p "$background_dir"

install -m 0644 \
  "$FOUNDATIONOS_PATH/themes/foundationos-default/colors.toml" \
  "$theme_dir/colors.toml"
install -m 0644 \
  "$FOUNDATIONOS_PATH/themes/foundationos-default/icons.theme" \
  "$theme_dir/icons.theme"

generate_foundation_grid_background "$background_dir/1-foundation-grid.ppm"
generate_foundation_blocks_background "$background_dir/2-foundation-steps.ppm"

if command -v omarchy-theme-set >/dev/null 2>&1; then
  if ! "$FOUNDATIONOS_PATH/bin/foundationos-apply-visual-theme" "$theme_name"; then
    foundationos_warn "FoundationOS theme assets were installed, but automatic theme activation failed."
  fi
else
  foundationos_warn "omarchy-theme-set is not available. Visual theme assets were staged only."
fi

foundationos_step "FoundationOS visual theme ready"
