#!/bin/bash
username=`id -u -n`
if [[ "$username" != "root" ]] ; then
    echo "This script should be run as user 'root'"
    exit
fi

chown -R www-data:www-data /var/www
/scripts/upgrade-magerun2.sh
su - www-data -c /scripts/install-magento.sh
