#!/bin/bash

### USER INPUT VARIABLES
read -p '[REQUIRED] INTEL GPU [true/FALSE]: ' intel_gpu < /dev/tty
intel_gpu=${intel_gpu:-false}

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
mkdir -p /opt/core/beszel-agent/data

### GET COMPOSE FILE
if [[ $intel_gpu == true ]]; then
  curl -sL -o /opt/core/beszel-agent/compose.intel.yaml -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/stacks/core/beszel-agent/compose.intel.yaml
else
  curl -sL -o /opt/core/beszel-agent/compose.yaml -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/stacks/core/beszel-agent/compose.yaml
fi

### GET .ENV FILE
curl -sL -o /opt/core/beszel-agent/.env -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/stacks/core/beszel-agent/.env

### REPLACE .ENV VARIABLES
sed -i "s#__PUBLIC_KEY__#$public_key#g" /opt/core/beszel-agent/.env
sed -i "s#__HUB_URL__#$hub_url#g" /opt/core/beszel-agent/.env
sed -i "s#__TOKEN__#$token#g" /opt/core/beszel-agent/.env

### GET INIT FILE
doas curl -sL -o /etc/init.d/beszel-agent -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/platforms/alpine/templates/init/beszel-agent
doas chmod 755 /etc/init.d/beszel-agent

### ENABLE BOOT START
doas rc-update add beszel-agent default

### START BESZEL
doas rc-service beszel-agent start
