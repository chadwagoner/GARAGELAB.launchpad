#!/bin/bash

### MAKE DOCKHAND DIRECTORIES
mkdir -p /opt/core/dockhand/data

### GET COMPOSE FILE
curl -sL -o /opt/core/dockhand/compose.yaml -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/stacks/core/dockhand/compose.yaml

### GET .ENV FILE
curl -sL -o /opt/core/dockhand/.env -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/stacks/core/dockhand/.env

### GET INIT FILE
doas curl -sL -o /etc/init.d/dockhand -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/platforms/alpine/templates/init/dockhand
doas chmod 755 /etc/init.d/dockhand

### ENABLE BOOT START
doas rc-update add dockhand default

### START DOCKHAND
doas rc-service dockhand start
