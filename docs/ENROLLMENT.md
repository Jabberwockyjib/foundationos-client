# Enrollment

## Commands

- `foundationos-enroll --stage-only` renders the full local execution path without credentials
- `foundationos-join-freeipa --dry-run` prints the `ipa-client-install` command that would run
- `foundationos-install-agent --stage-only` stages the user service and agent env file
- `foundationos-apply-role-bundle <bundle>` writes the active desktop bundle state

## Sequence

1. install package prerequisites from `install/foundationos-base.packages`
2. stage shell and desktop-agent assets through `install.sh`
3. join `FreeIPA` with OTP or privileged enrollment credentials
4. start the desktop-agent service
5. apply the resolved role bundle
6. validate with `foundationos-diagnostics --summary`

## Current Blockers

- a validated `FreeIPA` client package source for the target Arch image
- a real enrollment secret or OTP issuance flow
- a signed desktop-agent package and published local API contract
