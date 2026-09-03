#!/usr/bin/env bash
set -e

PLUGIN_NAME="agy-plus"

echo "=== agy-plus Plugin Uninstaller ==="

if command -v agy &> /dev/null; then
    echo "Running native 'agy plugin uninstall $PLUGIN_NAME'..."
    agy plugin uninstall "$PLUGIN_NAME" || true
fi

GLOBAL_CONFIG_DIR="$HOME/.gemini/config"
TARGET_DIR="$GLOBAL_CONFIG_DIR/plugins/$PLUGIN_NAME"

if [ -e "$TARGET_DIR" ] || [ -L "$TARGET_DIR" ]; then
    rm -rf "$TARGET_DIR"
    echo "Removed $TARGET_DIR"
fi

echo "Plugin uninstalled successfully."
