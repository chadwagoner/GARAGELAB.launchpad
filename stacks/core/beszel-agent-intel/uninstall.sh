#!/bin/bash

### STOP BESZEL-AGENT-INTEL
doas rc-service beszel-agent-intel stop

### DELETE BOOT START
doas rc-update del beszel-agent-intel

### DELETE INIT FILE
doas rm -rf /etc/init.d/beszel-agent-intel

### DELETE BESZEL-AGENT-INTEL DIRECTORIES
doas rm -rf /opt/core/beszel-agent-intel
