#!/usr/bin/env bash
set -e

SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== agy-plus Plugin Installer ==="

# Check if agy CLI is available
if command -v agy &> /dev/null; then
    echo "Running native 'agy plugin install'..."
    agy plugin install "$SOURCE_DIR"
    echo ""
    echo "Plugin successfully installed via Antigravity CLI!"
else
    PLUGIN_NAME="agy-plus"
    GLOBAL_CONFIG_DIR="$HOME/.gemini/config"
    GLOBAL_PLUGINS_DIR="$GLOBAL_CONFIG_DIR/plugins"
    TARGET_DIR="$GLOBAL_PLUGINS_DIR/$PLUGIN_NAME"

    echo "agy binary not found in PATH, installing directly to $TARGET_DIR..."
    mkdir -p "$GLOBAL_PLUGINS_DIR"
    rm -rf "$TARGET_DIR"
    cp -r "$SOURCE_DIR" "$TARGET_DIR"
    rm -rf "$TARGET_DIR/.git" 2>/dev/null || true
    echo "Copied plugin to $TARGET_DIR"
fi

echo ""
echo "To verify active plugins:"
echo "  agy plugin list"
