# Integration Points

## Backend

- Foundation web shell
- Foundation API
- Foundation desktop handoff
- Foundation search and notification surfaces
- Foundation approval queue
- browser fallback through `foundationos-open-link`

## Identity

- FreeIPA realm
- SSSD workstation join
- role-bundle resolution derived from central groups

## Desktop

- desktop-agent package
- Waybar module
- Walker/Rofi/Wofi search provider
- deep-link handler
- update and rollback commands

## Repo-Owned Surfaces

- `bin/foundationos-waybar`
- `bin/foundationos-launcher`
- `bin/foundationos-search`
- `config/systemd/user/foundation-desktop-agent.service`
- `config/waybar/foundation-module.jsonc`
- `config/walker/foundation-provider.toml`
- `default/role-bundles/*.yaml`
- `manifests/images/internal-pilot.yaml`
- `manifests/updates/internal.yaml`
