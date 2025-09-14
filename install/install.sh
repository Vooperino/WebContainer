#!/usr/bin/env bash

SUPERCRON_VERSION="0.2.34"

function get_arch() {
    local arch=$(uname -m)
    case "$arch" in
        x86_64) echo "amd64" ;;
        aarch64) echo "arm64" ;;
        armv7l) echo "arm" ;;
        *) echo "Unsupported architecture: $arch" && exit 1 ;;
    esac
}

if [[ ! -d "/vl" ]]; then
    echo "[ERROR] This script must be run from the /vl directory. (BUILD ISSUE/FAULT)"
    exit 1
fi

echo "[INFO] Starting installation of required packages and tools"
apt-get update
apt-get full-upgrade -y

apt-get install -y supervisor curl wget gnupg neovim nano vim emacs apt-utils iftop iptraf wget git zip tar unzip bmon iptraf socat bash-completion certbot cron inetutils-ping software-properties-common ca-certificates lsb-release apt-transport-https python3 python2 python3-certbot-dns-cloudflare

sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list' 
wget -qO - https://packages.sury.org/php/apt.gpg | apt-key add - 
apt-get update

apt-get install -y php7.4 php7.4-{fpm,common,mysql,gmp,curl,intl,mbstring,xmlrpc,gd,xml,cli,zip,soap,imap,sqlite3,bcmath,apcu,zip,phar,iconv}
apt-get install -y php8.3 php8.3-{fpm,common,mysql,gmp,curl,intl,mbstring,xmlrpc,gd,xml,cli,zip,soap,imap,sqlite,bcmath,apcu,zip,phar,iconv}

mkdir -p /run/php
mkdir -p /var/run/supervisord

curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

echo "[INFO] Creating new commands to use"
cp -r -f -v /scripts/reloadCron.sh /usr/bin/reloadCron
cp -r -f -v /scripts/reloadPHP.sh /usr/bin/reloadPHP
cp -r -f -v /scripts/letsencrypt/renewAllCert.sh /usr/bin/renewAllLECert
cp -r -f -v /scripts/letsencrypt/createLetsEncryptCert.sh /usr/bin/createLECert
cp -r -f -v /intcmd/generateSupervisorConfig.sh /usr/bin/generateSupervisorConfig
cp -r -f -v /intcmd/applypermissions.sh /usr/bin/applypermissions
cp -r -f -v /intcmd/lazyamount.sh /usr/bin/lazyamount
cp -r -f -v /intcmd/websrv.sh /usr/bin/websrv

chmod 555 -R /usr/bin/reloadCron
chmod 555 -R /usr/bin/reloadPHP
chmod 555 -R /usr/bin/renewAllLECert
chmod 555 -R /usr/bin/createLECert
chmod 555 -R /usr/bin/generateSupervisorConfig
chmod 555 -R /usr/bin/applypermissions
chmod 555 -R /usr/bin/lazyamount
chmod 555 -R /usr/bin/websrv

rm -rf /intcmd

chmod -R 777 /var/log
chmod -R 777 /run/php

echo "[INFO] Installing supercronic"
ARCH=$(get_arch)
mkdir -p /tmp/supercron-dl
cd /tmp/supercron-dl
curl -fsSLO https://github.com/aptible/supercronic/releases/download/v${SUPERCRON_VERSION}/supercronic-linux-${ARCH}
mv supercronic-linux-${ARCH} supercronic
chmod +x supercronic
mv supercronic /usr/local/bin/supercronic

echo "[INFO] Task done!"
