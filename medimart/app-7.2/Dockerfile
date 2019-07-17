FROM magento1:app-7.2

# Custom vhost config
ADD custom-vhost.conf /etc/apache2/custom-vhost.conf

# Modman
RUN wget https://raw.githubusercontent.com/colinmollenhour/modman/master/modman
RUN mv modman /usr/local/bin/modman
RUN chmod +x /usr/local/bin/modman

# Enable Redis support
RUN pecl install -o -f redis \
 && rm -rf /tmp/pear \
 && docker-php-ext-enable redis

# Install mod_pagespeed
RUN wget https://dl-ssl.google.com/dl/linux/direct/mod-pagespeed-stable_current_amd64.deb \
 && dpkg -i mod-pagespeed-stable_current_amd64.deb \
 && apt-get install -f -y \
 && rm mod-pagespeed-stable_current_amd64.deb
