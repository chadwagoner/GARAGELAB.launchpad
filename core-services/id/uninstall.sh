#!/bin/bash

### STOP POCKET-ID
doas rc-service id stop

### DELETE BOOT START
doas rc-update del id

### DELETE INIT FILE
doas rm -rf /etc/init.d/id

### DELETE POCKET-ID DIRECTORIES
doas rm -rf /opt/core-services/id
