# Release Model

## Channels

- `internal`
- `pilot`
- `stable`

## Required Release Artifacts

- image manifest
- update manifest
- rollback note
- known issues
- hardware cohort
- approver record

## Release Rule

Do not ship a desktop image that has not proven:

- login
- desktop-agent startup
- Foundation deep links
- notification routing
- role-bundle activation
- rollback path
