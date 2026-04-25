#!/bin/bash

### STOP DOCKTAIL
doas rc-service docktail stop

### DELETE BOOT START
doas rc-update del docktail

### DELETE INIT FILE
doas rm -rf /etc/init.d/docktail

### DELETE DOCKTAIL DIRECTORIES
doas rm -rf /opt/core/docktail
