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

WEBROOT_OPTS="--webroot --webroot-path $certStuffRoot"
if [ -f "/cloudflare-account.ini" ]; then
    echo "Using CloudFlare API for DNS"
    WEBROOT_OPTS="--dns-cloudflare --dns-cloudflare-credentials /cloudflare-account.ini"
fi

echo "Creating a cert for ${1}"
certbot certonly --config-dir $sslDirPath $WEBROOT_OPTS -n --agree-tos --register-unsafely-without-email -d ${1}
if [ $? -ne 0 ]; then
    echo "[Failure] Unable to create certificate '${1}' due to an error"
    exit 1
else
    echo "End of script have a nice day! Enjoy you're new cert if it was created"
    exit 0
fi
