Shib-Idp
===============
<img src="http://aegisidentity.com/identity-software/wp-content/uploads/shib_square.jpg" width="300"/>


## Installation

#### Requirements

1. Any Docker supported OS which is capable of running Linux-based Docker containers 
</br>(https://docs.docker.com/engine/installation/linux/debian/)
2. Docker-Compose
</br>(https://docs.docker.com/compose/install/)
3. Git
</br>(https://www.digitalocean.com/community/tutorials/how-to-install-git-on-debian-8)

## Features
 - Jetty as Servlet/JSP-Container und Webserver for Shibboleth
 - HAProxy as proxy middlware including SSL offloading
 - phpLDAPadmin to administrate the LDAP database
 - OpenLDAP as directory service for Shibbleth
 - Shibbleth IdP provides Single Sign-On services 

## How to use
1. Execute init.sh: ```chmod +x ./init.sh && ./init.sh```

2. Create initial base configuration:
	</br>```cd ./config/idp```
	</br>```docker-compose build```
	</br>```docker run -it -v $(pwd):/ext-mount --rm idp_idp  init-idp.sh```
	</br>Create a note of the backchannel and cookie password!
	
3. Edit docker-compose environment variables:
	</br>```JETTY_BACKCHANNEL_SSL_KEYSTORE_PASSWORD: <Backchannel-Passwort from step 1>```
	
4. Configure ldap.properties, idp.properties

5. Add metadata providers:
<br/>5.1. From local file:
<br/><MetadataProvider id="sp-lr.shib"  xsi:type="FilesystemMetadataProvider" metadataFile="%{idp.home}/metadata/sp-metadata.xml"/>
<br/>5.2. Remote via HTTPS:
<br/>	

6. Configure attribute resolver
7. Configure attribute filter

## Cheatsheet
1. Letsencrypt cert conversion to p12 format: 
	</br>```openssl pkcs12 -export -out idp-browser.p12 -inkey privkey.pem -in cert.pem -certfile chain.pem```
	
2. Letsencrypt cert conversion to haproxy pem: 
	</br>```cd haproxy/certs```
	</br>```DOMAIN='yourdomain.net' bash -c 'cat /etc/letsencrypt/live/$DOMAIN/fullchain.pem /etc/letsencrypt/live/$DOMAIN/privkey.pem > $DOMAIN.pem'```
	</br>```chmod -R go-rwx .```

3. LDAP credentials:
	</br>```LDAP user: cn=admin,dc=shib```
	</br>```LDAP pw: toor```
	
4. Create selfsigned TLS cert and convert to p12 format:
	</br>```cd ./config/idp/credentials```
	</br>```openssl req  -nodes -new -x509  -keyout jetty.key -out jetty.crt```
	</br>```openssl pkcs12 -passout pass: -inkey jetty.key -in jetty.crt -export -out idp-browser.p12```

## References used
https://github.com/dinkel/docker-openldap
</br>https://github.com/dinkel/docker-phpldapadmin
</br>https://github.com/Unicon/shibboleth-idp-dockerized

## License

[MIT](LICENSE)
