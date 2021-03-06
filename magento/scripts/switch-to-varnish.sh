#!/bin/bash
username=`id -u -n`
if [[ "$username" != "www-data" ]] ; then
    echo "This script should be run as user 'www-data'"
    exit
fi

cd /var/www/html
magerun2 config:set web/unsecure/base_url "http://varnish.local/"
magerun2 config:set system/full_page_cache/caching_application 2
magerun2 cache:clean config
magerun2 cache:enable full_page
magerun2 sys:url:list
