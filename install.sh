#!/bin/bash

add-apt-repository ppa:docker-maint/testing
apt-get update
apt-get install -y docker.io git python-yaml python-jinja2 python-pycurl nginx

# TODO: Provision using ansible
ANSIBLE_DIR=/opt/ansible
mkdir -p $ANSIBLE_DIR
cd $ANSIBLE_DIR
(git clone https://github.com/ansible/ansible.git $ANSIBLE_DIR) || (cd $ANSIBLE_DIR;git pull)
cd $ANSIBLE_DIR
source ./hacking/env-setup

# Start Docker Image
mkdir -p /vagrant/images
docker pull registry:latest
(docker start registry) || (docker run -d -v /vagrant/images:/tmp/registry --name registry -p 5000:5000 registry)

mkdir -p /vagrant/ui
docker pull atcol/docker-registry-ui:latest
(docker start registry-ui) || (docker run --name registry-ui -d -p 5001:8080 -v /vagrant/ui:/var/lib/h2 -e REG1=http://$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' registry):5000/v1/ atcol/docker-registry-ui)

# Enable Startup Script
cp /vagrant/files/docker-registry.conf /etc/init/
cp /vagrant/files/docker-registry-ui.conf /etc/init/

# Nginx
cp /vagrant/files/docker-registry /etc/nginx/sites-available/
ln -sf /etc/nginx/sites-available/docker-registry /etc/nginx/sites-enabled/docker-registry
rm /etc/nginx/sites-enabled/default
service nginx reload
