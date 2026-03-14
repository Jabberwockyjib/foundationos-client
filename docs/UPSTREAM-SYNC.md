# Upstream Sync

Track `basecamp/omarchy` as the upstream source for:

- install flow conventions
- shell packaging conventions
- Hyprland and launcher baseline mechanics
- migration layout

Do not merge upstream blindly.

For each upstream sync:

1. fetch upstream
2. compare `boot.sh`, `install.sh`, `bin/`, `config/`, `default/`, and `migrations/`
3. preserve fork-owned `foundationos-*` commands
4. rerun enrollment, launcher, and update validation
5. publish a short sync note in the release record
