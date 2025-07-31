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

function generatePHPConfig() {
    local version="$1"
    if [[ -z "$version" ]]; then
        echo "Error: PHP version cannot be empty."
    else
        if [[ ! "$version" =~ ^[0-9]+\.[0-9]+$ ]]; then
            echo "Error: Invalid PHP version format. Expected format is X.Y (e.g., 8.0, 7.1)."
        else
            local template_file="/path/to/phptemplatefpm.conf"
            if [[ -f "$template_file" ]]; then
                while IFS= read -r line; do
                    if [[ -n "$line" ]]; then
                        echo "$line" | sed "s/{PHP_VERSION}/$version/g" >> "$TEMP_CONFIG_PATH"
                    else
                        echo "" >> "$TEMP_CONFIG_PATH"
                done < "$template_file"
            fi
        fi
    fi
}

function applyFromConfig() {
    local config_file="$1"
    if [[ ! -f "$config_file" ]]; then
        echo "Error: Configuration file '$config_file' does not exist."
    else
        echo "[INFO] Applying configuration from $config_file to $TEMP_CONFIG_PATH..."
        while IFS= read -r line; do
            if [[ -n "$line" ]]; then
                echo "$line" >> "$TEMP_CONFIG_PATH"
            else
                echo "" >> "$TEMP_CONFIG_PATH"
            fi
        done < "$config_file"
    fi
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