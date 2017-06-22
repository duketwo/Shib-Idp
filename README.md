Shib-Idp
===============
<img src="http://aegisidentity.com/identity-software/wp-content/uploads/shib_square.jpg" width="300"/>


## Installation

#### Requirements

1. Any docker supported OS which is able to run Linux-based Docker containers (https://docs.docker.com/engine/installation/linux/debian/)
2. Docker-Compose (https://docs.docker.com/compose/install/)
3. Git(https://www.digitalocean.com/community/tutorials/how-to-install-git-on-debian-8)

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



## License

[MIT](LICENSE)
