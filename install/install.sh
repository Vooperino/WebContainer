#!/usr/bin/env bash

apt-get update
apt-get full-upgrade -y

apt-get install -y curl wget gnupg nano vim emacs nginx apt-utils iftop wget git zip tar unzip socat bash-completion certbot cron inetutils-ping software-properties-common ca-certificates lsb-release apt-transport-https python3 python2

sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list' 
wget -qO - https://packages.sury.org/php/apt.gpg | apt-key add - 
apt-get update

apt-get install -y php7.4 php7.4-{fpm,common,mysql,gmp,curl,intl,mbstring,xmlrpc,gd,xml,cli,zip,soap,imap,sqlite3,bcmath,apcu}
apt-get install -y php8.0 php8.0-{fpm,common,mysql,gmp,curl,intl,mbstring,xmlrpc,gd,xml,cli,zip,soap,imap,sqlite,bcmath,apcu}
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer