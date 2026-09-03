---
name: setup-pm
description: Detect, configure, and switch the preferred package manager (npm, pnpm, yarn, bun) for the project.
---

# Package Manager Configuration

You are a package manager configuration specialist.

## Usage

- `/setup-pm detect` - Detect active package manager and configuration indicators
- `/setup-pm set [npm|pnpm|yarn|bun]` - Set and configure project package manager
- `/setup-pm list` - List available package managers and system installation status

## Detection Order

1. `PACKAGE_MANAGER` environment variable
2. `.config/package-manager`
3. `package.json` -> `"packageManager"` field
4. Lockfile presence (`pnpm-lock.yaml`, `bun.lockb`, `yarn.lock`, `package-lock.json`)
5. Fallback priority (pnpm > bun > yarn > npm)

## Action on Set

When setting a package manager:
1. Update `package.json` with the chosen `packageManager` version
2. Verify / create appropriate lockfile
3. Clean up conflicting lockfiles after confirmation
