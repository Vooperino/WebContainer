#!/usr/bin/env bash

echo "Stopping OpenResty Service"
sysctl stop openresty
echo "Starting Up OpenResty Service"
sysctl start openresty

echo "OpenResty Service Restarted!"