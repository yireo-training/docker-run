#!/bin/bash

# Define the root of this project
script=`readlink -f $BASH_SOURCE`
scriptFolder=`dirname $script`
root=`dirname $scriptFolder`

# Create a "magento" network if it doesn't exist yet
docker network ls | grep -q " magento " || docker network create --driver bridge magento --subnet 172.20.0.0/16

# Kill the existing container
docker ps | grep -q varnish_local && docker stop varnish_local
sleep 1

# Run a new container
docker run \
    --name=varnish_local \
    --rm -d \
    -v ${root}/varnish/conf/varnish.vcl:/etc/varnish/default.vcl \
    -v ${root}/common/conf/hosts:/etc/hosts \
    --net=magento \
    --ip=172.20.0.104 \
    emgag/varnish:5

sleep 1
docker ps | grep -q varnish_local || echo "Varnish failed to start"
