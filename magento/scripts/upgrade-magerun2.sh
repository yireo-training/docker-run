#!/bin/bash
username=`id -u -n`
if [[ "$username" != "root" ]] ; then
    echo "This script should be run as user 'root'"
    exit
fi

curl -sS -O https://files.magerun.net/n98-magerun2.phar
chmod +x ./n98-magerun2.phar
mv n98-magerun2.phar /usr/local/bin/magerun2
