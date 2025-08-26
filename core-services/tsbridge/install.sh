#!/bin/bash

### USER INPUT VARIABLES
read -p '[REQUIRED] TAILSCALE OAUTH CLIENT ID: ' tailscale_oauth_id < /dev/tty
if [[ -z $tailscale_oauth_id ]]; then
  echo "ERROR: TAILSCALE OAUTH CLIENT ID REQUIRED... Exiting"
  exit 1
fi

read -p '[REQUIRED] TAILSCALE OAUTH CLIENT SECRET: ' tailscale_oauth_secret < /dev/tty
if [[ -z $tailscale_oauth_secret ]]; then
  echo "ERROR: TAILSCALE OAUTH CLIENT SECRET REQUIRED... Exiting"
  exit 1
fi

### MAKE TSBRIDGE DIRECTORIES
mkdir -p /opt/core-services/tsbridge
mkdir -p /opt/core-services/tsbridge/data

### GET COMPOSE FILE
curl -sL -o /opt/core-services/tsbridge/compose.yaml -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/core-services/tsbridge/compose.yaml

### GET .ENV FILE
curl -sL -o /opt/core-services/tsbridge/.env -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/core-services/tsbridge/.env

### REPLACE .ENV VARIABLES
sed -i "s/__TS_OAUTH_CLIENT_ID__/$tailscale_oauth_id/g" /opt/core-services/tsbridge/.env
sed -i "s/__TS_OAUTH_CLIENT_SECRET__/$tailscale_oauth_secret/g" /opt/core-services/tsbridge/.env

### GET INIT FILE
doas curl -sL -o /etc/init.d/tsbridge -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/alpine-linux/templates/init/tsbridge
doas chmod 755 /etc/init.d/tsbridge

### ENABLE BOOT START
doas rc-update add tsbridge default

### START TSBRIDGE
doas rc-service tsbridge start
