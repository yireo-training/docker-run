#!/bin/bash

# Define the root of this project
script=`readlink -f $BASH_SOURCE`
scriptFolder=`dirname $script`
root=`dirname $scriptFolder`

# Create a "magento" network if it doesn't exist yet
docker network ls | grep -q " magento " || docker network create --driver bridge magento --subnet 172.20.0.0/16

# Kill the existing container
docker ps | grep -q nginx && docker stop nginx
sleep 1

# Run a new container
docker run \
    --name=nginx \
    --rm -d -it \
    --cpus=1 \
    -v ${root}/magento/source:/var/www/html \
    -v ${root}/nginx/conf/magento.conf:/etc/nginx/conf.d/default.conf \
    -v ${root}/nginx/conf/include.conf:/etc/nginx/include.d/magento-include.conf \
    -v ${root}/nginx/scripts:/scripts \
    -v ${root}/common/conf/hosts:/etc/hosts \
    --net=magento \
    --ip=172.20.0.101 \
    nginx

sleep 1
docker ps | grep -q nginx || echo "Nginx failed to start"

