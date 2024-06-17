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
    echo "Creating SSL folder"
    mkdir -p $sslDirPath
fi

if ! checkFile $logFile; then
    echo "Creating Log File"
    touch $logFile
fi

WEBROOT_OPTS="--webroot --webroot-path $certStuffRoot"
if [ -d "/cloudflare-account.ini" ]; then
    echo "Using CloudFlare API for DNS"
    WEBROOT_OPTS="--dns-cloudflare --dns-cloudflare-credentials /cloudflare-account.ini"
fi

certbot renew --config-dir $sslDirPath $WEBROOT_OPTS >> /scripts/letsencrypt/letsencrypt-renew.log