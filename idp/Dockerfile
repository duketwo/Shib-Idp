FROM debian:latest
	
#
# Umgebungsvariablen setzen
#
	ENV jetty_version 9.3.16.v20170120
	ENV jetty_hash f007648daa13799554a95c5ec31d44deac7e56b8
	ENV idp_version 3.3.1
	ENV idp_hash 8bd852dcdc7e6729ee645c0374a3c476b152fa24506fb86ffec33dfd190e607c
	ENV dta_hash 2f547074b06952b94c35631398f36746820a7697
	
	ENV JETTY_HOME=/opt/jetty-home \
    JETTY_BASE=/opt/shib-jetty-base \
    JETTY_MAX_HEAP=2048m \
    JETTY_BROWSER_SSL_KEYSTORE_PASSWORD=changeme \
    JETTY_BACKCHANNEL_SSL_KEYSTORE_PASSWORD=changeme

# Debug
	RUN set -x;

#
# Zulu OpenJDK binaries von offiziellem Repo installieren
#
	RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0x219BD9C9
	RUN echo "deb http://repos.azulsystems.com/debian stable  main" >> /etc/apt/sources.list.d/zulu.list
	RUN apt-get -qq update
	RUN apt-get -y install zulu-8 wget tar nano


#
# Jetty installieren und hash verfizieren
#
	RUN cd / \
		&& wget http://central.maven.org/maven2/org/eclipse/jetty/jetty-distribution/$jetty_version/jetty-distribution-$jetty_version.tar.gz \
		&& echo "$jetty_hash  jetty-distribution-$jetty_version.tar.gz" | sha1sum -c - \
		&& tar -zxvf jetty-distribution-$jetty_version.tar.gz -C /opt \
		&& rm jetty-distribution-$jetty_version.tar.gz \
		&& ln -s /opt/jetty-distribution-$jetty_version/ /opt/jetty-home
	
#
# Jetty konfigurieren
#
	RUN cd / \
		&& cp /opt/jetty-home/bin/jetty.sh /etc/init.d/jetty \
		&& mkdir -p /opt/shib-jetty-base/modules /opt/shib-jetty-base/lib/ext /opt/shib-jetty-base/resources \
		&& cd /opt/shib-jetty-base \
		&& touch start.ini \
		&& java -jar ../jetty-home/start.jar --add-to-startd=http,https,deploy,ext,annotations,jstl
	
#
# Jetty SSL/SOAP Plugin installieren und hash verfizieren
#

	RUN cd / \
		&& wget https://build.shibboleth.net/nexus/content/repositories/releases/net/shibboleth/utilities/jetty9/jetty9-dta-ssl/1.0.0/jetty9-dta-ssl-1.0.0.jar \
		&& echo "$dta_hash  jetty9-dta-ssl-1.0.0.jar" | sha1sum -c - \
		&& mv jetty9-dta-ssl-1.0.0.jar /opt/shib-jetty-base/lib/ext/
	
#
# Shibboleth Idp installieren und hash verifizieren
#

	RUN cd / \
		&& wget https://shibboleth.net/downloads/identity-provider/$idp_version/shibboleth-identity-provider-$idp_version.tar.gz \
		&& echo "$idp_hash  shibboleth-identity-provider-$idp_version.tar.gz" | sha256sum -c - \
		&& tar -zxvf  shibboleth-identity-provider-$idp_version.tar.gz -C /opt \
		&& rm /shibboleth-identity-provider-$idp_version.tar.gz \
		&& ln -s /opt/shibboleth-identity-provider-$idp_version/ /opt/shibboleth-idp

#
# Jetty user hinzufügen mit /bin/false bash, gruppe = jetty
#

	RUN useradd jetty -U -s /bin/false

#
# Owner und Rechte setzen
#

	RUN chown -R root:jetty /opt \
		&& chmod -R 640 /opt

#
# Konfiguration in Container kopieren
#

	COPY bin/ /usr/local/bin/
	COPY opt/shib-jetty-base/ /opt/shib-jetty-base/
	COPY opt/shibboleth-idp/ /opt/shibboleth-idp/
	
#
# Owner und Rechte setzen von Konfigurationsdateien
#
	RUN mkdir /opt/shib-jetty-base/logs \
		&& chown -R root:jetty /opt/shib-jetty-base \
		&& chmod -R 640 /opt/shib-jetty-base \
		&& chmod -R 750 /opt/shibboleth-idp/bin \
		&& chmod 750 /usr/local/bin/run-jetty.sh /usr/local/bin/init-idp.sh
		
# Expose 4443 (One-way TLS) und 8443 (Two-way TLS)
EXPOSE 4443 8443

CMD ["run-jetty.sh"]	