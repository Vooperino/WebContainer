#!/usr/bin/env bash

nginx_root="/etc/nginx"
nginx_custom="/config/nginx"

echo "Stopping Nginx Service"
service nginx stop

echo "Copying Configuration files"
cp -r -f $nginx_custom/* $nginx_root

echo "Starting Up Nginx Service"
service nginx start

echo "Nginx Service Restarted!"