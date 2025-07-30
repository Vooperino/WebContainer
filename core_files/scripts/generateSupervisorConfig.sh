#!/usr/bin/env bash

# WORK IN PROGRESS

CORE_SURPERVISOR_CONFIG_PATH=""
MODULE_SURPERVISOR_CONFIG_PATH=""
USER_SURPERVISOR_CONFIG_PATH=""

TEMP_CONFIG_PATH="/tmp/supervisor.conf"

function validatePath() {
    local path="$1"
    if [[ -z "$path" ]]; then
        echo "Error: Path cannot be empty."
        exit 1
    fi
    if [[ ! -d "$path" ]]; then
        echo "Error: Path '$path' does not exist or is not a directory."
        exit 1
    fi
    echo "[INFO] Path '$path' is valid."
}


echo "[INFO] Validating paths for supervisor configuration files..."
validatePath "$CORE_SURPERVISOR_CONFIG_PATH"
validatePath "$MODULE_SURPERVISOR_CONFIG_PATH"
echo "[INFO] Paths validated successfully."

if [ -f "$TEMP_CONFIG_PATH" ]; then
    echo "[INFO] Removing existing temporary configuration file..."
    rm "$TEMP_CONFIG_PATH"
fi

touch "$TEMP_CONFIG_PATH"
echo "[INFO] Temporary configuration file created at $TEMP_CONFIG_PATH."