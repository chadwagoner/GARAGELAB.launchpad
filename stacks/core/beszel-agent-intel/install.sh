#!/bin/bash

### USER INPUT VARIABLES
read -p '[REQUIRED] PUBLIC KEY: ' public_key < /dev/tty
if [[ -z $public_key ]]; then
  echo "ERROR: PUBLIC KEY REQUIRED... Exiting"
  exit 1
fi

read -p '[REQUIRED] HUB URL: ' hub_url < /dev/tty
if [[ -z $hub_url ]]; then
  echo "ERROR: HUB URL REQUIRED... Exiting"
  exit 1
fi

read -p '[REQUIRED] TOKEN: ' token < /dev/tty

if [[ -z $token ]]; then
  echo "ERROR: TOKEN REQUIRED... Exiting"
  exit 1
fi

### MAKE BESZEL DIRECTORIES
mkdir -p /opt/core/beszel-agent-intel/data

### GET COMPOSE FILE
curl -sL -o /opt/core/beszel-agent-intel/compose.yaml -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/stacks/core/beszel-agent-intel/compose.yaml

### GET .ENV FILE
curl -sL -o /opt/core/beszel-agent-intel/.env -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/stacks/core/beszel-agent-intel/.env

### REPLACE .ENV VARIABLES
sed -i "s#__PUBLIC_KEY__#$public_key#g" /opt/core/beszel-agent-intel/.env
sed -i "s#__HUB_URL__#$hub_url#g" /opt/core/beszel-agent-intel/.env
sed -i "s#__TOKEN__#$token#g" /opt/core/beszel-agent-intel/.env

### GET INIT FILE
doas curl -sL -o /etc/init.d/beszel-agent-intel -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/platforms/alpine/templates/init/beszel-agent
doas chmod 755 /etc/init.d/beszel-agent-intel

### ENABLE BOOT START
doas rc-update add beszel-agent-intel default

### START BESZEL
doas rc-service beszel-agent-intel start
