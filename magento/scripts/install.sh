#!/bin/bash
su - www-data

cd /var/www/html

composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition .

bin/magento setup:install --base-url=http://magento.local \
--db-host=172.20.0.102 --db-name=magento2 \
--db-user=root --db-password=root \
--admin-firstname=Jisse --admin-lastname=Reitsma \
--admin-email=jisse@yireo.com \
--admin-user=jisse@yireo.com --admin-password=P@ssword1234 \
--backend-frontname=admin --language=en_US \
--currency=USD --timezone=Europe/Amsterdam --cleanup-database \
--sales-order-increment-prefix="ORD$" --session-save=db \
--use-rewrites=1

bin/magento deploy:mode:set developer
bin/magento cache:disable full_page

mkdir -p var/composer_home
test -f /root/.composer/auth.json && \
    cp /root/.composer/auth.json var/composer_home/auth.json
bin/magento sampledata:deploy
bin/magento setup:upgrade

curl -sS -O https://files.magerun.net/n98-magerun2.phar
chmod +x ./n98-magerun2.phar
mv n98-magerun2.phar /usr/local/bin/magerun2
magerun2 sys:check
