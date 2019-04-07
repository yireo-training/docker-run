#!/bin/bash

# Define the root of this project
script=`readlink -f $BASH_SOURCE`
scriptFolder=`dirname $script`
root=`dirname $scriptFolder`

# Create a "magento" network if it doesn't exist yet
docker network ls | grep -q " magento " || docker network create --driver bridge magento --subnet 172.20.0.0/16

# Kill the existing container
docker ps | grep -q elasticsearch_local && docker stop elasticsearch_local
sleep 1

# Run a new container
docker run \
    --name=elasticsearch_local \
    --rm \
    -d \
    -p 9200:9200 \
    -p 9300:9300 \
    -e "discovery.type=single-node" \
    --cpus=1 \
    --net=magento \
    --ip=172.20.0.105 \
    elasticsearch:5

sleep 1
docker ps | grep -q elasticsearch_local || echo "ElasticSearch failed to start"

