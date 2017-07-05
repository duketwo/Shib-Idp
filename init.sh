#!/bin/sh
rm -r ./config/idp
rm -r ./config/ldap
rm ./docker-compose.yml
cp ./docker-compose.yml.default ./docker-compose.yml
rm ./haproxy/haproxy.cfg
cp ./haproxy/haproxy.cfg.default ./haproxy/haproxy.cfg
