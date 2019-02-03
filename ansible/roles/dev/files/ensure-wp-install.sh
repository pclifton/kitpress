#!/bin/bash

# Try creating the database
wp db check > /dev/null

if [ $? == 0 ]; then
	# db exists, naively assume that this means we're OK
	exit 0
fi

# OK, create the database
wp db create > /dev/null

# do the multisite install
wp core multisite-install --url="http://kitpress-dev" --title="KitPress" --admin_user="pclifton" --admin_password="devpass" --admin_email="bogus@kitpress.net" --subdomains --skip-config > /dev/null

# copy over the bootstrap upload stuff
rm -rf /var/www/vhosts/default/wp-content/uploads
cp -R /home/ec2-user/wp_bootstrap/uploads /var/www/vhosts/default/wp-content

# import bootstrap post data
wp post delete 1 --force
wp comment delete 1 --force
wp plugin install wordpress-importer --activate
wp import /home/ec2-user/wp_bootstrap/wp_dump.xml --authors=skip --quiet --skip=attachment

# symlink and activate WP plugins and theme
ln -s /media/sf_kitpress-modules/kitpress-theme/src /var/www/vhosts/default/wp-content/themes/kitpress
wp theme activate kitpress
wp theme enable kitpress --network

# Spit "changed" so ansible knows we did something
echo "changed"