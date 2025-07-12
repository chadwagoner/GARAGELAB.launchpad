#!/bin/bash

### USER INPUT VARIABLES
read -p '[REQUIRED] SERVICE PATH [/opt/services]: ' service_path < /dev/tty
service_path=${service_path:-'/opt/services'}

### STOP SERVICE(S)
docker compose -f $service_path/core/compose.yaml down --rmi all --volumes

### REMOVE SERVICE FILES/DIRECTORIES
doas rm -rf $service_path/core
