FROM php:7.2-apache

LABEL maintainer="Thomas Wiringa <thomas.wiringa@gmail.com>"

# Install php module dependencies
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    libfreetype6-dev libjpeg62-turbo-dev libpng-dev libwebp-dev \
    libxml2-dev libxslt-dev \
    libsqlite3-dev \
    libssl-dev \
    libicu-dev \
    libxrender-dev libfontconfig1-dev libxext-dev 

# Install php modules
RUN docker-php-ext-configure gd \
    --enable-gd-native-ttf --with-jpeg-dir=/usr/lib/x86_64-linux-gnu/ --with-png-dir=/usr/lib/x86_64-linux-gnu/ --with-freetype-dir=/usr/lib/x86_64-linux-gnu/ --with-webp-dir=/usr/lib/x86_64-linux-gnu/ \
 && docker-php-ext-install \
    gd dom hash iconv intl pdo_mysql simplexml xsl bcmath soap zip ctype mbstring exif fileinfo ftp

ADD php.ini /usr/local/etc/php/

ENV COMPOSER_DATE 2019-04-25

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

# Install Blackfire
RUN version=$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;") \
    && curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/linux/amd64/$version \
    && mkdir -p /tmp/blackfire \
    && tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp/blackfire \
    && mv /tmp/blackfire/blackfire-*.so $(php -r "echo ini_get('extension_dir');")/blackfire.so \
    && printf "extension=blackfire.so\nblackfire.agent_socket=tcp://blackfire:8707\n" > $PHP_INI_DIR/conf.d/blackfire.ini \
    && rm -rf /tmp/blackfire /tmp/blackfire-probe.tar.gz

# Install SSMTP
RUN apt-get update \
 && apt-get install -y --no-install-recommends ssmtp
ADD ./ssmtp.conf /etc/ssmtp/ssmtp.conf

# Cleanup
RUN apt-get clean \
 && apt-get autoclean
