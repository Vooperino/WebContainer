#!/usr/bin/env bash

nginx_root="/etc/nginx"
nginx_custom="/config/nginx"

isEmptyDir() {
    [ -n "$(find "$@" -maxdepth 0 -type d -empty 2>/dev/null)" ]
}

checkDir() {
    [ -d "$@" ]
}

echo "Stopping Nginx Service"
service nginx stop

echo "Copying Configuration files"
if isEmptyDir "/config/php"; then
    output "Failed to validate php config directory. Copying defaults"
    cp -r -f -v $CLEAN_PATH/config/php/* $php_custom
fi

if ! checkDir "/config/nginx"; then
    output "Failed to validate nginx config directory. Copying defaults"
    cp -r -f -v $CLEAN_PATH/config/nginx/ /config
fi
cp -r -f $nginx_custom/* $nginx_root

echo "Starting Up Nginx Service"
service nginx start

echo "Nginx Service Restarted!"