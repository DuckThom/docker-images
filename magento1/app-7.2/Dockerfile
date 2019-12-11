FROM php:7.2-apache

# Container dependencies
RUN apt-get update \
 && apt-get install --no-install-recommends -y \
    zlib1g-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libwebp-dev \
    libxml2-dev \
    wget

# PHP configuration
ADD php.ini /usr/local/etc/php/
RUN docker-php-ext-configure \
    gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-webp-dir=/usr/include/ \
 && docker-php-ext-install \
    pdo_mysql \
    gd \
    soap \
    simplexml \
    exif \
    bcmath

RUN pecl install xdebug
ADD xdebug.ini /usr/local/etc/php/conf.d

# Apache configuration
RUN rm -rf /etc/apache2/sites-enabled/000-default.conf
ADD ./apache.conf /etc/apache2/sites-available/
RUN ln -s /etc/apache2/sites-available/apache.conf /etc/apache2/sites-enabled/
RUN touch /etc/apache2/custom-global.conf
RUN touch /etc/apache2/custom-vhost.conf
RUN a2enmod rewrite

# Magerun
ENV MAGERUN_VERSION 1.97.30
RUN wget https://files.magerun.net/n98-magerun-$MAGERUN_VERSION.phar \
    && chmod +x n98-magerun-$MAGERUN_VERSION.phar \
    && mv n98-magerun-$MAGERUN_VERSION.phar /usr/local/bin/magerun

# Blackfire
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

# Set www-data user id to 1000
RUN usermod -u 1000 www-data

# Magerun Magento Vulnerability Database plugin setup
RUN apt-get update \
 && apt-get install -y --no-install-recommends git
RUN mkdir -p /usr/local/share/n98-magerun/modules
RUN git clone https://github.com/gwillem/magevulndb.git /usr/local/share/n98-magerun/modules/magevulndb

# Install mysql for database access
RUN apt-get update \
 && apt-get install -y --no-install-recommends mariadb-client

# Install unzip for composer
RUN apt-get update \
 && apt-get install -y --no-install-recommends zip unzip

# Install composer
ENV COMPOSER_VERSION 1.8.4
RUN wget https://getcomposer.org/download/${COMPOSER_VERSION}/composer.phar \
 && mv composer.phar /tmp/composer.phar \
 && mkdir /var/www/.composer \
 && chmod +x /tmp/composer.phar \
 && ln -s /tmp/composer.phar /usr/local/bin/composer \
 && chown www-data:www-data /var/www/.composer

# Cleanup for smaller image
RUN apt-get autoremove --purge -y \
 && apt-get clean -y \
 && apt-get autoclean -y

 # Fix ctrl-left and ctrl-right shortcut
RUN echo "bind '\"\e[1;5C\":forward-word'" >> /etc/bash.bashrc
RUN echo "bind '\"\e[1;5D\":backward-word'" >> /etc/bash.bashrc

# Set a nice bash prompt
RUN echo "PS1='\[\033[0;32m\]\[\033[0m\033[0;32m\]\u\[\033[0;36m\] @ Docker container \[\033[0;36m\]\h \w\[\033[0;32m\]\n\[\033[0;32m\]└─\[\033[0m\033[0;32m\] \$\[\033[0m\033[0;32m\] ▶\[\033[0m\] '" >> /etc/bash.bashrc
