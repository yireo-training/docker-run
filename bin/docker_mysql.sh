#!/bin/bash

# Define the root of this project
script=`readlink -f $BASH_SOURCE`
scriptFolder=`dirname $script`
root=`dirname $scriptFolder`

# Create a "magento" network if it doesn't exist yet
docker network ls | grep " magento " || docker network create --driver bridge magento --subnet 172.20.0.0/16

# Kill the existing container
docker ps | grep -q mysql && docker stop mysql
sleep 1

mkdir -p ${root}/mysql/lib
mkdir -p ${root}/mysql/dumps

# Run a new container
docker run \
    --name=mysql \
    --rm \
    -d \
    -p 3306 \
    -e MYSQL_ROOT_PASSWORD=root \
    -e MYSQL_DATABASE=magento2 \
    -e MYSQL_SQL_TO_RUN='GRANT ALL ON *.* TO "root"@"%";' \
    -v ${root}/mysql/lib:/var/lib/mysql \
    -v ${root}/mysql/dumps:/dumps \
    -v ${root}/mysql/scripts:/scripts \
    --cpus=4 \
    --net=magento \
    --ip=172.20.0.102 \
    mysql:5.7

sleep 1
docker ps | grep -q mysql || echo "MySQL failed to start"
