#!/bin/bash

# Add Grafana APT repo
sudo apt-get install -y software-properties-common
sudo add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"

# Add Grafana GPG key
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -

# Update & install
sudo apt update
sudo apt install grafana -y

#Start Grafana
sudo systemctl enable grafana-server
sudo systemctl start grafana-server

