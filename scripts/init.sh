#!/usr/bin/env bash

cron_root="/etc/cron.d"
cron_custom="/config/cron"

nginx_root="/etc/nginx"
nginx_custom="/config/nginx"

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

#Copy Systemctl Replacer

#Copy Cron Stuff
cp -r -f $cron_custom/* $cron_root

#Copy Nginx Stuff
cp -r -f $nginx_custom/* $nginx_root

service nginx start
service php7.4-fpm start
service php8.0-fpm start
service cron start

crontab config/cron

bash $AUTORUN_PATH
bash