#!/bin/bash
test -f /dumps/magento2.sql && mysql --user=root --password=root magento2 < /dumps/magento2.sql
