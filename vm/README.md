# VM Runbook

## Goal

Create a runnable FoundationOS test tree by overlaying this repo onto an `Omarchy` checkout, then execute the combined install path inside an Arch VM.

## Fast Path

1. boot a clean Arch VM with network access
2. clone this repo or copy `foundationos-client/` into the VM
3. run `foundationos-vm-stage --target ~/.local/share/foundationos-vm`
4. run `FOUNDATIONOS_ROOT=~/.local/share/foundationos-vm FOUNDATIONOS_PATH=~/.local/share/foundationos-vm bash ~/.local/share/foundationos-vm/install.sh`
5. validate with `foundationos-status`, `foundationos-update plan`, and `foundationos-enroll --stage-only`

## Why This Works

- `foundationos-vm-stage` clones `basecamp/omarchy`
- it preserves the original stage runners as `install/*/upstream.sh`
- it overlays the FoundationOS fork-owned files on top
- the FoundationOS `install/*/all.sh` runners call the preserved upstream stage first, then FoundationOS extensions

## Remaining External Blockers

- real `FreeIPA` enrollment credentials or OTP flow
- published desktop-agent package and API contract
- final branded theme and launcher merge into the live user config
