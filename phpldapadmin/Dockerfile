FROM debian:jessie

ENV NGINX_VERSION 1.6.2
ENV PHP_VERSION 5.6.30
ENV PHPLDAPADMIN_VERSION 1.2.2

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
        ca-certificates \
        nginx=${NGINX_VERSION}* \
        php5-fpm=${PHP_VERSION}* && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log && \
    ln -sf /dev/stderr /var/log/php-fpm.log

RUN rm -rf /var/www/

COPY nginx.conf /etc/nginx/

COPY default.conf /etc/nginx/conf.d/

COPY www.conf /etc/php5/fpm/pool.d/

EXPOSE 80

COPY run.sh /

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
        phpldapadmin=${PHPLDAPADMIN_VERSION}* && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
	
	RUN ln -sf /usr/share/phpldapadmin /var/www

RUN mv /var/www/config/config.php.example /var/www/config/config.php

COPY default.conf /etc/nginx/conf.d/

COPY www.conf /etc/php5/fpm/pool.d/

COPY bootstrap.sh /

RUN chmod +x /run.sh
RUN chmod +x /bootstrap.sh

ENTRYPOINT ["/bootstrap.sh"]

CMD ["/run.sh"]