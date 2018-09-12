#!/usr/bin/env bash

set -e

sudo apt-get update
sudo apt-get install -y curl gnupg2 software-properties-common build-essential

curl -fsSL https://deb.nodesource.com/setup_8.x | sudo bash -
sudo add-apt-repository "deb [arch=amd64] https://dl.yarnpkg.com/debian stable main"
sudo apt-get install -y nodejs
