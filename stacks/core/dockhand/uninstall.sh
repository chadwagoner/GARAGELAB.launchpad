#!/bin/bash

### STOP DOCKHAND
doas rc-service dockhand stop

### DELETE BOOT START
doas rc-update del dockhand

### DELETE INIT FILE
doas rm -rf /etc/init.d/dockhand

### DELETE DOCKHAND DIRECTORIES
doas rm -rf /opt/core/dockhand
