#!/bin/bash
set -e
first_run=true

if [[ -f "/ldap_populated" ]]; then 
    first_run=false
fi

# Wait until 'LDAP started and listens on port 389'.
while [ -z "`netstat -tln | grep 389`" ]; do
  echo 'Waiting for PostgreSQL to start ...'
  sleep 1
done
echo 'LDAP started.'

if [[ "$first_run" == "true" ]]; then
	echo "Loading prepopulate data."
	if [[ -d "/etc/ldap/prepopulate" ]]; then 
		for file in `ls /etc/ldap/prepopulate/*.ldif`; do
			ldapadd -x -D cn=admin,dc=shib -w toor -f "$file"
		done
	fi
	touch /ldap_populated
fi
