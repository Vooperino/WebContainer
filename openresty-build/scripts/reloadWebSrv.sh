#!/usr/bin/env bash

openresty_root="/usr/local/openresty/nginx/conf"
openresty_custom="/config/openresty"

isEmptyDir() {
    [ -n "$(find "$@" -maxdepth 0 -type d -empty 2>/dev/null)" ]
}

checkDir() {
    [ -d "$@" ]
}

echo "Stopping OpenResty Service"
sysctl stop openresty

echo "Copying Configuration Files"
if ! checkDir "/config/openresty"; then
    output "Failed to validate openresty config directory. Copying defaults"
    mkdir -p /config/openresty
    cp -r -f -v $CLEAN_PATH/config/openresty/ /config
fi

if isEmptyDir "/config/openresty"; then
    output "Failed to validate openresty config directory. Copying defaults"
    cp -r -f -v $CLEAN_PATH/config/openresty/ /config
fi
rm -rf $openresty_root/*
cp -r -f -v $openresty_custom/* $openresty_root

echo "Starting Up OpenResty Service"
sysctl start openresty

echo "OpenResty Service Restarted!"