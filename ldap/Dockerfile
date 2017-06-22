FROM debian:jessie

ENV OPENLDAP_VERSION 2.4.40

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
        slapd=${OPENLDAP_VERSION}* && apt-get install nano supervisor -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mv /etc/ldap /etc/ldap.dist

COPY modules/ /etc/ldap.dist/modules

COPY entrypoint.sh /entrypoint.sh

RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN chmod +x /entrypoint.sh

EXPOSE 389

VOLUME ["/etc/ldap", "/var/lib/ldap"]

#ENTRYPOINT ["/entrypoint.sh"]

#CMD ["slapd", "-d", "32768", "-u", "openldap", "-g", "openldap"]
CMD ["/usr/bin/supervisord"]
