#!/usr/bin/with-contenv bash

FILE="/root/installed"

BE_DIRECTORY="/opt/nodeapp"
FE_DIRECTORY="/var/www/html"

if [ -f "$FILE" ]
then
	echo "Container already installed"
else
	echo "Clean container."
	if [ -f "$BE_DIRECTORY/packages.json" ]
	then
		echo "Install BE node dependencies"
		cd $BE_DIRECTORY && npm install
	fi

	if [ -f "$BE_DIRECTORY/bower.json" ]
	then
		echo "Install BE bower dependencies"
		cd $BE_DIRECTORY && bower install --allow-root option
	fi	

	if [ -f "$BE_DIRECTORY/gulpfile.js" ]
	then
		echo "Execute BE GULP build-prod"
		#sed -i -e "s@SERVER_API_INT_HOST@$SERVER_API_INT_HOST@" $BE_DIRECTORY/config/prod_config.json
		sed -i -e "s@SERVER_API_INT_PORT@$SERVER_API_INT_PORT@" $BE_DIRECTORY/config/prod_config.json		
		cd $BE_DIRECTORY && gulp build-prod
	fi

	if [ -f "$FE_DIRECTORY/bower.json" ]
	then
		echo "Install FE bower dependencies"
		cd $FE_DIRECTORY && bower install --allow-root option
	fi	

	if [ -f "$FE_DIRECTORY/gulpfile.js" ]
	then
		echo "Execute FE GULP build-prod"
		sed -i -e "s@SERVER_API_URL@$SERVER_API_HOST:$SERVER_API_PORT@" $FE_DIRECTORY/environment_config.json
		cd $FE_DIRECTORY && gulp build-prod
	fi

	if [ -f "$BE_DIRECTORY/boot/db_init.js" ]
	then
		echo "Init DB"
		node $BE_DIRECTORY/boot/db_init.js
	fi

	cp /root/be_config.json $BE_DIRECTORY/config.json


	touch $FILE
fi