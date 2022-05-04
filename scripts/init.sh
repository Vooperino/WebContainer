#!/usr/bin/env bash

nginx_root="/etc/nginx"
nginx_custom="/config/nginx"

crontab_file="/config/cronTasks"

AUTORUN_PATH="/web/config/autorun.sh"

checkDir() {
    [ -d "$@" ]
}

checkFile() {
    [ -f "$@" ]
}

bash /scripts/pathChecker.sh

apt-get update
apt-get full-upgrade -y

#Copy Nginx Stuff
cp -r -f $nginx_custom/* $nginx_root

service nginx start
service php7.4-fpm start
service php8.0-fpm start
service php8.1-fpm start
service cron start

if checkFile $crontab_file; then
    crontab /config/cronTasks
fi

bash $AUTORUN_PATH
bash