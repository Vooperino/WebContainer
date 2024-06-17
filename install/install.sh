#!/usr/bin/env bash

apt-get update
apt-get full-upgrade -y

apt-get install -y curl wget gnupg neovim nano vim emacs apt-utils iftop iptraf wget git zip tar unzip bmon iptraf socat bash-completion certbot cron inetutils-ping software-properties-common ca-certificates lsb-release apt-transport-https python3 python2 python3-certbot-dns-cloudflare

sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list' 
wget -qO - https://packages.sury.org/php/apt.gpg | apt-key add - 
apt-get update

apt-get install -y php7.4 php7.4-{fpm,common,mysql,gmp,curl,intl,mbstring,xmlrpc,gd,xml,cli,zip,soap,imap,sqlite3,bcmath,apcu,zip}
apt-get install -y php8.0 php8.0-{fpm,common,mysql,gmp,curl,intl,mbstring,xmlrpc,gd,xml,cli,zip,soap,imap,sqlite,bcmath,apcu,zip}
apt-get install -y php8.1 php8.1-{fpm,common,mysql,gmp,curl,intl,mbstring,xmlrpc,gd,xml,cli,zip,soap,imap,sqlite,bcmath,apcu,zip}
apt-get install -y php8.2 php8.2-{fpm,common,mysql,gmp,curl,intl,mbstring,xmlrpc,gd,xml,cli,zip,soap,imap,sqlite,bcmath,apcu,zip}
apt-get install -y php8.3 php8.3-{fpm,common,mysql,gmp,curl,intl,mbstring,xmlrpc,gd,xml,cli,zip,soap,imap,sqlite,bcmath,apcu,zip}

curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

echo "Creating new commands to use"
cp -r -f -v /scripts/reloadCron.sh /usr/bin/reloadCron
cp -r -f -v /scripts/reloadPHP.sh /usr/bin/reloadPHP
cp -r -f -v /scripts/letsencrypt/renewAllCert.sh /usr/bin/renewAllLECert
cp -r -f -v /scripts/letsencrypt/createLetsEncryptCert.sh /usr/bin/createLECert
cp -r -f -v /scripts/systemd-replacer/systemctl3.py /usr/bin/sysctl

chmod 555 -R /usr/bin/reloadCron
chmod 555 -R /usr/bin/reloadPHP
chmod 555 -R /usr/bin/renewAllLECert
chmod 555 -R /usr/bin/createLECert
chmod 555 -R /usr/bin/sysctl
echo "Task done!"
