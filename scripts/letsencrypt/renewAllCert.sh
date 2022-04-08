#!/usr/bin/env bash
checkDir() {
    [ -d "$@" ]
}

certStuffRoot="/web/cert_webroot"
sslDirPath="/web/ssl"

if ! checkDir $certStuffRoot; then
    echo "Creating cert_webroot folder"
    mkdir -p $certStuffRoot
fi

if ! checkDir $sslDirPath; then
    echo "Creating ssl folder"
    mkdir -p $sslDirPath
fi

/usr/bin/letsencrypt renew --config-dir $sslDirPath --webroot --webroot-path $certStuffRoot >> /scripts/letsencrypt/letsencrypt-renew.log