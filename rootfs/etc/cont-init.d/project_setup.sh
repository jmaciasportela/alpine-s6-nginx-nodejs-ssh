#!/usr/bin/with-contenv bash

FILE="/root/installed"
DIRECTORY="/opt/nodeapp"

if [ -f "$FILE" ]
then
	echo "Container already installed"
else
	echo "Clean container."
	if [ -f "$DIRECTORY/packages.json" ]
	then
  	# Control will enter here if $DIRECTORY exists.
		echo "Install node dependencies"
		cd $DIRECTORY && npm install
	fi

	if [ -f "$DIRECTORY/bower.json" ]
	then
  	# Control will enter here if $DIRECTORY exists.
		echo "Install bower dependencies"
		cd $DIRECTORY && bower install --allow-root option
	fi	

	touch $FILE
fi