#!/usr/bin/env bash

echo "Stopping all PHP services"

service php7.4-fpm stop
service php8.0-fpm stop
service php8.1-fpm stop

echo "Start all PHP services"

service php7.4-fpm start
service php8.0-fpm start
service php8.1-fpm start

echo "End of reload script!"