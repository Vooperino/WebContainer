#!/usr/bin/env bash

echo "Stopping Nginx Service"
service nginx stop
echo "Starting Up Nginx Service"
service nginx start

echo "Nginx Service Restarted!"