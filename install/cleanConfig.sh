#!/usr/bin/env bash

CLEAN_PATH="/clean/core"

SCRIPTS_PATH="/scripts"
CONFIG_PATH="/config"

output() {
    echo "Debug: $@"
}

output "Creating Clean Directory"
mkdir -p $CLEAN_PATH/scripts
mkdir -p $CLEAN_PATH/config

output "Copying data!"
cp -r -f -v $SCRIPTS_PATH/* $CLEAN_PATH/scripts
cp -r -f -v $CONFIG_PATH/* $CLEAN_PATH/config

output "Applying script directory permission!"
chmod 755 -R $CLEAN_PATH/scripts

output "The operation finished successfully!"