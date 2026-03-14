# FoundationOS Hardware Install

## Purpose

This runbook installs `FoundationOS` onto a real workstation by:

1. installing upstream `Omarchy` on the machine
2. overlaying the `FoundationOS` fork-owned files on top of that baseline
3. validating the branded shell, launchers, and enrollment scaffolding

This is the supported hardware path today. It matches the current fork strategy better than trying to turn this repo into a full standalone distro first.

## Current Truth

- `FoundationOS Client` is still an `Omarchy`-based fork, not a greenfield distro
- the fastest reliable hardware path is the official `Omarchy` ISO plus the `FoundationOS` overlay
- `FreeIPA` join and desktop-agent registration are still externally blocked unless you have the real package artifacts and credentials
- the visible `FoundationOS` rebrand is already present in the overlay

## Assumptions

- target hardware is `x86_64`
- the machine can reach the internet after first boot
- you are installing onto a dedicated disk
- you have a GitHub connection or another way to get this repo onto the machine
- you are running the overlay as your normal desktop user, not `root`

## Inputs You Need

- the official `Omarchy` ISO from `https://omarchy.org/`
- a bootable USB installer
- the public client repo:
  - `https://github.com/Jabberwockyjib/foundationos-client`
- optional real environment values for:
  - `FOUNDATION_BASE_URL`
  - `FOUNDATION_API_BASE_URL`
  - `FREEIPA_SERVER`
  - `FREEIPA_DOMAIN`
  - `FREEIPA_REALM`
  - `FOUNDATION_AGENT_PACKAGE_MODE`
  - `FREEIPA_CLIENT_PACKAGE_MODE`

## Step 1: Install Omarchy

1. write the official `Omarchy` ISO to a USB drive
2. boot the target workstation from that USB drive
3. complete the standard `Omarchy` installation flow onto the target disk
4. reboot into the installed `Omarchy` system
5. connect the machine to the network

Do not try to patch the live installer image directly during this phase. Get the upstream desktop working first.

## Step 2: Install FoundationOS Overlay Prerequisites

Open a terminal in the installed `Omarchy` session and run:

```bash
sudo pacman -Syu --noconfirm --needed git rsync jq curl base-devel
```

If `NetworkManager` is present but not active, run:

```bash
sudo systemctl enable --now NetworkManager
```

## Step 3: Clone The FoundationOS Client Repo

```bash
git clone https://github.com/Jabberwockyjib/foundationos-client ~/foundationos-client
cd ~/foundationos-client
```

If you need a non-default branch:

```bash
git checkout <branch-name>
```

## Step 4: Stage A Combined Omarchy + FoundationOS Tree

The preferred target path on real hardware is `~/.local/share/foundationos`.

If the installed `Omarchy` checkout exists at `~/.local/share/omarchy`, run:

```bash
./bin/foundationos-vm-stage \
  --from-local ~/.local/share/omarchy \
  --target ~/.local/share/foundationos
```

If that local checkout is not present, let the staging command clone upstream itself:

```bash
./bin/foundationos-vm-stage --target ~/.local/share/foundationos
```

That command:

- clones or refreshes the upstream `Omarchy` tree
- preserves upstream stage runners as `install/*/upstream.sh`
- overlays the `FoundationOS` repo files on top
- writes `.foundationos-overlay` metadata into the staged tree

## Step 5: Review Environment Configuration

Before the first install, review the staged config:

```bash
sed -n '1,220p' ~/.local/share/foundationos/config/foundationos/foundationos.conf
```

If you already know your real Foundation or `FreeIPA` values, edit that file now.

If you do not know them yet, proceed with the defaults. The install will copy the config to:

```text
~/.config/foundationos/foundationos.conf
```

and keep that user config on later reruns.

## Step 6: Run The Combined Install

```bash
FOUNDATIONOS_ROOT=~/.local/share/foundationos \
FOUNDATIONOS_PATH=~/.local/share/foundationos \
bash ~/.local/share/foundationos/install.sh
```

This runs the preserved upstream `Omarchy` install stages first, then the `FoundationOS` fork-owned extensions.

## Step 7: Verify The Overlay

Run:

```bash
foundationos-status
foundationos-update plan
foundationos-enroll --stage-only
fastfetch
```

Expected results:

- `fastfetch` shows `FoundationOS`
- `foundationos-status` prints the active config and role-bundle information
- `foundationos-update plan` returns scaffolded update information
- `foundationos-enroll --stage-only` completes without attempting a real enrollment

Visible operator-facing checks:

- the shell branding reads `FoundationOS`
- the left `Waybar` module shows the `FoundationOS` menu label
- the fastfetch/about text shows `FoundationOS`
- the `FoundationOS` desktop entries exist in the launcher

## Step 8: Set Real Config Values

After install, edit:

```text
~/.config/foundationos/foundationos.conf
```

At minimum, set the real Foundation endpoints before expecting open/search flows to work:

```bash
FOUNDATION_BASE_URL=https://foundation.example.com
FOUNDATION_API_BASE_URL=https://foundation.example.com
```

When the real packaging paths exist, also set values such as:

```bash
FOUNDATION_AGENT_PACKAGE_MODE=artifact
FREEIPA_CLIENT_PACKAGE_MODE=pacman
FREEIPA_SERVER=ipa.example.internal
FREEIPA_DOMAIN=example.internal
FREEIPA_REALM=EXAMPLE.INTERNAL
```

Then reload your shell or log in again before re-running the client commands.

## Step 9: Optional Real Enrollment

Only do this when the external dependencies actually exist.

### Desktop Agent

The repo already stages:

- the `foundationos-install-agent` command
- the user service `foundation-desktop-agent.service`
- the local agent endpoint contract expected by the shell

What is still needed outside this repo:

- a published desktop-agent artifact or package
- the real Foundation registration flow
- the agent local HTTP implementation for `/health`, `/search`, and `/open`

### FreeIPA

The repo already stages:

- `foundationos-join-freeipa`
- `foundationos-enroll`
- `FreeIPA` config defaults and role-bundle mapping

What is still needed outside this repo:

- a real `FreeIPA` client package path for this workstation
- a reachable `FreeIPA` server
- host enrollment credentials or OTP flow

When those are ready, run:

```bash
foundationos-enroll
```

## Rerun And Update Workflow

To pull the latest client changes onto the workstation:

```bash
cd ~/foundationos-client
git pull --ff-only
./bin/foundationos-vm-stage \
  --from-local ~/.local/share/omarchy \
  --target ~/.local/share/foundationos
FOUNDATIONOS_ROOT=~/.local/share/foundationos \
FOUNDATIONOS_PATH=~/.local/share/foundationos \
bash ~/.local/share/foundationos/install.sh
```

If `~/.local/share/omarchy` is unavailable, drop the `--from-local` flag and let the staging command refresh from the configured upstream remote.

## Recovery Notes

- the user config file at `~/.config/foundationos/foundationos.conf` is preserved on reruns
- the staging tree at `~/.local/share/foundationos` can be deleted and recreated safely
- the current repo does not yet ship a signed recovery or rollback image
- `foundationos-rollback` exists as command scaffolding, not a full recovery environment

## When To Stop

Stop after the verification step if any of the following are still missing:

- the real Foundation endpoints
- the real desktop-agent package
- the real `FreeIPA` package path
- the real enrollment credentials

At that point, the workstation is still a valid `FoundationOS` shell and branding test box, but not a fully managed client.
