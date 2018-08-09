#!/bin/bash

# Try creating the database
wp db check > /dev/null

if [ $? == 0 ]; then
	# db exists, naively assume that this means we're OK
	exit 0
fi

# OK, create the database
wp db create > /dev/null

wp core multisite-install --url="http://kitpress-dev" --title="KitPress" --admin_user="pclifton" --admin_password="devpass" --admin_email="bogus@kitpress.net" --subdomains --skip-config > /dev/null

# Spit "changed" so ansible knows we did something
echo "changed"