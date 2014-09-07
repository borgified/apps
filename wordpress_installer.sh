#!/bin/bash
# Script to deploy Wordpress in a Terminal.com container
INSTALL_PATH="/var/www"

install(){
	DB_NAME="wp"
	DB_USER="wp"
	DB_PASS="terminal"

	# Includes
	wget https://raw.githubusercontent.com/qmaxquique/terminal.com/master/terlib.sh
	source terlib.sh || (echo "cannot get the includes"; exit -1)

	# Basics
	pkg_update
	system_cleanup
	basics_install

	# Procedure: 
	# 1 - Get prerrequisites.
	apache_install
	php5_install
	mysql_install
	mysql_setup $DB_NAME $DB_USER $DB_PASS
	apache_default_vhost wordpress.conf $INSTALL_PATH/wordpress

	# 2 - Install the product
	cd $INSTALL_PATH
	wget http://wordpress.org/latest.tar.gz
	tar xzvf latest.tar.gz
	rm latest.tar.gz

	# 3 - Configuring...
	cd $INSTALL_PATH/wordpress
	cp wp-config-sample.php wp-config.php
	sed -i "s/database_name_here/$DB_NAME/g" wp-config.php
	sed -i "s/username_name_here/$DB_USER/g" wp-config.php
	sed -i "s/password_name_here/$DB_PASS/g" wp-config.php

	mkdir $INSTALL_PATH/wordpress/wp-content/uploads
	chown -R www-data:www-data $INSTALL_PATH/wordpress	
}

show(){
	export PATH=$PATH:/srv/cloudlabs/scripts
	browse.sh http://localhost:80
}

if [[ -z $1 ]]; then
	install && show
elif [[ $1 == "show" ]]; then 
	show
else
	echo "unknown parameter specified"
fi