FROM php:7.2-apache

MAINTAINER Thomas Wiringa <t.wiringa@youwe.nl>

RUN apt-get update -y \
 && apt-get install -y --no-install-recommends \
    libfreetype6-dev libjpeg62-turbo-dev libpng-dev \
    libbz2-dev \
    libmcrypt-dev \
    libicu-dev \
    libxslt-dev \
    libxml2-dev

RUN docker-php-ext-configure gd \
    --enable-gd-native-ttf --with-jpeg-dir=/usr/lib/x86_64-linux-gnu/ --with-png-dir=/usr/lib/x86_64-linux-gnu/ --with-freetype-dir=/usr/lib/x86_64-linux-gnu/ \
 && docker-php-ext-install \
    gd dom hash iconv intl pdo_mysql simplexml xsl bcmath soap zip ctype

RUN usermod -u 1000 www-data

RUN chown -R www-data:www-data /var/www

ENV COMPOSER_DATE 2019-04-01

RUN apt-get install -y --no-install-recommends wget unzip
RUN wget https://getcomposer.org/composer.phar \
 && chmod +x composer.phar \
 && mv composer.phar /usr/local/bin/composer

ADD php.ini /usr/local/etc/php/

RUN rm -rf /etc/apache2/sites-enabled/000-default.conf
ADD ./apache.conf /etc/apache2/sites-available/
RUN ln -s /etc/apache2/sites-available/apache.conf /etc/apache2/sites-enabled/
RUN a2enmod rewrite

RUN apt-get update \
 && apt-get install --no-install-recommends -y \
    git ssh

RUN echo "bind '\"\e[1;5C\":forward-word'" >> /etc/bash.bashrc
RUN echo "bind '\"\e[1;5D\":backward-word'" >> /etc/bash.bashrc

RUN echo "PS1='\[\033[0;32m\]\[\033[0m\033[0;32m\]\u\[\033[0;36m\] @ Docker container \[\033[0;36m\]\h \w\[\033[0;32m\]\n\[\033[0;32m\]└─\[\033[0m\033[0;32m\] \$\[\033[0m\033[0;32m\] ▶\[\033[0m\] '" >> /etc/bash.bashrc

WORKDIR /var/www/html
