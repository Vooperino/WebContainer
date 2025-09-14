#!/usr/bin/env bash

echo "Installing Nginx!"

apt-get update
apt-get full-upgrade -y

apt-get install nginx -y

echo "Configuring Clean Install and Default Configuration!"

echo "Updating Clean Install Dir"
cp -r -f -v /temp_config/* /clean/config

echo "Updating Config Dir"
cp -r -f -v /temp_config/* /config/

echo "=== End of script ==="