FROM php:7.1-apache

MAINTAINER Thomas Wiringa <t.wiringa@youwe.nl>

RUN apt-get update -y \
 && apt-get install -y --no-install-recommends \
    libfreetype6-dev libjpeg62-turbo-dev libpng-dev \
    libbz2-dev \
    libmcrypt-dev \
    libicu-dev \
    libxslt-dev \
    libxml2-dev

RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/

RUN docker-php-ext-install \
    bcmath bz2 gd mbstring intl xsl zip pdo_mysql soap

RUN docker-php-ext-install mcrypt

RUN apt-get install -y --no-install-recommends wget
RUN wget https://getcomposer.org/composer.phar \
 && chmod +x composer.phar \
 && mv composer.phar /usr/local/bin/composer

RUN usermod -u 1000 www-data

ADD php.ini /usr/local/etc/php/

RUN rm -rf /etc/apache2/sites-enabled/000-default.conf
ADD ./apache.conf /etc/apache2/sites-available/
RUN ln -s /etc/apache2/sites-available/apache.conf /etc/apache2/sites-enabled/
RUN a2enmod rewrite

RUN chown -R www-data:www-data /var/www

RUN apt-get install -y --no-install-recommends unzip

WORKDIR /var/www/html
