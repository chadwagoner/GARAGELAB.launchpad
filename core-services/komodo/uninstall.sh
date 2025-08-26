#!/bin/bash

### STOP KOMODO
doas rc-service container_komodo stop

### DELETE BOOT START
doas rc-update del container_komodo

### DELETE INIT FILE
doas rm -rf /etc/init.d/container_komodo

### DELETE KOMODO DIRECTORIES
doas rm -rf /opt/core-services/komodo
