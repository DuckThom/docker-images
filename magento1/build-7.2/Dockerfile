FROM php@sha256:efc632fb68d508abd5939923cd40036e733387ee3767a141806e4bffde91b4c7

ENV FULL_UPDATE 2019_11_04

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -

# Install required packages for the PHP modules
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
# Tools
    apt-utils \
    wget \
    git \
    ruby-sass \
    nodejs \
    curl \
    iputils-ping \
    locales \
    ssh \
    rsync \
    unzip \
# Configure PHP
    libsodium-dev \
    libcurl3-dev \
    libfreetype6 \
    libfreetype6-dev \
    libicu-dev \
    libjpeg62-turbo \
    libjpeg62-turbo-dev \
    libpng-dev \
    libssl-dev \
    libxml2-dev \
    libxslt-dev \
    graphicsmagick \
    zlibc zlib1g zlib1g-dev

# Install PHP modules
RUN docker-php-ext-install pdo_mysql \
 && docker-php-ext-configure gd --enable-gd-native-ttf --with-jpeg-dir=/usr/lib/x86_64-linux-gnu/ --with-png-dir=/usr/lib/x86_64-linux-gnu/ --with-freetype-dir=/usr/lib/x86_64-linux-gnu/ \
 && docker-php-ext-install gd \
 && docker-php-ext-install bcmath \
 && docker-php-ext-install intl \
 && docker-php-ext-install mbstring \
 && docker-php-ext-install mysqli \
 && docker-php-ext-install opcache \
 && docker-php-ext-install pdo_mysql \
 && docker-php-ext-install soap \
 && docker-php-ext-install xsl \
 && docker-php-ext-install zip \
 && docker-php-ext-install exif \
 && docker-php-ext-install pcntl \
 && docker-php-ext-install sodium

# Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Enable mod_rewrite
RUN a2enmod rewrite

# Install ImageMagick
RUN apt-get update \
 && apt-get install libmagickwand-dev libmagickcore-dev -y \
 && pecl install imagick-3.4.3 \
 && docker-php-ext-enable imagick

# Modman
RUN wget https://raw.githubusercontent.com/colinmollenhour/modman/master/modman \
 && mv modman /usr/local/bin/modman \
 && chmod +x /usr/local/bin/modman

RUN chown -R www-data:www-data /var/www/
