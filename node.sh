#!/bin/bash

# Upgarde 
sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y dist-upgrade

# Node
curl -sL https://deb.nodesource.com/setup_8.x | -E bash -
apt-get install -y nodejs

# onoff
npm install -g onoff