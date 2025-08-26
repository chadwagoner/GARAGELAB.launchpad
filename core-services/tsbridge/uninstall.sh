#!/bin/bash

### STOP TSBRIDGE
doas rc-service container_tsbridge stop

### DELETE BOOT START
doas rc-update del container_tsbridge

### DELETE INIT FILE
doas rm -rf /etc/init.d/container_tsbridge

### DELETE TSBRIDGE DIRECTORIES
doas rm -rf /opt/core-services/tsbridge
