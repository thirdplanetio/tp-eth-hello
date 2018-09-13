#!/usr/bin/env bash

set -e

npm config set prefix=$HOME/node
echo 'export PATH=$(npm config get prefix)/bin:$PATH' >> ~/.bashrc
# update our existing path
export PATH=$(npm config get prefix)/bin:$PATH

npm install -g truffle ganache-cli

echo
truffle version
ganache-cli --version
