#!/bin/bash

# Define the root of this project
script=`readlink -f $BASH_SOURCE`
scriptFolder=`dirname $script`
root=`dirname $scriptFolder`

${root}/bin/docker_php.sh
${root}/bin/docker_nginx.sh
${root}/bin/docker_mysql.sh
${root}/bin/docker_redis.sh
${root}/bin/docker_varnish.sh
${root}/bin/docker_elasticsearch.sh
