#!/usr/bin/env bash

SUPERVISOR_CONFIG="/vl/supervisord.conf"

if [[ ! -f "$SUPERVISOR_CONFIG" ]]; then
    echo "Supervisor configuration file not found: $SUPERVISOR_CONFIG"
    exit 1
fi

supervisorctl -c "$SUPERVISOR_CONFIG" restart supercronic