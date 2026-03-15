# Omarchy Fork Research

## Why this document exists

The current FoundationOS client prototype has been trying to preserve Omarchy's install chain and layer FoundationOS behavior into it. That approach has produced repeated install-stage failures. This document captures what the public Omarchy ecosystem is actually doing, what the upstream project appears to support, and what that means for FoundationOS.

## Immediate finding from our current code

Our current failure at `foundation-base.sh` is not just another random packaging miss.

- [foundation-base.sh](/Users/brian/dev/sndfoundation/foundationos-client/install/packaging/foundation-base.sh) runs `sudo pacman -S ...`
- Omarchy's upstream `run_logged` helper executes install stage scripts with stdin redirected from `/dev/null`
- That means any FoundationOS stage that needs an interactive `sudo` prompt is structurally incompatible with the preserved Omarchy install runner

Inference: the wrapper-heavy approach is brittle because it inherits upstream logging, traps, sudo assumptions, and user-space config behavior, then adds a second opinionated layer on top.

## Public references

### 1. Official Omarchy ISO is the supported fork point

The official Omarchy ISO repo explicitly supports pointing the ISO builder at an alternate installer repository and ref:

- [omacom-io/omarchy-iso README](https://github.com/omacom-io/omarchy-iso/blob/main/README.md)
- [omacom-io/omarchy-iso builder/build-iso.sh](https://github.com/omacom-io/omarchy-iso/blob/main/builder/build-iso.sh)

What matters:

- The ISO is built from an Arch `releng` profile
- The build copies Omarchy into the ISO rootfs
- The builder supports `OMARCHY_INSTALLER_REPO` and `OMARCHY_INSTALLER_REF`

That is a strong signal that the intended customization point is "build your own ISO with your own installer repo", not "wrap every Omarchy install stage after the fact".

### 2. Omarchy users asking how to make their own distro are pointed at the ISO builder

In the Omarchy issue about making a custom ISO, the most concrete answer points people to the Omarchy ISO builder environment variables:

- [basecamp/omarchy issue #1367](https://github.com/basecamp/omarchy/issues/1367)
- Relevant comment: [change `OMARCHY_INSTALLER_REPO` to your fork](https://github.com/basecamp/omarchy/issues/1367#issuecomment-3287399018)

That is the closest public evidence of "someone else doing this before" in Omarchy-land.

### 3. The main public "install Omarchy on another distro" example uses a separate adaptation script, not wrapper replacement

The most relevant public example is:

- [mroboff/omarchy-on-cachyos](https://github.com/mroboff/omarchy-on-cachyos)
- [README](https://github.com/mroboff/omarchy-on-cachyos/blob/main/README.md)
- [install-omarchy-on-cachyos.sh](https://github.com/mroboff/omarchy-on-cachyos/blob/main/bin/install-omarchy-on-cachyos.sh)

What it does:

- clones Omarchy
- patches specific Omarchy scripts in place
- launches Omarchy's installer on top of an already-installed CachyOS base

What it does not do:

- replace Omarchy's helper stack
- preserve Omarchy stage runners and then add a second install framework around them

This is important because it shows the public working precedent for "Omarchy plus another base" is targeted patching, not deep wrapper indirection.

### 4. The standard Arch path for a custom distro is an `archiso` profile plus overlays

Official Archiso documentation:

- [archlinux/archiso README](https://github.com/archlinux/archiso/blob/master/README.rst)
- [archlinux/archiso profile documentation](https://github.com/archlinux/archiso/blob/master/docs/README.profile.rst)

Relevant points:

- Archiso expects a profile with `packages.arch`, `pacman.conf`, `profiledef.sh`, and `airootfs/`
- `airootfs/` is the standard overlay mechanism for files baked into the live image
- `releng` is the standard starting point for a custom installer ISO

This matches what Omarchy itself is doing in `omarchy-iso`.

### 5. Upstream Omarchy is intentionally still user-space driven

The Omarchy maintainers have explicitly pushed back on moving all defaults and customizations into distro-style packaging:

- [basecamp/omarchy issue #1331](https://github.com/basecamp/omarchy/issues/1331)

Key takeaway from that discussion:

- Omarchy intentionally writes and manages files in the user's home directory
- maintainers value keeping user-facing config directly editable in `~/.config`
- upstream is not strongly aligned with a "package everything as immutable distro defaults" model

For FoundationOS, this means a production-quality managed desktop will always carry tension if it tries to stay perfectly aligned with upstream install/update behavior.

## What this means for FoundationOS

### The current model is the wrong primary path

Our current model is:

1. clone or stage Omarchy
2. preserve Omarchy install stage runners
3. overlay FoundationOS files
4. run a mixed installer that tries to honor both systems

That is not how the public Omarchy examples are succeeding.

The public patterns are:

1. custom ISO builder pointing to a forked installer
2. adaptation script that patches Omarchy in place on a known base distro

The current FoundationOS wrapper model is effectively a third path, and it is paying the complexity tax that comes with inventing a new integration pattern.

### Highest-confidence path forward

FoundationOS should pivot to this structure:

1. Treat the installable artifact as the product.
2. Use an ISO builder as the primary integration point.
3. Keep FoundationOS-specific packaging out of the upstream Omarchy logged stage runner where possible.
4. Use targeted patches against Omarchy install/update behavior where needed, not replacement helper stacks.

## Recommended implementation strategy

### Track A: Production path

Make the FoundationOS installer ISO the primary deliverable.

- Base it on Arch `releng`, the same way `omarchy-iso` does
- Point the ISO at a FoundationOS-owned installer repo/ref
- Bake FoundationOS packages, config, branding, and first-boot services into the image
- Keep Omarchy as upstream source material, not as the live orchestrator of FoundationOS-specific install logic

This aligns with both the Omarchy ISO design and standard `archiso` practice.

### Track B: Transitional path

Keep the current overlay installer only as a developer bootstrap path.

- It can remain useful for rapid shell/UI iteration on an existing Omarchy machine
- It should not be treated as the production install model
- It should not grow more FoundationOS-specific package/install responsibility

## Concrete changes implied by this research

### 1. Stop adding interactive `sudo` work inside preserved Omarchy stage runners

Examples:

- [foundation-base.sh](/Users/brian/dev/sndfoundation/foundationos-client/install/packaging/foundation-base.sh)
- [desktop-agent.sh](/Users/brian/dev/sndfoundation/foundationos-client/install/packaging/desktop-agent.sh)
- [freeipa-client.sh](/Users/brian/dev/sndfoundation/foundationos-client/install/packaging/freeipa-client.sh)

If a FoundationOS step needs root, it should happen in one of these places instead:

- inside the ISO image build
- inside a first-boot system service
- inside a dedicated installer script that owns elevation and logging

### 2. Prefer targeted upstream patching over wrapper replacement

If we must support "install on top of Omarchy", the stable pattern is closer to `omarchy-on-cachyos`:

- clone upstream
- patch exact lines or scripts with a small patch set
- run upstream flow

That is lower risk than keeping a parallel install framework that shadows upstream helper behavior.

### 3. Make FoundationOS package/repo strategy real before pushing deeper install logic

Omarchy itself has already moved toward an Omarchy package repository:

- [basecamp/omarchy issue #767](https://github.com/basecamp/omarchy/issues/767)
- Omarchy package repo config in [default/pacman/pacman-stable.conf](https://github.com/basecamp/omarchy/blob/dev/default/pacman/pacman-stable.conf)

FoundationOS should follow the same pattern for Foundation-owned components:

- desktop-agent package
- role-bundle assets
- FoundationOS shell/config package
- any FreeIPA packaging support

Without this, the installer will continue to be a pile of ad hoc shell steps.

## Recommendation

Recommendation: stop treating the mixed overlay installer as the primary delivery path.

Do this next:

1. Reframe the current overlay installer as dev-only.
2. Build a FoundationOS installer repo and have the ISO builder point at it directly.
3. Move FoundationOS-owned packages and install-time assets into image/packaging/first-boot flow.
4. Keep Omarchy-specific compatibility to narrow, explicit patches.

## Bottom line

I did not find a public example of a successful Omarchy derivative that works by preserving Omarchy's full install chain and layering a second install framework around it.

I did find:

- official Omarchy support for swapping the installer repo in the ISO builder
- public examples of targeted Omarchy patching on another distro
- standard Arch guidance pointing toward `archiso` profiles and baked overlays

Inference: FoundationOS should pivot from "wrapper-heavy overlay installer" to "FoundationOS-owned installer ISO plus targeted Omarchy compatibility patches".
