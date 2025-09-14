#!/usr/bin/env bash

function print_usage() {
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  --stop        Stop the web server"
    echo "  --start       Start the web server"
    echo "  --restart     Restart the web server"
    echo "  -h, --help    Show this help message and exit"
}

if [[ $# -eq 0 ]]; then
    echo "No arguments provided."
    print_usage
    exit 1
fi

SERVICE="webserver"
SERVICE_STATUS=$(supervisorctl status "${SERVICE}" | awk '{print $2}')

while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -h|--help)
            print_usage
            exit 0
            ;;
        --stop)
            if [ "$STATUS" = "RUNNING" ]; then
                echo "[INFO] Stopping web server..."
                supervisorctl stop ${SERVICE}
                if [ $? -ne 0 ]; then
                    echo "[ERROR] Failed to stop web server."
                    exit 1
                fi
                echo "[INFO] Web server stopped successfully."
                exit 0
            else
                echo "[ERROR] Web server is not running."
                exit 1
            fi
            ;;
        --start)
            if [ "$STATUS" = "RUNNING" ]; then
                echo "[ERROR] Web server is already running."
                exit 1
            else
                echo "[INFO] Starting web server..."            
                supervisorctl start ${SERVICE}
                if [ $? -ne 0 ]; then
                    echo "[ERROR] Failed to start web server."
                    exit 1
                fi
                echo "[INFO] Web server started successfully."
                exit 0
            fi
            ;;
        --restart)
            if [ "$STATUS" = "RUNNING" ]; then
                echo "[INFO] Restarting web server..."
                 supervisorctl stop ${SERVICE}
                if [ $? -ne 0 ]; then
                    echo "[ERROR] Failed to stop web server."
                    exit 1
                fi
                supervisorctl start ${SERVICE}
                if [ $? -ne 0 ]; then
                    echo "[ERROR] Failed to start web server."
                    exit 1
                fi
                echo "[INFO] Web server restarted successfully."
                exit 0
            else
                echo "[ERROR] Web server is not running."
                exit 1
            fi
            ;;
        *)
            echo "Error: Unrecognized option '$key'"
            print_usage
            exit 1
            ;;
    esac
    shift
done