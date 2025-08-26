#!/bin/bash

### STOP HOMARR
doas rc-service homarr stop

### DELETE BOOT START
doas rc-update del homarr

### DELETE INIT FILE
doas rm -rf /etc/init.d/homarr

### DELETE HOMARR DIRECTORIES
doas rm -rf /opt/core-services/homarr
