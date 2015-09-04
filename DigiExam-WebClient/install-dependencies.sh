#!/bin/sh

if [ "$EUID" = 0 ] || [ "$TRAVIS" = true ]; then
USE_SUDO=false
else
USE_SUDO=true
fi

printHeader () {
	echo "\n------------------------------------------------------------"
	echo "$1"
	echo "------------------------------------------------------------\n"
}

#printHeader "Running Go tests"
#goapp test ./...

printHeader "Installing SASS gem"
if [ "$USE_SUDO" = true ]
then sudo gem install sass -v 3.3.12
else gem install sass -v 3.3.12
fi

printHeader "Installing Gulp"
if [ "$USE_SUDO" = true ]
then sudo npm install -g gulp
else npm install -g gulp
fi

printHeader "Installing NPM and Bower dependencies"
npm install

printHeader "Running default Gulp tasks"
gulp

echo "\n------------------------------------------------------------\n"
echo "All done!\n"
echo "Commands to get you started:\n"
echo "    gulp watch - Build static assets when they change\n"
