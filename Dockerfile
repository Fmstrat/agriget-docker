FROM php:apache

ENV DEBIAN_FRONTEND noninteractive

# Install packages
RUN apt-get update
RUN apt-get install -y pkg-config
RUN apt-get install -y \
	libfreetype6-dev \
	libjpeg62-turbo-dev \
	libpng-dev \
	libpq-dev \
	libicu-dev \
	libldap2-dev \
	supervisor \
	unzip
RUN apt-get clean -y
RUN apt-get purge -y
RUN docker-php-ext-install -j$(nproc) gd mysqli pdo_mysql pgsql pdo_pgsql opcache pcntl iconv mysqli intl ldap

# Secure PHP
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Install Agriget
RUN curl -o /tmp/agriget.zip -L https://github.com/Fmstrat/agriget/archive/master.zip
RUN unzip -d /var/www/html /tmp/agriget.zip
RUN mv /var/www/html/agriget-master/* /var/www/html
RUN touch /var/www/html/docker
RUN rm -rf /var/www/html/agriget-master
RUN rm -f /tmp/agriget.zip

# Link PHP for hard-coded path in updates
RUN ln -sf /usr/local/bin/php /usr/bin/php

# Create supervisord config
ADD supervisord.conf /etc/supervisor/conf.d/agriget.conf

# Expose ports and volumes
EXPOSE 80 443
VOLUME /data

# Add update script
ADD update.sh /update.sh
RUN chmod 755 /update.sh

CMD /usr/bin/supervisord
