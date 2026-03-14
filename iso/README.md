# FoundationOS Bootstrap ISO

## Scope

This directory contains a bootstrap ISO build scaffold, not a finished distro pipeline.

It uses `archiso` to build a live image that includes:

- the `FoundationOS` client repo under `/opt/foundationos-client`
- helper packages such as `git`, `rsync`, `jq`, and `curl`
- a convenience command named `foundationos-live-stage`

The result is useful for:

- carrying the repo and runbooks onto hardware
- validating that the shell-side scripts run in a clean live environment
- staging a combined `Omarchy` + `FoundationOS` tree for debugging
- future work toward a real branded installer image

It is not yet a replacement for the official `Omarchy` hardware install flow.

## Why The ISO Is Still Bootstrap-Only

`FoundationOS Client` is still an `Omarchy`-based fork. The current product strategy is:

1. use upstream `Omarchy` as the OS baseline
2. overlay `FoundationOS` on top
3. add identity, agent, and shell integration through fork-owned commands

That means the real hardware install path today is still documented in:

- `docs/HARDWARE-INSTALL.md`

## Docker Build Path

The easiest reproducible build path is a privileged container that runs `mkarchiso`.

Run:

```bash
./iso/build-iso.sh
```

Optional environment variables:

```bash
FOUNDATIONOS_DOCKER_ENGINE=docker
FOUNDATIONOS_DOCKER_PLATFORM=linux/amd64
FOUNDATIONOS_ISO_OUTPUT=/absolute/path/to/output
FOUNDATIONOS_ISO_NAME=foundationos-bootstrap
```

## Output

By default the ISO lands under:

```text
out/iso/
```

## Host Requirements

- `docker` or `podman`
- privileged containers
- enough disk space for an `archiso` work directory

On Apple Silicon, keep the default `FOUNDATIONOS_DOCKER_PLATFORM=linux/amd64`. The current `Omarchy`-compatible target remains `x86_64`.

## Live ISO Command

After booting the generated image, run:

```bash
foundationos-live-stage
```

That stages an `Omarchy` + `FoundationOS` tree under:

```text
/root/foundationos-staging
```

This is a debugging and validation aid. It does not yet perform a full disk install.
