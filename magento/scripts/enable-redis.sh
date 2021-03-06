#!/bin/bash
username=`id -u -n`
if [[ "$username" != "www-data" ]] ; then
    echo "This script should be run as user 'www-data'"
    exit
fi

bin/magento setup:config:set --cache-backend=redis --cache-backend-redis-server=redis --cache-backend-redis-db=0 -n
bin/magento setup:config:set --page-cache=redis --page-cache-redis-server=redis --page-cache-redis-db=1 -n
bin/magento cache:disable full_page
bin/magento cache:flush
