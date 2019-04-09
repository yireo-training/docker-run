# docker-run
Sample Docker scripts to run a Magento 2 stack:
- PHP-FPM
- Nginx
- MySQL
- Redis
- Varnish
- ElasticSearch

## About this project
This repositories lists various Docker images that can be used to run a stack of local containers, to run Magento 2 on. The various scripts are meant to run manually, but with little configuration. Please note that advanced Docker users might debate that this approach is wrong and that `docker-compose` is better. In a way, they are right, but this repository is therefore part of the Yireo Education project and meant for educational purpose. And you can also use it for your own development.

## Using this stack
Make sure you have a `/etc/hosts` file that lists the IP addresses of the various Docker containers, as they are listed in the file `common/conf/hosts`.

Next, start up the various containers using scripts in the `bin` folder. As a bare minimum, you will need the following images:
- PHP-FPM
- Nginx
- MySQL

Once these images are up, the PHP image contains a `/scripts` folder with a sample script to install Magento 2. Probably, you want to modify this script, at least the backend user.

You can also run all containers using `bin/docker_all_start.sh`.

## Performance optimizations
- MySQL ships with a couple configuration directives to make it faster;
- MySQL adds its `/var/lib/mysql` folder to memory (tmpfs). Make sure to use the
  dump-script if you want to persist your database;
