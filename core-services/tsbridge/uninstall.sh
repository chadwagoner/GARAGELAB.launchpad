#!/bin/bash

### STOP TSBRIDGE
doas rc-service tsbridge stop

### DELETE BOOT START
doas rc-update del tsbridge

### DELETE INIT FILE
doas rm -rf /etc/init.d/tsbridge

### DELETE TSBRIDGE DIRECTORIES
doas rm -rf /opt/core-services/tsbridge
