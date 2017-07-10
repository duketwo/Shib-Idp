#!/bin/sh
rm -r ./config/idp
rm -r ./config/ldap
rm -r ./config/mysql
rm ./docker-compose.yml
cp ./defaultconf/docker-compose.yml.default ./docker-compose.yml
rm ./haproxy/haproxy.cfg
cp ./defaultconf/haproxy.cfg.default ./haproxy/haproxy.cfg
docker-compose run --rm -v "$(pwd)/config/idp:/ext-mount" idp init-idp.sh
rm ./config/idp/conf/ldap.properties
cp ./defaultconf/ldap.properties.default ./config/idp/conf/ldap.properties
