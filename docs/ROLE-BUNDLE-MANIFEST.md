# Role-Bundle Manifest

## Canonical Files

- bundle manifests live in `default/role-bundles/*.yaml`
- FreeIPA-to-bundle mapping lives in `default/role-bundle-map.conf`
- required fields live in `manifests/role-bundle-schema.yaml`

## Required Fields

- `bundle_id`
- `display_name`
- `freeipa_group`
- `foundation_role`
- `erp_bundle`
- `desktop_bundle`
- `foundation_shortcuts`
- `launcher_entries`
- `waybar_modules`
- `workspaces`
- `apps`

## Rules

- the `freeipa_group` field ties the bundle to the central identity contract
- the `foundation_role` and `erp_bundle` fields document central mappings but do not grant those permissions locally
- launcher and workspace differences only shape the shell and default tools
- every bundle must remain safe to apply even when Foundation or the desktop agent is offline
