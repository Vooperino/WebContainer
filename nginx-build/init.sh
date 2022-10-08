#!/usr/bin/env bash

nginx_root="/etc/nginx"
nginx_custom="/config/nginx"

php_root="/etc/php"
php_custom="/config/php"

crontab_file="/config/cronTasks"

AUTORUN_PATH="/web/config/autorun.sh"
WEBLAUNCH_SCRIPT="/launchWeb.sh"

CLEAN_PATH="/clean"

NEWINSTALL="/newinstall"

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

if ! checkDir "/config/php"; then
    output "Failed to validate php config directory. Copying defaults"
    mkdir -p $php_custom
    cp -r -f -v $CLEAN_PATH/config/php/* $php_custom
fi

if isEmptyDir "/config/php"; then
    output "Failed to validate php config directory. Copying defaults"
    cp -r -f -v $CLEAN_PATH/config/php/* $php_custom
fi

if ! checkDir "/config/nginx"; then
    output "Failed to validate nginx config directory. Copying defaults"
    cp -r -f -v $CLEAN_PATH/config/nginx/ /config
fi

if isEmptyDir "/scripts"; then 
    output "Copying clean script data"
    cp -r -f -v $CLEAN_PATH/scripts/* /scripts
fi

bash /scripts/pathChecker.sh

apt-get update
if [ -z "$UPDATE_ON_LAUNCH" ]; then
    apt-get full-upgrade -y
fi

#Copy Nginx Stuff

rm -rf $php_root/*

cp -r -f $nginx_custom/* $nginx_root
cp -r -f $php_custom/* $php_root

service nginx start
service php7.4-fpm start
service php8.0-fpm start
service php8.1-fpm start
service cron start

if checkFile $crontab_file; then
    crontab -u root $crontab_file
fi

if ! checkFile $NEWINSTALL; then
    echo "New install detected! Tossing a fresh default nginx config!"
    #cp -r -f -v /clean/config/defaults/default.conf /web/config/nginx/sites-enabled/
    rm -rf $NEWINSTALL
fi

if ! checkFile $AUTORUN_PATH; then 
    output "Creating Autorun Script File!"
    touch $AUTORUN_PATH
    echo "#!/usr/bin/env bash" >> $AUTORUN_PATH
fi

chmod 755 -R /scripts/*

bash $AUTORUN_PATH
bash