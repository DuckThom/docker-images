FROM magento1:app-5.5

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