FROM php:7.2-apache

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    libxml2-dev \
    libsqlite3-dev \
    libssl-dev \
    ssmtp

ADD php.ini /usr/local/etc/php/
RUN docker-php-ext-install \
    mbstring \
    exif \
    pdo_mysql \
    fileinfo \
    soap \
    ftp

# SSMTP config
ADD ./ssmtp.conf /etc/ssmtp/ssmtp.conf

RUN pecl install xdebug
ADD xdebug.ini /usr/local/etc/php/conf.d

# Apache configuration
RUN rm -rf /etc/apache2/sites-enabled/000-default.conf
ADD ./apache.conf /etc/apache2/sites-available/
RUN ln -s /etc/apache2/sites-available/apache.conf /etc/apache2/sites-enabled/
RUN touch /etc/apache2/custom-global.conf
RUN touch /etc/apache2/custom-vhost.conf
RUN a2enmod rewrite

RUN usermod -u 1000 www-data

RUN ln -s /var/www/html/artisan /usr/local/bin/artisan