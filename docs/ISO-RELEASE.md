# ISO Release

## Scope

The current ISO track has two separate targets:

1. `production` live ISO
2. future direct installer ISO

This document covers the production live ISO only.

## What The Production Live ISO Is

The production live ISO is the publishable hardware-validation image for `FoundationOS Client`.

It is intended to:

- boot cleanly on `x86_64` hardware
- carry the full `FoundationOS` client repo inside the image
- expose branded live-environment commands
- emit checksum and metadata artifacts at build time
- stage an upstream desktop base plus the `FoundationOS` overlay on demand

It is not yet the direct disk installer.

## Build Command

From the repo root:

```bash
cd foundationos-client
./iso/build-iso.sh --profile production
```

Optional overrides:

```bash
FOUNDATIONOS_DOCKER_ENGINE=docker
FOUNDATIONOS_DOCKER_PLATFORM=linux/amd64
FOUNDATIONOS_ISO_OUTPUT=/absolute/path/to/output
FOUNDATIONOS_ISO_NAME=foundationos-production-live
FOUNDATIONOS_RELEASE_ID=foundationos-client-live-dev
FOUNDATIONOS_CHANNEL=pilot
FOUNDATIONOS_SITE_REF=production
./iso/build-iso.sh --profile production
```

## Build Outputs

The build writes artifacts to `out/iso/` by default:

- the `.iso`
- `<iso>.sha256`
- `<iso>.json`

The JSON metadata includes:

- build profile
- release id
- channel
- site ref
- build timestamp
- source revision

## What Boots Inside The ISO

The live environment embeds:

- the client repo at `/opt/foundationos-client`
- release metadata at `/etc/foundationos-release.env`
- live config seed at `/etc/foundationos-live.conf`
- global shell environment from `/etc/profile.d/foundationos-live.sh`

The live commands are:

- `foundationos-live-release`
- `foundationos-live-stage`
- `foundationos-live-prepare`

The live-prepare service also:

- creates `foundationos-client` symlinks in detected user homes
- seeds `~/.config/foundationos/foundationos.conf` if it is missing
- writes live release metadata into the user config directory

## Minimum Release Gate

Do not call the production live ISO ready unless it proves:

- boot to shell or session on target `x86_64` hardware
- `foundationos-live-release` prints correct release metadata
- `foundationos-live-stage` produces a runnable staging tree
- embedded repo contents match the intended source revision
- checksum and metadata artifacts are produced during build

## Known Gaps

The production live ISO is still blocked from being the final deploy image by:

- missing direct installer workflow
- missing signed desktop-agent artifact
- missing real `FreeIPA` package and enrollment flow

Those are the next tracks after the live ISO is stable.
