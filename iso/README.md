# FoundationOS ISO

## Scope

This directory contains the `FoundationOS` ISO build pipeline.

It currently builds live images, not the final direct installer.

## Profiles

- `production`: the publishable live ISO target
- `bootstrap`: the lighter debugging and validation image

Both profiles use `archiso` and include:

- the `FoundationOS` client repo under `/opt/foundationos-client`
- helper packages such as `git`, `rsync`, `jq`, and `curl`
- convenience commands such as `foundationos-live-stage` and `foundationos-live-release`

## Current Result

The production live ISO is useful for:

- carrying the repo and runbooks onto hardware
- validating a publishable `FoundationOS` live boot artifact
- staging a combined upstream desktop base plus `FoundationOS` tree for debugging
- proving release artifacts such as metadata and checksums

It is still not the direct installer ISO.

## Why The ISO Is Still Live-Only

`FoundationOS Client` is still an `Omarchy`-based fork. The current product strategy is:

1. use upstream `Omarchy` as the OS baseline
2. overlay `FoundationOS` on top
3. add identity, agent, and shell integration through fork-owned commands

That means:

- the real hardware install path today is still documented in `docs/HARDWARE-INSTALL.md`
- the production live ISO is the releaseable validation image
- the direct installer ISO is still a separate next step

## Docker Build Path

The default target is now the `production` profile.

The easiest reproducible build path is a privileged container that runs `mkarchiso`.

Run:

```bash
./iso/build-iso.sh --profile production
```

Optional environment variables:

```bash
FOUNDATIONOS_DOCKER_ENGINE=docker
FOUNDATIONOS_DOCKER_PLATFORM=linux/amd64
FOUNDATIONOS_ISO_OUTPUT=/absolute/path/to/output
FOUNDATIONOS_ISO_NAME=foundationos-production-live
FOUNDATIONOS_RELEASE_ID=foundationos-client-live-dev
FOUNDATIONOS_CHANNEL=pilot
FOUNDATIONOS_SITE_REF=production
```

## Output

By default the ISO lands under:

```text
out/iso/
```

The build also emits:

- `<iso>.sha256`
- `<iso>.json`

## Host Requirements

- `docker` or `podman`
- privileged containers
- enough disk space for an `archiso` work directory

On Apple Silicon, keep the default `FOUNDATIONOS_DOCKER_PLATFORM=linux/amd64`. The current `Omarchy`-compatible target remains `x86_64`.

## Live ISO Command

After booting the generated image, run:

```bash
foundationos-live-release
foundationos-live-stage
```

That stages an upstream desktop base plus `FoundationOS` under:

```text
/root/foundationos-staging
```

See also:

- `docs/ISO-RELEASE.md`
- `manifests/images/production-live.yaml`

The direct installer ISO is still a later track.
