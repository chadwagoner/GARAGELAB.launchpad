#!/bin/bash

### STOP BESZEL-AGENT
doas rc-service beszel-agent stop

### DELETE BOOT START
doas rc-update del beszel-agent

### DELETE INIT FILE
doas rm -rf /etc/init.d/beszel-agent

### DELETE BESZEL-AGENT DIRECTORIES
doas rm -rf /opt/core-agents/beszel-agent
