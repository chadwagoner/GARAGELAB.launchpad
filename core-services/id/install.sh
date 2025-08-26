#!/bin/bash

### USER INPUT VARIABLES
read -p '[REQUIRED] SERVICE URL [https://<service>.<tailnet>.ts.net]: ' service_url < /dev/tty
if [[ -z $service_url ]]; then
  echo "ERROR: APP URL REQUIRED... Exiting"
  exit 1
fi

### MAKE POCKET-ID DIRECTORIES
mkdir -p /opt/core-services/id
mkdir -p /opt/core-services/id/data

### GET COMPOSE FILE
curl -sL -o /opt/core-services/id/compose.yaml -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/core-services/id/compose.yaml

### GET .ENV FILE
curl -sL -o /opt/core-services/id/.env -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/core-services/id/.env

### REPLACE .ENV VARIABLES
sed -i "s#__APP_URL__#$service_url#g" /opt/core-services/id/.env

### GET INIT FILE
doas curl -sL -o /etc/init.d/id -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/alpine-linux/templates/init/id
doas chmod 755 /etc/init.d/id

### ENABLE BOOT START
doas rc-update add id default

### START POCKET-ID
doas rc-service id start
