#!/usr/bin/env bash

nginx_root="/etc/nginx"
nginx_custom="/config/nginx"

crontab_file="/config/cronTasks"

AUTORUN_PATH="/web/config/autorun.sh"
WEBLAUNCH_SCRIPT="/launchWeb.sh"

CLEAN_PATH="/clean"

output() {
    echo "Output: $@"
}

checkDir() {
    [ -d "$@" ]
}

checkFile() {
    [ -f "$@" ]
}

isEmptyDir() {
    [ -n "$(find "$@" -maxdepth 0 -type d -empty 2>/dev/null)" ]
}

if checkDir "/clean"; then
    if isEmptyDir $CLEAN_PATH; then
        output "Clean configuration was not found! Corrupt of incomplete docker build of this container! Exiting"
        exit 1
    else
        output "Clean configuration folder was found!"    
    fi
else
    output "Clean configuration was not found! Corrupt of incomplete docker build of this container! Exiting"
    exit 1
fi

if checkDir "/install"; then 
    output "Found install dir, removing it"
    rm -rf /install;
fi

if isEmptyDir "/config"; then 
    output "Copying clean config data"
    cp -r -f -v $CLEAN_PATH/config/* /config
fi

if isEmptyDir "/scripts"; then 
    output "Copying clean script data"
    cp -r -f -v $CLEAN_PATH/scripts/* /scripts
fi

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
    crontab -u root $crontab_file
fi

if ! checkFile $AUTORUN_PATH; then 
    output "Creating Autorun Script File!"
    touch $AUTORUN_PATH
    echo "#!/usr/bin/env bash" >> $AUTORUN_PATH
fi

chmod 755 -R /scripts/*

bash $AUTORUN_PATH
bash