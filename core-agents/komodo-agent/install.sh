#!/bin/bash

### USER INPUT VARIABLES
read -p '[REQUIRED] KOMODO PASSKEY [changeme123]: ' komodo_passkey < /dev/tty
komodo_passkey=${komodo_passkey:-'changeme123'}

### MAKE KOMODO-AGENT DIRECTORIES
mkdir -p /opt/core-agents/komodo-agent

### GET COMPOSE FILE
curl -sL -o /opt/core-agents/komodo-agent/compose.yaml -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/core-agents/komodo-agent/compose.yaml

### GET .ENV FILE
curl -sL -o /opt/core-agents/komodo-agent/.env -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/core-agents/komodo-agent/.env

### REPLACE .ENV VARIABLES
sed -i "s#__KOMODO_PASSKEY__#$komodo_passkey#g" /opt/core-agents/komodo-agent/.env

### GET INIT FILE
doas curl -sL -o /etc/init.d/komodo-agent -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/alpine-linux/templates/init/komodo-agent
doas chmod 755 /etc/init.d/komodo-agent

### ENABLE BOOT START
doas rc-update add komodo-agent default

### START KOMODO-AGENT
doas rc-service komodo-agent start
