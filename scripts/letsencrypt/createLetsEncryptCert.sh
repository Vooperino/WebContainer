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


echo "Creating a cert for ${1}"
certbot certonly --config-dir $sslDirPath --webroot --webroot-path $certStuffRoot -n --agree-tos --register-unsafely-without-email -d ${1}
echo "End of script have a nice day! Enjoy you're new cert if it was created"