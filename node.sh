#!/bin/bash

# Upgarde 
sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y dist-upgrade

# Node
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get install -y nodejs


# Cowsay
sudo npm install -g cowsay 
cowsay done!