FROM php:7.2-apache

# Container dependencies
RUN apt-get update \
 && apt-get install --no-install-recommends -y \
    zlib1g-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libxml2-dev \
    wget ssmtp

# PHP configuration
ADD php.ini /usr/local/etc/php/
RUN docker-php-ext-configure \
    gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
 && docker-php-ext-install \
    pdo_mysql \
    gd \
    soap \
    simplexml \
    exif \
    bcmath

#ADD docker-php-pecl-install /usr/local/bin
RUN pecl install xdebug
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

RUN wget https://raw.githubusercontent.com/colinmollenhour/modman/master/modman
RUN mv modman /usr/local/bin/modman
RUN chmod +x /usr/local/bin/modman

# Blackfire
RUN version=$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;") \
    && curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/linux/amd64/$version \
    && mkdir -p /tmp/blackfire \
    && tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp/blackfire \
    && mv /tmp/blackfire/blackfire-*.so $(php -r "echo ini_get('extension_dir');")/blackfire.so \
    && printf "extension=blackfire.so\nblackfire.agent_socket=tcp://blackfire:8707\n" > $PHP_INI_DIR/conf.d/blackfire.ini \
    && rm -rf /tmp/blackfire /tmp/blackfire-probe.tar.gz

ADD ./ssmtp.conf /etc/ssmtp/ssmtp.conf

RUN usermod -u 1000 www-data

