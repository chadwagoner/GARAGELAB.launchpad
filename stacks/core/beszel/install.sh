#!/bin/bash

### USER INPUT VARIABLES
read -p '[REQUIRED] SERVICE URL [https://<service>.<tailnet>.ts.net]: ' service_url < /dev/tty
if [[ -z $service_url ]]; then
  echo "ERROR: APP URL REQUIRED... Exiting"
  exit 1
fi

### MAKE BESZEL DIRECTORIES
mkdir -p /opt/core/beszel/data

### GET COMPOSE FILE
curl -sL -o /opt/core/beszel/compose.yaml -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/stacks/core/beszel/compose.yaml

### GET .ENV FILE
curl -sL -o /opt/core/beszel/.env -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/stacks/core/beszel/.env

### REPLACE .ENV VARIABLES
sed -i "s#__APP_URL__#$service_url#g" /opt/core/beszel/.env

### GET INIT FILE
doas curl -sL -o /etc/init.d/beszel -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/platforms/alpine/templates/init/beszel
doas chmod 755 /etc/init.d/beszel

### ENABLE BOOT START
doas rc-update add beszel default

### START BESZEL
doas rc-service beszel start
