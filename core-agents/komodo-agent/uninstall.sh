#!/bin/bash

### STOP KOMODO-AGENT
doas rc-service komodo-agent stop

### DELETE BOOT START
doas rc-update del komodo-agent

### DELETE INIT FILE
doas rm -rf /etc/init.d/komodo-agent

### DELETE KOMODO-AGENT DIRECTORIES
doas rm -rf /opt/core-agents/komodo-agent
