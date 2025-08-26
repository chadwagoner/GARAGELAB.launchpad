#!/bin/bash

### USER INPUT VARIABLES
read -p '[REQUIRED] BESZEL SSH KEY: ' beszel_key < /dev/tty
if [[ -z $beszel_key ]]; then
  echo "ERROR: BESZEL SSH KEY REQUIRED... Exiting"
  exit 1
fi

### MAKE BESZEL-AGENT DIRECTORIES
mkdir -p /opt/core-agents/beszel-agent

### GET COMPOSE FILE
curl -sL -o /opt/core-agents/beszel-agent/compose.yaml -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/core-agents/beszel-agent/compose.yaml

### GET .ENV FILE
curl -sL -o /opt/core-agents/beszel-agent/.env -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/core-agents/beszel-agent/.env

### REPLACE .ENV VARIABLES
sed -i "s#__BESZEL_KEY__#$beszel_key#g" /opt/core-agents/beszel-agent/.env

### GET INIT FILE
doas curl -sL -o /etc/init.d/beszel-agent -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/alpine-linux/templates/init/beszel-agent
doas chmod 755 /etc/init.d/beszel-agent

### ENABLE BOOT START
doas rc-update add beszel-agent default

### START BESZEL
doas rc-service beszel-agent start
