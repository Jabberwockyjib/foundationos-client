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
- `docs/` execution docs for the client team
- `migrations/` upgrade-safe workstation changes
- `themes/` branded theme data

## First Tasks For The Client Team

1. create the real fork repo and copy this skeleton into it
2. wire the upstream sync policy in `docs/UPSTREAM-SYNC.md`
3. implement the `FreeIPA` join path
4. package the Foundation desktop agent
5. implement the first `Waybar` and launcher integrations
6. publish the first image manifest and release record

## Required External Inputs

- Foundation base URL and API URL
- FreeIPA domain, realm, and enrollment posture
- desktop-agent packaging artifact
- role-bundle policy
- release signing and update-channel policy

## Non-Goals

- replacing Foundation web UI
- direct ERP writes from shell code
- unmanaged fleet support
- broad hardware support before pilot validation
