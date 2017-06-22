Shib-Idp
===============
<img src="http://aegisidentity.com/identity-software/wp-content/uploads/shib_square.jpg" width="300"/>


## Installation

#### Requirements

1. Any docker supported OS which is capable of running Linux-based Docker containers 
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
0. chmod +x ./init.sh
   Ausführen von: ./init.sh

1. Initiale Konfiguration erstellen:
	cd ./config/idp	
	docker-compose build
	docker run -it -v $(pwd):/ext-mount --rm idp_idp  init-idp.sh
	Backchannel + Cookie Passwort notieren!
	
2. Docker-compose Umgebungsvariablen anpassen:
	JETTY_BACKCHANNEL_SSL_KEYSTORE_PASSWORD: <Backchannel-Passwort aus Schritt 1>
	
4. ldap.properties, idp.properties konfigurieren

5. Metadatenprovider hinzufügen
	a) Lokaler datei:
		<MetadataProvider id="sp-lr.shib"  xsi:type="FilesystemMetadataProvider" metadataFile="%{idp.home}/metadata/sp-metadata.xml"/>
		
	b) Remote via HTTPS:
		

6. Attribute resolver konfigurieren
7. Attribute filter konfigurieren

## Cheatsheet
Letsencrypt cert -> p12: 
	openssl pkcs12 -export -out idp-browser.p12 -inkey privkey.pem -in cert.pem -certfile chain.pem
	
Letsencrypt cert -> haproxy pem: 
	cd haproxy/certs
	DOMAIN='yourdomain.net' bash -c 'cat /etc/letsencrypt/live/$DOMAIN/fullchain.pem /etc/letsencrypt/live/$DOMAIN/privkey.pem > $DOMAIN.pem'
	chmod -R go-rwx .
	
LDAP credentials:
	LDAP user: cn=admin,dc=shib
	LDAP pw: toor
	
Selbst signiertes TLS-Zertifikat erstellen -> p12
	cd ./config/idp/credentials
	#openssl genrsa -aes128 -out jetty.key
	#openssl req -new -x509 -newkey rsa:2048 -sha256 -key jetty.key -out jetty.crt
	openssl req  -nodes -new -x509  -keyout jetty.key -out jetty.crt
	openssl pkcs12 -passout pass: -inkey jetty.key -in jetty.crt -export -out idp-browser.p12

## References used
https://github.com/dinkel/docker-openldap
</br>https://github.com/dinkel/docker-phpldapadmin
</br>https://github.com/Unicon/shibboleth-idp-dockerized

## License

[MIT](LICENSE)
