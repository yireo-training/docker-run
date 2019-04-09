#!/bin/bash
docker exec -it php /bin/bash -c "/scripts/install-magento-as-root.sh"
docker exec -it mysql /bin/bash -c "/scripts/mysql-dump.sh"
