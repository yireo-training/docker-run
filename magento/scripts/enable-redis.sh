#!/bin/bash
bin/magento setup:config:set --cache-backend=redis --cache-backend-redis-server=redis_local --cache-backend-redis-db=0 -n
bin/magento setup:config:set --page-cache=redis --page-cache-redis-server=redis_local --page-cache-redis-db=1 -n
bin/magento cache:disable full_page
bin/magento cache:flush
