#!/bin/bash

### STOP KOMODO
doas rc-service komodo stop

### DELETE BOOT START
doas rc-update del komodo

### DELETE INIT FILE
doas rm -rf /etc/init.d/komodo

### DELETE KOMODO DIRECTORIES
doas rm -rf /opt/core-services/komodo
