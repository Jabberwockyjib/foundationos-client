# FoundationOS Client Instructions

## Purpose

This repo builds the client desktop layer as an `Omarchy`-based fork for `2ndFOUNDATION`.

## Core Rules

- preserve the upstream Omarchy repo shape where practical
- prefer extending with `foundationos-*` commands instead of mutating unrelated upstream command behavior
- keep shell code thin and declarative
- route business interactions through the Foundation desktop agent and Foundation APIs
- never introduce direct governed business writes from shell code

## Style

- use `#!/bin/bash`
- use `set -eEo pipefail`
- use `[[ ]]` for string and file tests
- use `(( ))` for numeric tests
- use two spaces for indentation in shell conditionals and loops

## Command Naming

- `foundationos-*` = fork-owned commands
- keep `omarchy-*` intact where the upstream helper already solves the OS behavior cleanly

## Required Boundaries

- `FreeIPA` remains the workstation identity authority
- Foundation remains the business authority
- the desktop agent remains the native bridge
- launcher search must not become a second business-search source of truth

## Expected Deliverables

- reproducible image build path
- role-bundle manifests
- shell integration contract compliance
- enrollment and rollback runbooks
