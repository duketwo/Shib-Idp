Shib-Idp
===============
<img src="http://aegisidentity.com/identity-software/wp-content/uploads/shib_square.jpg" width="300"/>


## Installation

#### Requirements

1. Any Docker supported OS which is capable of running Linux-based Docker containers
2. Docker
</br>(https://docs.docker.com/engine/installation/linux/debian/)
3. Docker-Compose
</br>(https://docs.docker.com/compose/install/)
4. Git
</br>(https://www.digitalocean.com/community/tutorials/how-to-install-git-on-debian-8)

## Featuring
 - Jetty as Servlet/JSP-Container und Webserver for Shibboleth
 - phpLDAPadmin to administrate the LDAP directory
 - OpenLDAP as directory service for Shibboleth
 - Shibbleth IdP provides Single Sign-On services

## How to use

1. Create initial base configuration:
  </br>```chmod +x ./init.sh && ./init.sh```
	</br>Create a note of the backchannel and cookie password!

2. Edit docker-compose environment variables:
	</br>```JETTY_BACKCHANNEL_SSL_KEYSTORE_PASSWORD: <Backchannel-Passwort from step 1>```

3. Configure ./config/idp/conf/idp.properties file
</br>3.1. Set the IdP scope:
</br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;```# Set the scope used in the attribute resolver for scoped attributes```
</br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;```idp.scope= example.org```
</br>3.2. Configure trackSPSessions attribute to allow SLO (Single-Logout):
</br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;```# Track information about SPs logged into```
</br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;```idp.session.trackSPSessions = true```
4. Add metadata providers
<br/>
5. Set a AttributeFilterPolicy within the ./config/idp/conf/attribute-filter.xml file.
</br>
6. Configure attribute resolver
</br>
7. Configure attribute filter

## Cheatsheet
1. Letsencrypt cert conversion to p12 format:
	</br>```openssl pkcs12 -export -out idp-browser.p12 -inkey privkey.pem -in cert.pem -certfile chain.pem```

2. Letsencrypt cert conversion to HAProxy pem:
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

5. LDAP memberOf search example:
  </br>```(&(objectClass=*)(memberOf=cn=students,ou=groups,dc=shib))```
	</br>```(&(objectClass=*)(memberOf=cn=professors,ou=groups,dc=shib))```

6. Disable IdP Assertion encryption: (./config/idp/conf/relying-party.xml)
<br/>


## References used
https://github.com/dinkel/docker-openldap
</br>https://github.com/dinkel/docker-phpldapadmin
</br>https://github.com/Unicon/shibboleth-idp-dockerized

## XML listings

1.
```xml
    <util:list id="shibboleth.RelyingPartyOverrides">
        <!--
        Override example that identifies a single RP by name and configures it
        for SAML 2 SSO without encryption. This is a common "vendor" scenario.
        -->
        <bean parent="RelyingPartyByName" c:relyingPartyIds="https://sp.example-federation.us">
            <property name="profileConfigurations">
                <list>
                    <bean parent="SAML2.SSO" p:encryptAssertions="false" />
                </list>
            </property>
        </bean>
    </ut
```
	
2.
	
```xml
<AttributeFilterPolicy id="https://sp.example-federation.us">
  <PolicyRequirementRule xsi:type="Requester" value="https://sp.example-federation.us" />
  <AttributeRule attributeID="uid">
    <PermitValueRule xsi:type="ANY" />
  </AttributeRule>
  <AttributeRule attributeID="mail">
    <PermitValueRule xsi:type="ANY" />
  </AttributeRule>
  <AttributeRule attributeID="givenName">
    <PermitValueRule xsi:type="ANY" />
  </AttributeRule>
  <AttributeRule attributeID="surname">
    <PermitValueRule xsi:type="ANY" />
  </AttributeRule>
  <AttributeRule attributeID="eduPersonPrincipalName">
    <PermitValueRule xsi:type="ANY" />
  </AttributeRule>
  <AttributeRule attributeID="memberOf">
    <PermitValueRule xsi:type="ANY" />
  </AttributeRule>
  <AttributeRule attributeID="eduPersonAffiliation">
    <PermitValueRule xsi:type="ANY" />
  </AttributeRule>
</AttributeFilterPolicy>
```

## License

[MIT](LICENSE)
