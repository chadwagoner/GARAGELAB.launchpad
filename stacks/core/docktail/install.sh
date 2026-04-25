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

### MAKE DOCKTAIL DIRECTORIES
mkdir -p /opt/core/docktail

### GET COMPOSE FILE
curl -sL -o /opt/core/docktail/compose.yaml -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/core/docktail/compose.yaml

### GET .ENV FILE
curl -sL -o /opt/core/docktail/.env -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/core/docktail/.env

### REPLACE .ENV VARIABLES
sed -i "s/__TS_OAUTH_CLIENT_ID__/$tailscale_oauth_id/g" /opt/core/docktail/.env
sed -i "s/__TS_OAUTH_CLIENT_SECRET__/$tailscale_oauth_secret/g" /opt/core/docktail/.env

### GET INIT FILE
doas curl -sL -o /etc/init.d/docktail -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/alpine-linux/templates/init/docktail
doas chmod 755 /etc/init.d/docktail

### ENABLE BOOT START
doas rc-update add docktail default

### START DOCKTAIL
doas rc-service docktail start
