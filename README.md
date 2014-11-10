# Private Docker Registry

Vagrant setup for a private docker registry and UI

## Motivation

If you have multiple VMs on your machine running Docker, it helps to have a shared local, private registry
that you can quickly push images to and pull from.

## Pre-requisites
Install the `vagrant-hostmanager` plugin to resolve the hostname for this VM.

## Setup
Run `vagrant up` to bring up the VM.

## Accessing the registry

Check if you can reach the private registry by executing `curl http://docker-registry.local:5000`
If should return a `200 OK` with the Docker registry version.

Check if you can reach the private registry UI by navigating to `http://docker-registry.local:5001`.
You should see a UI for the docker registry.

