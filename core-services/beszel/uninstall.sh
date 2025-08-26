#!/bin/bash

### STOP BESZEL
doas rc-service beszel stop

### DELETE BOOT START
doas rc-update del beszel

### DELETE INIT FILE
doas rm -rf /etc/init.d/beszel

### DELETE BESZEL DIRECTORIES
doas rm -rf /opt/core-services/beszel
