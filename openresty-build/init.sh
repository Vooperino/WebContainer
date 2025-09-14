#!/usr/bin/env bash

openresty_root="/usr/local/openresty/nginx/conf"
php_root="/etc/php"

crontab_file="/config/cronTasks"

AUTORUN_PATH="/web/config/autorun.sh"
WEBLAUNCH_SCRIPT="/launchWeb.sh"

CLEAN_PATH="/clean"

NEWINSTALL="/newinstall"

AUTO_UPDATE="/web/config/.auto_update"

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

if [[ -z "${BACKEND_RENEW_LESSL}" ]]; then
    BACKEND_RENEW_LESSL=false
else
    if [[ "${BACKEND_RENEW_LESSL}" != "true" && "${BACKEND_RENEW_LESSL}" != "false" ]]; then
        echo "[WARNING] BACKEND_RENEW_LESSL must be set to 'true' or 'false'. Defaulting to 'false'."
        unset BACKEND_RENEW_LESSL
        BACKEND_RENEW_LESSL=false
        sleep 5
    fi
fi

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

if isEmptyDir "/config/supervisord"; then 
    output "Copying clean config data"
    cp -r -f -v $CLEAN_PATH/config/supervisord/* /config/supervisord
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

if ! checkDir "/config/openresty"; then
    output "Failed to validate openresty config directory. Copying defaults"
    mkdir -p /config/openresty
    cp -r -f -v $CLEAN_PATH/config/openresty/ /config
fi

if isEmptyDir "/config/openresty"; then
    output "Failed to validate openresty config directory. Copying defaults"
    cp -r -f -v $CLEAN_PATH/config/openresty/ /config
fi

if isEmptyDir "/scripts"; then 
    output "Copying clean script data"
    cp -r -f -v $CLEAN_PATH/scripts/* /scripts
fi

bash /scripts/pathChecker.sh

if ! checkFile "/vl/supervisord/1_pack.conf"; then
    output "Pack configuration file is missing! Copying default!"
    cp -r -f -v /config/supervisord/1_pack.conf /vl/supervisord/1_pack.conf
fi

generateSupervisorConfig

apt-get update
if checkFile $AUTO_UPDATE; then
    apt-get full-upgrade -y
fi

#Copy Openresty Stuff
rm -rf $openresty_root/*
rm -rf $php_root/*

lazyamount

reloadCustomLua

if checkFile $crontab_file; then
    crontab -u root $crontab_file
fi

if ! checkFile $NEWINSTALL; then
    #echo "New install detected! Tossing a fresh default openresty config!"
    #cp -r -f -v /clean/config/defaults/default.conf /web/config/openresty/sites-enabled/
    rm -rf $NEWINSTALL
fi

if ! checkFile $AUTORUN_PATH; then 
    output "Creating Autorun Script File!"
    touch $AUTORUN_PATH
    echo "#!/usr/bin/env bash" >> $AUTORUN_PATH
fi

chmod 755 -R /scripts/*

supervisord -c /vl/supervisor.conf