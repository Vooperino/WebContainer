#!/usr/bin/env bash

crontab_file="/config/cronTasks"

service cron stop
service cron start
crontab -u root $crontab_file
echo "Cron service reloaded!"