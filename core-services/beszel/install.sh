#!/bin/bash

### USER INPUT VARIABLES

### MAKE BESZEL DIRECTORIES
mkdir -p /opt/core-services/beszel
mkdir -p /opt/core-services/beszel/data

### GET COMPOSE FILE
curl -sL -o /opt/core-services/beszel/compose.yaml -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/core-services/beszel/compose.yaml

### GET .ENV FILE
curl -sL -o /opt/core-services/beszel/.env -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/core-services/beszel/.env

### REPLACE .ENV VARIABLES

### GET INIT FILE
doas curl -sL -o /etc/init.d/beszel -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/alpine-linux/templates/init/beszel
doas chmod 755 /etc/init.d/beszel

### ENABLE BOOT START
doas rc-update add beszel default

### START BESZEL
doas rc-service beszel start
