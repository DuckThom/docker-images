FROM php:5.5-apache

# Dependencies
RUN apt-get update && apt-get install --no-install-recommends -y \
        zlib1g-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
        libxml2-dev \
        wget ssmtp

# PHP extensions
ADD php.ini /usr/local/etc/php/
RUN docker-php-ext-configure \
    gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
 && docker-php-ext-install \
    pdo_mysql \
    mcrypt \
    gd \
    soap \
    simplexml \
    exif \
    bcmath

RUN pecl install xdebug-2.3.3
COPY xdebug.ini /usr/local/etc/php/conf.d

# Apache config
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

# SSMTP config
ADD ./ssmtp.conf /etc/ssmtp/ssmtp.conf

# Magerun Magento Vulnerability Database plugin setup
RUN apt-get install -y --no-install-recommends git
RUN mkdir -p /usr/local/share/n98-magerun/modules
RUN git clone https://github.com/gwillem/magevulndb.git /usr/local/share/n98-magerun/modules/magevulndb

# Cleanup for smaller image
RUN apt-get remove --purge -y git \
 && apt-get autoremove --purge -y \
 && apt-get clean -y \
 && apt-get autoclean -y

# Set www-data user id to 1000
RUN usermod -u 1000 www-data