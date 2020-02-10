FROM php:7.4-apache

LABEL maintainer="Thomas Wiringa <thomas.wiringa@gmail.com>"

# Install php module dependencies
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    libfreetype6-dev libjpeg62-turbo-dev libpng-dev libwebp-dev \
    libxml2-dev libxslt-dev \
    libzip-dev \
    libxrender-dev libfontconfig1-dev libxext-dev 

# Install php modules
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install iconv
RUN docker-php-ext-install dom
RUN docker-php-ext-install simplexml
RUN docker-php-ext-install exif
RUN docker-php-ext-install fileinfo
RUN docker-php-ext-install zip
RUN docker-php-ext-install intl
RUN docker-php-ext-install opcache


# Imagick
RUN apt-get update && apt-get install -y \
    libmagickwand-dev --no-install-recommends \
    && pecl install imagick \
	&& docker-php-ext-enable imagick

ADD php.ini /usr/local/etc/php/

ENV COMPOSER_DATE 2019-12-02

# Install composer
RUN apt-get install -y --no-install-recommends wget unzip
RUN wget https://getcomposer.org/composer.phar \
 && chmod +x composer.phar \
 && mv composer.phar /usr/local/bin/composer

# Apache configuration
RUN rm -rf /etc/apache2/sites-enabled/000-default.conf
ADD ./apache.conf /etc/apache2/sites-available/
RUN ln -s /etc/apache2/sites-available/apache.conf /etc/apache2/sites-enabled/
RUN touch /etc/apache2/custom-global.conf
RUN touch /etc/apache2/custom-vhost.conf
RUN a2enmod rewrite

RUN usermod -u 1000 www-data

RUN ln -s /var/www/html/artisan /usr/local/bin/artisan

# Install git and ssh
RUN apt-get update \
 && apt-get install --no-install-recommends -y \
    git ssh

# Fix ctrl-left and ctrl-right shortcut
RUN echo "bind '\"\e[1;5C\":forward-word'" >> /etc/bash.bashrc
RUN echo "bind '\"\e[1;5D\":backward-word'" >> /etc/bash.bashrc

# Set a nice bash prompt
RUN echo "PS1='\[\033[0;32m\]\[\033[0m\033[0;32m\]\u\[\033[0;36m\] @ Docker container \[\033[0;36m\]\h \w\[\033[0;32m\]\n\[\033[0;32m\]└─\[\033[0m\033[0;32m\] \$\[\033[0m\033[0;32m\] ▶\[\033[0m\] '" >> /etc/bash.bashrc

# Install SSMTP
RUN apt-get update \
 && apt-get install -y --no-install-recommends msmtp
ADD ./msmtprc /etc/msmtprc

# Cleanup
RUN apt-get clean \
 && apt-get autoclean

RUN docker-php-ext-install gd
RUN docker-php-ext-install mysqli
