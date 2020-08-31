#!/bin/bash

# Define the root of this project
script=`readlink -f $BASH_SOURCE`
scriptFolder=`dirname $script`
root=`dirname $scriptFolder`

# Create a "magento" network if it doesn't exist yet
docker network ls | grep -q " magento " || docker network create --driver bridge magento --subnet 172.20.0.0/16

# Kill the existing container
docker ps | grep -q elasticsearch-yr && docker stop elasticsearch-yr
sleep 1

# Run a new container
docker run \
    --name=elasticsearch-yr \
    --rm -it -d \
    -p 9200:9200 \
    -p 9300:9300 \
    -e "discovery.type=single-node" \
    -e "ES_JAVA_OPTS=-Xms256m -Xmx256m" \
    --cpus=1 \
    --net=magento \
    --ip=172.20.0.105 \
    --tmpfs /tmp:rw \
    elasticsearch:6.8.0

sleep 1
docker ps | grep -q elasticsearch-yr || echo "ElasticSearch failed to start"

