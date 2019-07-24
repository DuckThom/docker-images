FROM php:7.2-apache

MAINTAINER Thomas Wiringa <t.wiringa@youwe.nl>

# Install php module dependencies
RUN apt-get update -y \
 && apt-get install -y --no-install-recommends \
    libjpeg62-turbo-dev libpng-dev \
    libfreetype6-dev libfreetype6 \
    libbz2-dev \
    libmcrypt-dev \
    libicu-dev \
    libxslt-dev \
    libwebp-dev \
    libxml2-dev \
    libsodium-dev

# Install php modules
RUN docker-php-ext-configure gd \
    --with-jpeg-dir=/usr/lib/x86_64-linux-gnu/ --with-png-dir=/usr/lib/x86_64-linux-gnu/ --with-webp-dir=/usr/lib/x86_64-linux-gnu/ --with-freetype-dir=/usr/lib/x86_64-linux-gnu/ \
 && docker-php-ext-install \
    gd dom hash iconv intl pdo_mysql simplexml xsl bcmath soap zip ctype sodium pcntl

RUN usermod -u 1000 www-data

RUN chown -R www-data:www-data /var/www

ENV COMPOSER_DATE 2019-04-25

# Install composer
RUN apt-get install -y --no-install-recommends wget unzip
RUN wget https://getcomposer.org/composer.phar \
 && chmod +x composer.phar \
 && mv composer.phar /usr/local/bin/composer

ENV MAGERUN_DATE 2019-04-25

# Install Magerun2
RUN wget https://files.magerun.net/n98-magerun2.phar \
 && chmod +x n98-magerun2.phar \
 && mv n98-magerun2.phar /usr/local/bin/magerun

# Set php config file
ADD php.ini /usr/local/etc/php/

# Configure apache
RUN rm -rf /etc/apache2/sites-enabled/000-default.conf
ADD ./apache.conf /etc/apache2/sites-available/
RUN ln -s /etc/apache2/sites-available/apache.conf /etc/apache2/sites-enabled/
RUN a2enmod rewrite \
 && a2enmod headers

# Install git and ssh
RUN apt-get update \
 && apt-get install --no-install-recommends -y \
    git ssh

# Fix ctrl-left and ctrl-right shortcut
RUN echo "bind '\"\e[1;5C\":forward-word'" >> /etc/bash.bashrc
RUN echo "bind '\"\e[1;5D\":backward-word'" >> /etc/bash.bashrc

# Set a nice bash prompt
RUN echo "PS1='\[\033[0;32m\]\[\033[0m\033[0;32m\]\u\[\033[0;36m\] @ Docker container \[\033[0;36m\]\h \w\[\033[0;32m\]\n\[\033[0;32m\]└─\[\033[0m\033[0;32m\] \$\[\033[0m\033[0;32m\] ▶\[\033[0m\] '" >> /etc/bash.bashrc

# Install Blackfire
RUN version=$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;") \
    && curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/linux/amd64/$version \
    && mkdir -p /tmp/blackfire \
    && tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp/blackfire \
    && mv /tmp/blackfire/blackfire-*.so $(php -r "echo ini_get('extension_dir');")/blackfire.so \
    && printf "extension=blackfire.so\nblackfire.agent_socket=tcp://blackfire:8707\n" > $PHP_INI_DIR/conf.d/blackfire.ini \
    && rm -rf /tmp/blackfire /tmp/blackfire-probe.tar.gz

# Install MSMTP
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    msmtp
ADD ./msmtprc /etc/msmtprc

# Install a MySQL client
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    mariadb-client

# Install mod_pagespeed
#RUN wget https://dl-ssl.google.com/dl/linux/direct/mod-pagespeed-stable_current_amd64.deb \
# && dpkg -i mod-pagespeed-stable_current_amd64.deb \
# && apt-get install -f -y \
# && rm mod-pagespeed-stable_current_amd64.deb

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    cron nano

WORKDIR /var/www/html
