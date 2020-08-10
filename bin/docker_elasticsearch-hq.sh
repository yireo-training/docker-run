#!/bin/bash

# Define the root of this project
script=`readlink -f $BASH_SOURCE`
scriptFolder=`dirname $script`
root=`dirname $scriptFolder`

# Create a "magento" network if it doesn't exist yet
docker network ls | grep -q " magento " || docker network create --driver bridge magento --subnet 172.20.0.0/16

# Kill the existing container
docker ps | grep -q elasticsearch-hq-yr && docker stop elasticsearch-hq-yr
sleep 1

# Run a new container
docker run \
    --name=elasticsearch-hq-yr \
    --rm -it -d \
    -p 5000:5000 \
    --net=magento \
    --ip=172.20.0.110 \
    --tmpfs /tmp:rw \
    elastichq/elasticsearch-hq

sleep 1
docker ps | grep -q elasticsearch-hq-yr || echo "Elastic HQ failed to start"

