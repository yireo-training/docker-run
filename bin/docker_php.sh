#!/bin/bash

# Define the root of this project
script=`readlink -f $BASH_SOURCE`
scriptFolder=`dirname $script`
root=`dirname $scriptFolder`

# Choose the PHP image
image=yireo/magento2base

# Create a "magento" network if it doesn't exist yet
docker network ls | grep -q " magento " || docker network create --driver bridge magento --subnet 172.20.0.0/16

# Kill the existing container
docker ps | grep -q php && docker stop php
sleep 1

# Run a new container
docker run \
    --name=php \
    --rm \
    -d \
    -p 9000:9000 \
    --mount type=bind,source=${root}/magento/source,target=/var/www/html \
    -v ${root}/magento/scripts:/scripts \
    -v ${root}/common/conf/hosts:/etc/hosts \
    -v ~/.composer/auth.json:/var/www/.composer/auth.json \
    --net=magento \
    --ip=172.20.0.100 \
    $image

sleep 1
docker ps | grep -q php || echo "PHP-FPM failed to start"

