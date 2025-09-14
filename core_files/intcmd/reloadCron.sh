#!/usr/bin/env bash

SUPERVISOR_CONFIG="/vl/supervisord.conf"

if [[ ! -f "$SUPERVISOR_CONFIG" ]]; then
    echo "Supervisor configuration file not found: $SUPERVISOR_CONFIG"
    exit 1
fi

SERVICE_NAME="supercronic"
SERVICE=$(supervisorctl status "${SERVICE_NAME}" | awk '{print $2}')

if [ "$SERVICE" == "RUNNING" ]; then
    echo "[INFO] Stopping $SERVICE_NAME..."
    supervisorctl stop "${SERVICE_NAME}"
    if [ $? -ne 0 ]; then
        echo "[ERROR] Failed to stop $SERVICE_NAME."
        exit 1
    fi
    echo "[INFO] $SERVICE_NAME stopped successfully."
fi

echo "[INFO] Starting $SERVICE_NAME..."
supervisorctl start "${SERVICE_NAME}"
if [ $? -ne 0 ]; then
    echo "[ERROR] Failed to start $SERVICE_NAME."
    exit 1
fi
echo "[INFO] $SERVICE_NAME started successfully."
exit 0