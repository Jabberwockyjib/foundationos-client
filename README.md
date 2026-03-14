# FoundationOS Client

`FoundationOS Client` is the separate client-OS repo skeleton for the desktop team.

It is intended to become an `Omarchy`-based fork that delivers the `FoundryOS` / `FoundationOS` desktop layer for `2ndFOUNDATION`.

## Purpose

This repo skeleton gives the client team:

- an Omarchy-compatible repo shape
- a bootstrap and install entrypoint
- fork-owned command namespaces
- desktop integration placeholders for Foundation
- role-bundle manifests
- execution docs for upstream sync, releases, and integration

It is a starting structure, not a complete desktop product.

## Design Rules

- use `Omarchy` as the upstream shell and install baseline
- keep `Foundation` as the source of truth for business data and governed actions
- keep `FreeIPA` as the source of truth for workstation identity
- route shell integrations through the desktop agent and Foundation APIs
- do not create a second business logic stack in shell code

## Layout

- `boot.sh` bootstrap clone/install path modeled after Omarchy
- `install.sh` modular install entrypoint
- `bin/` fork-owned desktop commands
- `config/` fork-owned config overlays
- `default/role-bundles/` role manifests
- `install/` preflight, config, login, and post-install modules
- `manifests/` image, update, and packaging manifests
- `docs/` execution docs for the client team
- `migrations/` upgrade-safe workstation changes
- `themes/` branded theme data

## Implemented Scaffolding

- shared runtime library in `lib/foundationos.sh`
- executable enrollment, agent, update, rollback, and diagnostics commands in `bin/`
- package manifests and install phases aligned with Omarchy's `install/packaging/` shape
- role-bundle mapping and richer bundle manifests tied to `FreeIPA` groups
- staged `Waybar`, launcher, protocol-handler, and desktop-agent service assets
- draft image, update, and desktop-agent manifests with explicit blockers

## First Tasks For The Client Team

1. configure the upstream Omarchy remote and run `foundationos-upstream-status`
2. publish the desktop-agent package artifact and set `FOUNDATION_AGENT_PACKAGE_MODE`
3. publish the `FreeIPA` client package source and enrollment credential flow
4. merge the staged `Waybar` and launcher assets into the active Omarchy configs
5. validate `foundationos-enroll` on a real pilot workstation
6. publish the first signed image and update manifests

## Required External Inputs

- Foundation base URL and API URL
- FreeIPA domain, realm, and enrollment posture
- desktop-agent packaging artifact
- role-bundle policy
- release signing and update-channel policy

## Backend Contract Of Record

The current server-side surface for this client track is documented in:

- `/Users/brian/dev/sndfoundation/docs/handoff/foundationos-backend-surface.md`

Use that document as the backend contract until the client fork is split into its own repository.

## Non-Goals

- replacing Foundation web UI
- direct ERP writes from shell code
- unmanaged fleet support
- broad hardware support before pilot validation
