#!/bin/sh

set -x
export JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")
export PATH=$PATH:$JAVA_HOME/bin

if [ -d /external-mount/conf/ ];
then
	echo "Importing config."
	if [ -d /external-mount/conf/ ];
	then
		echo "Updading the Shibboleth IdP conf."
		cp -R /external-mount/conf/ /opt/shibboleth-idp/
	fi

	if [ -d /external-mount/credentials/ ];
	then
		echo "Updating the Shibboleth credentials."
		cp -R /external-mount/credentials/ /opt/shibboleth-idp/
	fi

	if [ -d /external-mount/metadata/ ];
	then
		echo "Updating the Shibboleth metadata."
		cp -R /external-mount/metadata/ /opt/shibboleth-idp/
	fi

	if [ -d /external-mount/webapp/ ];
	then
		echo "Updating the Shibboleth webapp artifacts."
		cp -R /external-mount/webapp/ /opt/shibboleth-idp/
		
			if [ -d /external-mount/views/ ];
			then
				echo "Updating the Shibboleth webapp artifacts."
				cp -R /external-mount/views/ /opt/shibboleth-idp/
			fi

		echo "Rebuilding the idp.war file"
		cd /opt/shibboleth-idp
		bin/build.sh
	fi

	if [ -d /external-mount/keystore ];
	then
		echo "Updating the Jetty keystore."
		cp /external-mount/keystore /opt/iam-jetty-base/etc/keystore
	fi
else 
	echo "No configuration found please create a configuration and add the volume mount accordingly."
	exit 1
fi

export JETTY_ARGS="jetty.sslContext.keyStorePassword=$JETTY_BROWSER_SSL_KEYSTORE_PASSWORD jetty.backchannel.sslContext.keyStorePassword=$JETTY_BACKCHANNEL_SSL_KEYSTORE_PASSWORD"
sed -i "s/^-Xmx.*$/-Xmx$JETTY_MAX_HEAP/g" /opt/shib-jetty-base/start.ini

exec /etc/init.d/jetty run
