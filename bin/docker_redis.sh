#!/bin/bash

# Define the root of this project
script=`readlink -f $BASH_SOURCE`
scriptFolder=`dirname $script`
root=`dirname $scriptFolder`

# Create a "magento" network if it doesn't exist yet
docker network ls | grep " magento " || docker network create --driver bridge magento --subnet 172.20.0.0/16

# Kill the existing container
docker ps | grep -q redis && docker stop redis
sleep 1

# Run a new container
docker run \
    --name=redis \
    --rm \
    -d \
    --net=magento \
    --ip=172.20.0.103 \
    torusware/speedus-redis

