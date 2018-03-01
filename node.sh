#!/bin/bash

# Upgarde 
apt-get -y update
apt-get -y dist-upgrade

# Node
curl -sL https://deb.nodesource.com/setup_8.x | -E bash -
apt-get install -y nodejs

# onoff
npm install -g onoff