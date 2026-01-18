# Bun (bun)

Installs [Bun](https://bun.sh) - a fast all-in-one JavaScript runtime and toolkit.

## Example Usage

```json
"features": {
    "ghcr.io/robertripoll/devcontainer-features/bun:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| version | Version of Bun to install. Use 'latest' for the most recent version. | string | latest |

## Description

This feature installs Bun, a fast JavaScript runtime, package manager, test runner, and bundler. The installation includes:

- Bun binary installed in `~/.bun/bin/`
- Automatic PATH configuration in shell config files (`.bashrc`, `.zshrc`, `.profile`)
- Support for specifying a specific version or using the latest version

## Usage Examples

### Install Latest Version

```json
"features": {
    "ghcr.io/robertripoll/devcontainer-features/bun:1": {}
}
```

### Install Specific Version

```json
"features": {
    "ghcr.io/robertripoll/devcontainer-features/bun:1": {
        "version": "1.0.20"
    }
}
```

## Notes

- The feature automatically detects the current user and installs Bun in their home directory
- PATH is automatically added to common shell configuration files (bash, zsh)
- The installation is idempotent - running it multiple times won't cause issues

## OS Support

This feature is tested on:
- Debian/Ubuntu
- Alpine Linux
- Other Linux distributions with bash support

---

_Note: This feature follows the [dev container feature specification](https://containers.dev/implementors/features/)._
