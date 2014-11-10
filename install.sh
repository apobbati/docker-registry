#!/bin/bash

REGISTRY_HOSTNAME=$1

apt-get update
apt-get install -y git nginx

curl -sSL https://get.docker.com/ | sh

# Start Docker Registry Image
mkdir -p /vagrant/images
docker pull registry:0.8.1
(docker start registry) || (docker run -d -v /vagrant/images:/tmp/registry --name registry -p 5000:5000 registry)

# Start Docker Registry-UI Image
mkdir -p /vagrant/ui
docker pull atcol/docker-registry-ui:latest
(docker start registry-ui) || (docker run --name registry-ui -d -p 5001:8080 -v /vagrant/ui:/var/lib/h2 -e REG1=http://$REGISTRY_HOSTNAME/v1/ atcol/docker-registry-ui)

# Enable Startup Script
cp /vagrant/files/docker-registry.conf /etc/init/
cp /vagrant/files/docker-registry-ui.conf /etc/init/

# Nginx
cp /vagrant/files/docker-registry /etc/nginx/sites-available/
ln -sf /etc/nginx/sites-available/docker-registry /etc/nginx/sites-enabled/docker-registry
rm /etc/nginx/sites-enabled/default
service nginx reload
