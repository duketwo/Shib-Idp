#!/bin/sh
rm -r ./config/idp
rm -r ./config/ldap
rm ./docker-compose.yml
cp ./docker-compose.yml.example ./docker-compose.yml
rm ./haproxy/haproxy.cfg
cp ./haproxy/haproxy.cfg.example ./haproxy/haproxy.cfg