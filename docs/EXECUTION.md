# Execution

## Current Execution Path

1. configure `upstream` to `https://github.com/basecamp/omarchy.git`
2. run `foundationos-upstream-status --fetch`
3. review `config/foundationos/foundationos.conf`
4. run `foundationos-enroll --stage-only`
5. merge the staged `Waybar` and launcher assets into the active Omarchy user config
6. publish the desktop-agent artifact and the `FreeIPA` enrollment secret flow
7. validate `foundationos-update plan` and `foundationos-rollback`
8. cut the first image manifest from `manifests/images/internal-pilot.yaml`
9. for VM proving, run `foundationos-vm-stage --target ~/.local/share/foundationos-vm`

## Required Outputs

- upstream sync policy
- image manifest
- enrollment runbook
- role-bundle manifest format
- update and rollback runbook
- diagnostics command set

## Backend Dependency

Build the client-side enrollment, status, diagnostics, and task surfaces against:

- `/Users/brian/dev/sndfoundation/docs/handoff/foundationos-backend-surface.md`
