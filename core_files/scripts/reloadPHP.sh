#!/usr/bin/env bash

isEmptyDir() {
    [ -n "$(find "$@" -maxdepth 0 -type d -empty 2>/dev/null)" ]
}

checkDir() {
    [ -d "$@" ]
}


php_root="/etc/php"
php_custom="/config/php"
php_clean="/clean/config/php"

echo "Stopping all PHP services"

service php7.4-fpm stop
service php8.0-fpm stop
service php8.1-fpm stop

echo "Copying Configuration"
rm -rf $php_root/*
if ! checkDir "/config/php"; then
    output "Failed to validate php config directory. Copying defaults"
    mkdir -p $php_custom
    cp -r -f -v $CLEAN_PATH/config/php/* $php_custom
fi

if isEmptyDir "/config/php"; then
    output "Failed to validate php config directory. Copying defaults"
    cp -r -f -v $CLEAN_PATH/config/php/* $php_custom
fi

echo "Start all PHP services"

service php7.4-fpm start
service php8.0-fpm start
service php8.1-fpm start

echo "End of reload script!"