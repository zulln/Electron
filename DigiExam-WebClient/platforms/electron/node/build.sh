#!/bin/bash
#Build script for node-gyp
#Input parameter should be the arch (x64/ia32) of the target machine.
cd ./platforms/electron/node
arch="ia32"

if [ "$1" != "x64" ] && [ "$1" != "ia32" ]; then
	echo -e "Incorrect architecture argument.\nExiting build script."
	exit
fi

if [ $arch != "$1" ]; then
	arch=$1
fi

url=https://atom.io./download/atom-shell
version=$(electron -v | cut -c 2-)
node-gyp rebuild --target=$version --arch=$arch --dist-url=$url
