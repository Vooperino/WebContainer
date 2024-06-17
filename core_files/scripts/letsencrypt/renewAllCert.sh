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

CLOUDFLARE_OPTS=""
if [ -d "/cloudflare-account.ini" ]; then
    CLOUDFLARE_OPTS+="--dns-cloudflare --dns-cloudflare-credentials /cloudflare-account.ini"
fi

certbot renew $CLOUDFLARE_OPTS --config-dir $sslDirPath --webroot --webroot-path $certStuffRoot >> /scripts/letsencrypt/letsencrypt-renew.log