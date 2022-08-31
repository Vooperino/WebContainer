#!/usr/bin/env bash

openresty_root="/usr/local/openresty/nginx/conf"
openresty_custom="/config/openresty"

echo "Stopping OpenResty Service"
sysctl stop openresty

echo "Copying Configuration Files"
rm -rf $openresty_root/*
cp -r -f -v $openresty_custom/* $openresty_root

echo "Starting Up OpenResty Service"
sysctl start openresty

echo "OpenResty Service Restarted!"