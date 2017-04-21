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
cp conf/{attribute-resolver.xml,attribute-filter.xml,cas-protocol.xml,idp.properties,ldap.properties,metadata-providers.xml,relying-party.xml,saml-nameid.xml} /ext-mount/conf/

cp -r views/ /ext-mount/
mkdir /ext-mount/webapp/
cp -r webapp/css/ /ext-mount/webapp/
cp -r webapp/images/ /ext-mount/webapp/
cp -r webapp/js/ /ext-mount/webapp/
rm -r /ext-mount/views/user-prefs.js

echo "A basic Shibboleth IdP config and UI has been copied to ./(assuming the default volume mapping was used)."
echo "Most files, if not being customized can be removed from what was exported/the local Docker image and baseline files will be used."
