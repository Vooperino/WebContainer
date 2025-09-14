#!/usr/bin/env bash

STATUS_WEBSRV=$(supervisorctl status webserver | awk '{print $2}')
STATUS_PHP74=$(supervisorctl status php7.4-fpm | awk '{print $2}')
STATUS_PHP83=$(supervisorctl status php8.3-fpm | awk '{print $2}')
STATUS_CRON=$(supervisorctl status supercronic | awk '{print $2}')

OK_WEBSRV=false
OK_PHP74=false
OK_PHP83=false
OK_CRON=false

NOTOKAY_SERVICES=0
NOTOKAY_SERVICES_LIST=""

if [ "$STATUS_WEBSRV" == "RUNNING" ]; then
    OK_WEBSRV=true
fi

if [ "$STATUS_PHP74" == "RUNNING" ]; then
    OK_PHP74=true
fi

if [ "$STATUS_PHP83" == "RUNNING" ]; then
    OK_PHP83=true
fi

if [ "$STATUS_CRON" == "RUNNING" ]; then
    OK_CRON=true
fi

if [ "$OK_WEBSRV" == false ]; then
    NOTOKAY_SERVICES=$((NOTOKAY_SERVICES + 1))
    NOTOKAY_SERVICES_LIST="${NOTOKAY_SERVICES_LIST} webserver"
fi

if [ "$OK_PHP74" == false ]; then
    NOTOKAY_SERVICES=$((NOTOKAY_SERVICES + 1))
    NOTOKAY_SERVICES_LIST="${NOTOKAY_SERVICES_LIST} php7.4-fpm"
fi

if [ "$OK_PHP83" == false ]; then
    NOTOKAY_SERVICES=$((NOTOKAY_SERVICES + 1))
    NOTOKAY_SERVICES_LIST="${NOTOKAY_SERVICES_LIST} php8.3-fpm"
fi

if [ "$OK_CRON" == false ]; then
    NOTOKAY_SERVICES=$((NOTOKAY_SERVICES + 1))
    NOTOKAY_SERVICES_LIST="${NOTOKAY_SERVICES_LIST} supercronic"
fi

if [ $NOTOKAY_SERVICES -eq 0 ]; then
    echo "[HEALTHCHECK] All services are running fine."
    exit 0
else
    echo "[HEALTHCHECK] $NOTOKAY_SERVICES services are not running:$NOTOKAY_SERVICES_LIST"
    exit 1
fi
