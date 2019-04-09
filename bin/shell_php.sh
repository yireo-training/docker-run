#!/bin/bash
container=php
#container=docker-run_php_1
docker exec -it $container /bin/bash -c "su - www-data"
