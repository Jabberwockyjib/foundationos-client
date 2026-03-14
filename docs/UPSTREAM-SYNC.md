# Upstream Sync

Track `basecamp/omarchy` as the upstream source for:

- install flow conventions
- shell packaging conventions
- Hyprland and launcher baseline mechanics
- migration layout

Configure the repo like this:

1. `git remote add upstream https://github.com/basecamp/omarchy.git`
2. `git fetch upstream dev`
3. keep `main` as the FoundationOS integration branch
4. land upstream sync work on short-lived sync branches

Fork-owned paths that must stay under FoundationOS control:

- `bin/foundationos-*`
- `config/foundationos/`
- `config/systemd/user/`
- `default/role-bundles/`
- `manifests/`
- `docs/`

Do not merge upstream blindly.

For each upstream sync:

1. fetch upstream
2. compare `boot.sh`, `install.sh`, `install/`, `bin/`, `config/`, `default/`, and `migrations/`
3. preserve fork-owned `foundationos-*` commands
4. rerun `foundationos-enroll --stage-only`, `foundationos-launcher`, and `foundationos-update plan`
5. publish a short sync note in the release record
