#!/bin/bash

# Define the root of this project
script=`readlink -f $BASH_SOURCE`
scriptFolder=`dirname $script`
root=`dirname $scriptFolder`

# Choose the PHP image
#image=php:7.2-fpm
image=yireo/magento2base
#image=markoshust/docker-magento

# Create a "magento" network if it doesn't exist yet
docker network ls | grep -q " magento " || docker network create --driver bridge magento --subnet 172.20.0.0/16

# Kill the existing container
docker ps | grep -q php && docker stop php
sleep 1

mkdir -p ${root}/magento/source/pub

# Run a new container
docker run \
    --name=php \
    --rm \
    -d \
    -p 9000:9000 \
    -v ${root}/magento/source:/var/www/html \
    -v ${root}/common/conf/hosts:/etc/hosts \
    --net=magento \
    --ip=172.20.0.100 \
    $image

sleep 1
docker ps | grep -q php || echo "PHP-FPM failed to start"

