#!/bin/bash

### STOP POCKET-ID
doas rc-service container_id stop

### DELETE BOOT START
doas rc-update del container_id

### DELETE INIT FILE
doas rm -rf /etc/init.d/container_id

### DELETE POCKET-ID DIRECTORIES
doas rm -rf /opt/core-services/id
