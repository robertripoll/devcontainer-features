# devcontainer-features
Collection of Dev Container features

## Features

### Bun

Installs [Bun](https://bun.sh) - a fast all-in-one JavaScript runtime and toolkit.

**Example Usage:**

```json
"features": {
    "ghcr.io/robertripoll/devcontainer-features/bun:1": {}
}
```

**Options:**
- `version` (string, default: "latest"): Version of Bun to install

See [src/bun/README.md](src/bun/README.md) for more details.

## Contributing

To add a new feature, create a new directory under `src/` with:
- `devcontainer-feature.json` - Feature metadata
- `install.sh` - Installation script
- `README.md` - Feature documentation
