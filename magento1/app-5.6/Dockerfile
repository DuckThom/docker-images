FROM php:5.6-apache

# Dependencies
RUN apt-get update && apt-get install --no-install-recommends -y \
        zlib1g-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        libxml2-dev \
        wget ssmtp

# PHP extensions
RUN pecl install xdebug-2.3.3
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

# Apache config
RUN rm -rf /etc/apache2/sites-enabled/000-default.conf
COPY ./apache.conf /etc/apache2/sites-available/
RUN ln -s /etc/apache2/sites-available/apache.conf /etc/apache2/sites-enabled/
RUN a2enmod rewrite

# Magerun
RUN wget https://files.magerun.net/n98-magerun.phar \
    && chmod +x n98-magerun.phar \
    && mv n98-magerun.phar /usr/local/bin/magerun

# Configuration
COPY xdebug.ini /usr/local/etc/php/conf.d
COPY php.ini /usr/local/etc/php/
COPY ssmtp.conf /etc/ssmtp/ssmtp.conf

RUN usermod -u 1000 www-data
