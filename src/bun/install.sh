#!/bin/bash
set -e

# Bun installation script for devcontainer feature
# This script installs Bun and adds it to the PATH in shell configuration files

VERSION="${VERSION:-"latest"}"

echo "Activating feature 'bun'"
echo "The provided version is: $VERSION"

# Determine the appropriate non-root user
if [ "$(id -u)" -ne 0 ]; then
    USERNAME=$(whoami)
else
    USERNAME="${USERNAME:-"${_REMOTE_USER:-"automatic"}"}"
fi

# If in automatic mode, determine the non-root user
if [ "${USERNAME}" = "auto" ] || [ "${USERNAME}" = "automatic" ]; then
    USERNAME=""
    POSSIBLE_USERS=("vscode" "node" "codespace" "$(awk -v val=1000 -F ":" '$3==val{print $1}' /etc/passwd)")
    for CURRENT_USER in "${POSSIBLE_USERS[@]}"; do
        if id -u "${CURRENT_USER}" > /dev/null 2>&1; then
            USERNAME=${CURRENT_USER}
            break
        fi
    done
    if [ "${USERNAME}" = "" ]; then
        USERNAME=root
    fi
elif [ "${USERNAME}" = "none" ] || ! id -u "${USERNAME}" > /dev/null 2>&1; then
    USERNAME=root
fi

# Determine the user's home directory
if [ "${USERNAME}" = "root" ]; then
    USER_HOME="/root"
else
    USER_HOME="/home/${USERNAME}"
fi

echo "Installing Bun for user: ${USERNAME}"
echo "User home directory: ${USER_HOME}"

# Install Bun using the official installation script
export BUN_INSTALL="${USER_HOME}/.bun"

if [ "${VERSION}" = "latest" ]; then
    echo "Installing latest version of Bun..."
    curl -fsSL https://bun.sh/install | bash
else
    echo "Installing Bun version ${VERSION}..."
    curl -fsSL https://bun.sh/install | bash -s "bun-v${VERSION}"
fi

# Ensure the installation was successful
if [ ! -f "${BUN_INSTALL}/bin/bun" ]; then
    echo "Error: Bun installation failed"
    exit 1
fi

echo "Bun installed successfully at ${BUN_INSTALL}/bin/bun"

# Function to add Bun to PATH in a shell config file
add_to_path() {
    local config_file="$1"
    local marker="# Bun PATH configuration"
    
    # Create the config file if it doesn't exist
    if [ ! -f "${config_file}" ]; then
        touch "${config_file}"
        if [ "${USERNAME}" != "root" ]; then
            chown "${USERNAME}:${USERNAME}" "${config_file}"
        fi
    fi
    
    # Check if Bun PATH is already configured
    if ! grep -q "BUN_INSTALL.*\.bun" "${config_file}"; then
        echo "" >> "${config_file}"
        echo "${marker}" >> "${config_file}"
        echo 'export BUN_INSTALL="$HOME/.bun"' >> "${config_file}"
        echo 'export PATH="$BUN_INSTALL/bin:$PATH"' >> "${config_file}"
        echo "Added Bun to PATH in ${config_file}"
    else
        echo "Bun PATH already configured in ${config_file}"
    fi
}

# Add Bun to PATH in common shell configuration files
SHELL_CONFIGS=(
    "${USER_HOME}/.bashrc"
    "${USER_HOME}/.zshrc"
    "${USER_HOME}/.profile"
)

for config in "${SHELL_CONFIGS[@]}"; do
    # Only add to config files that exist or are standard (bashrc, zshrc)
    if [ -f "${config}" ] || [[ "${config}" =~ (bashrc|zshrc)$ ]]; then
        add_to_path "${config}"
    fi
done

# Set proper ownership for the Bun installation
if [ "${USERNAME}" != "root" ]; then
    chown -R "${USERNAME}:${USERNAME}" "${BUN_INSTALL}"
fi

# Verify installation
if [ -f "${BUN_INSTALL}/bin/bun" ]; then
    BUN_VERSION=$("${BUN_INSTALL}/bin/bun" --version 2>/dev/null || echo "unknown")
    echo "Bun version ${BUN_VERSION} installed successfully!"
else
    echo "Warning: Bun binary not found at expected location"
    exit 1
fi

echo "Done!"
