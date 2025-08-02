#!/usr/bin/env bash

SUPERVISOR_CONFIG="/vl/supervisord.conf"

if [[ ! -f "$SUPERVISOR_CONFIG" ]]; then
    echo "Supervisor configuration file not found: $SUPERVISOR_CONFIG"
    exit 1
fi

restartPHP() {
    local version="$1"
    local service_name="php${version}-fpm"
    if supervisorctl status | grep -q "$service_name"; then
        echo "Restarting $service_name..."
        supervisorctl restart "$service_name"
        echo "$service_name restarted successfully."
    else
        echo "Service $service_name not found in Supervisor."
    fi
}

restartPHP "7.4"
restartPHP "8.0"
restartPHP "8.1"
restartPHP "8.2"
restartPHP "8.3"