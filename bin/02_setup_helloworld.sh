#!/usr/bin/env bash

set -e

mkdir -p helloworld
cd helloworld
truffle init

rm -fr truffle.js
cp -a ../tmpl/* .

echo
echo "Project files were placed in the directory: helloworld/"
