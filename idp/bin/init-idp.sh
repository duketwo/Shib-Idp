#!/bin/bash

export JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")
export PATH=$PATH:$JAVA_HOME/bin

cd /opt/shibboleth-idp/bin

rm -r ../conf/

echo "Please complete the following for your IdP environment:"
./build.sh -Didp.target.dir=/opt/shibboleth-idp init gethostname askscope metadata-gen

mkdir -p /ext-mount/conf/

cd ..
cp -r credentials/ /ext-mount/
cp -r metadata/ /ext-mount/
cp conf/{attribute-resolver.xml,attribute-filter.xml,cas-protocol.xml,idp.properties,ldap.properties,metadata-providers.xml,relying-party.xml,saml-nameid.xml,global.xml} /ext-mount/conf/
cp -r conf/intercept /ext-mount/conf/intercept

cp -r views/ /ext-mount/
mkdir /ext-mount/webapp/
cp -r webapp/css/ /ext-mount/webapp/
cp -r webapp/images/ /ext-mount/webapp/
cp -r webapp/js/ /ext-mount/webapp/
rm -r /ext-mount/views/user-prefs.js

echo "A self signed certificate for the browser will now be created: "

openssl req  -nodes -new -x509  -keyout /ext-mount/credentials/idp-browser.key -out /ext-mount/credentials/idp-browser.crt
openssl pkcs12 -passout pass: -inkey /ext-mount/credentials/idp-browser.key -in /ext-mount/credentials/idp-browser.crt -export -out /ext-mount/credentials/idp-browser.p12

echo "A basic Shibboleth IdP config and UI has been created and copied to ./config/idp"
echo "Content of ./config/idp will be copied into the container while launching."
