#!/bin/bash

# Configuration
#
# Determine whether to run MySQL in a shared physical folder or tmpfs:
# - tmpfs: Additional performance but without persistant state;
# - Physical folder: Less performance but with persistant state;
tmpfs=1

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

if [ $tmpfs -eq 1 ] ; then
    mysql_storage="--tmpfs /var/lib/mysql:rw"
else
    mysql_storage="-v ${root}/mysql/lib:/var/lib/mysql"
fi

# Run a new container
docker run \
    --name=mysql \
    --rm \
    -d \
    -p 3306 \
    -e MYSQL_ROOT_PASSWORD=root \
    -e MYSQL_DATABASE=magento2 \
    -e MYSQL_SQL_TO_RUN='GRANT ALL ON *.* TO "root"@"%";' \
    $mysql_storage \
    --tmpfs /tmp:rw \
    -v ${root}/mysql/dumps:/dumps \
    -v ${root}/mysql/conf/custom.conf:/etc/mysql/conf.d/custom.conf \
    -v ${root}/mysql/scripts:/scripts \
    --cpus=4 \
    --net=magento \
    --ip=172.20.0.102 \
    mysql:5.7

sleep 1
docker ps | grep -q mysql || echo "MySQL failed to start"

sleep 1
docker exec -it mysql bash -c "test -f /scripts/mysql-import.sh && /scripts/mysql-import.sh"

