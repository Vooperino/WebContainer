#!/usr/bin/env bash

CLEAN_PATH="/clean"

SCRIPTS_PATH="/scripts"
CONFIG_PATH="/config"

PHP_ROOT="/etc/php"

output() {
    echo "Debug: $@"
}

output "Creating Clean Directory"
mkdir -p $CLEAN_PATH/scripts
mkdir -p $CLEAN_PATH/config

output "Copying data!"
cp -r -f -v $SCRIPTS_PATH/* $CLEAN_PATH/scripts
cp -r -f -v $CONFIG_PATH/* $CLEAN_PATH/config

mkdir $CLEAN_PATH/config/php
cp -r -f -v $PHP_ROOT/* $CLEAN_PATH/config/php
output "Configuring PHP Permissions (Temp bugfix)"
sed -i 's/;listen.mode = 0660/listen.mode = 0666/g' $CLEAN_PATH/config/php/8.1/fpm/pool.d/www.conf
sed -i 's/;listen.mode = 0660/listen.mode = 0666/g' $CLEAN_PATH/config/php/8.0/fpm/pool.d/www.conf
sed -i 's/;listen.mode = 0660/listen.mode = 0666/g' $CLEAN_PATH/config/php/7.4/fpm/pool.d/www.conf


output "Applying script directory permission!"
chmod 755 -R $CLEAN_PATH/scripts

output "The operation finished successfully!"