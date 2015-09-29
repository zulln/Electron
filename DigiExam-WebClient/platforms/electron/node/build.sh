#!/bin/bash
url=https://atom.io./download/atom-shell
version=$(electron -v | cut -c 2-)
node-gyp rebuild --target=$version --arch=x64 --dist-url=$url
