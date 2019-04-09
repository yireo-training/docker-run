#!/bin/bash
MAGENTO_BASE_URL=http://magento.local
MAGENTO_ADMIN_FIRSTNAME=Jisse
MAGENTO_ADMIN_LASTNAME=Reitsma
MAGENTO_ADMIN_USERNAME=jisse@yireo.com
MAGENTO_ADMIN_EMAIL=jisse@yireo.com
MAGENTO_ADMIN_PASSWORD="P@ssword1234"
MYSQL_DB=magento2

username=`id -u -n`
if [[ "$username" != "www-data" ]] ; then
    echo "This script should be run as user 'www-data'"
    exit
fi

cd /var/www/html

composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition .

if [ ! -f bin/magento ] ; then 
    echo "Magento not installed";
    exit
fi

bin/magento setup:install --base-url=${MAGENTO_BASE_URL} \
--db-host=mysql --db-name=${MYSQL_DB} \
--db-user=root --db-password=root \
--admin-firstname=${MAGENTO_ADMIN_FIRSTNAME} --admin-lastname=${MAGENTO_ADMIN_LASTNAME} \
--admin-email=${MAGENTO_ADMIN_EMAIL} \
--admin-user=${MAGENTO_ADMIN_USERNAME} --admin-password=${MAGENTO_ADMIN_PASSWORD} \
--backend-frontname=admin --language=en_US \
--currency=USD --timezone=Europe/Amsterdam --cleanup-database \
--sales-order-increment-prefix="ORD$" --session-save=db \
--use-rewrites=1

bin/magento deploy:mode:set developer
bin/magento cache:disable full_page

mkdir -p var/composer_home
test -f ~/.composer/auth.json && cp ~/.composer/auth.json var/composer_home/auth.json

bin/magento sampledata:deploy
bin/magento setup:upgrade

magerun2 sys:check
magerun2 sys:info
magerun2 sys:url:list
