#!/bin/bash

# Ensure swap is set up
if [ ! -f /var/swap.1 ]; then
	/bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=1024
	chmod 600 /var/swap.1
	/sbin/mkswap /var/swap.1
	/sbin/swapon /var/swap.1
fi

EXPECTED_SIGNATURE="$(wget -q -O - https://composer.github.io/installer.sig)"
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_SIGNATURE="$(php -r "echo hash_file('SHA384', 'composer-setup.php');")"

if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ]
then
    >&2 echo 'ERROR: Invalid installer signature'
    rm composer-setup.php
    exit 1
fi

php composer-setup.php --quiet --install-dir=/usr/local/bin --filename=composer
RESULT=$?
rm composer-setup.php
exit $RESULT