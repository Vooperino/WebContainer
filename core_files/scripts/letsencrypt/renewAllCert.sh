#!/usr/bin/env bash
checkDir() {
    [ -d "$@" ]
}

checkFile() {
    [ -f "$@" ]
}

certStuffRoot="/web/cert_webroot"
sslDirPath="/web/ssl"
logFile="/scripts/letsencrypt/letsencrypt-renew.log"

if ! checkDir $certStuffRoot; then
    echo "Creating cert_webroot folder"
    mkdir -p $certStuffRoot
fi

if ! checkDir $sslDirPath; then
    echo "Creating ssl folder"
    mkdir -p $sslDirPath
fi

if ! checkFile $logFile; then
    echo "Creating Log File"
    touch $logFile
fi

/usr/bin/letsencrypt renew --config-dir $sslDirPath --webroot --webroot-path $certStuffRoot >> /scripts/letsencrypt/letsencrypt-renew.log