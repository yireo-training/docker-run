#!/bin/bash

# Define the root of this project
script=`readlink -f $BASH_SOURCE`
scriptFolder=`dirname $script`
root=`dirname $scriptFolder`

vclFile=$1
if [ -z "$vclFile" ] ; then
    vclFile=${root}/varnish/conf/varnish.vcl
fi

if [ ! -f "$vclFile" ] ; then
    echo "VCL file $vclFile not found\n"
    exit
fi

echo "Using $vclFile"

# Create a "magento" network if it doesn't exist yet
docker network ls | grep -q " magento " || docker network create --driver bridge magento --subnet 172.20.0.0/16

# Kill the existing container
docker ps | grep -q varnish-yr && docker stop varnish-yr
sleep 1

# Run a new container
docker run \
    --name=varnish-yr \
    --rm -it -d \
    -v ${vclFile}:/etc/varnish/default.vcl \
    -v ${root}/common/conf/hosts:/etc/hosts \
    --net=magento \
    --ip=172.20.0.104 \
    varnish:6

sleep 2
docker ps | grep -q varnish-yr || echo "Varnish failed to start"

