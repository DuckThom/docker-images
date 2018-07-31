FROM php:5.5-apache

# Container dependencies
RUN apt-get update \
 && apt-get install --no-install-recommends -y \
    zlib1g-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng12-dev \
    libxml2-dev \
    wget

# PHP configuration
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

ADD docker-php-pecl-install /usr/local/bin
RUN docker-php-pecl-install xdebug-2.3.3
COPY xdebug.ini /usr/local/etc/php/conf.d
RUN echo "xdebug.remote_host=$(/sbin/ip route|awk '/default/ { print $3 }')" >> /usr/local/etc/php/conf.d/xdebug.ini

# Apache configuration
RUN rm -rf /etc/apache2/sites-enabled/000-default.conf
ADD ./apache.conf /etc/apache2/sites-available/
RUN ln -s /etc/apache2/sites-available/apache.conf /etc/apache2/sites-enabled/
RUN a2enmod rewrite

# Magerun
ENV MAGERUN_VERSION 1.97.30
RUN wget https://files.magerun.net/n98-magerun-$MAGERUN_VERSION.phar \
    && chmod +x n98-magerun-$MAGERUN_VERSION.phar \
    && mv n98-magerun-$MAGERUN_VERSION.phar /usr/local/bin/magerun

RUN usermod -u 1000 www-data

