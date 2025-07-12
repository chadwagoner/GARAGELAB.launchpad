#!/bin/sh

### GLOBAL VARIABLES
service='komodo-agent'

### USER INPUT VARIABLES
read -p 'SERVICE PATH [/opt/services]: ' service_path < /dev/tty
read -p 'KOMODO PASSKEY (default: changeme123): ' komodo_passkey < /dev/tty

### SET DEFAULT VALUES IF BLANK
service_path=${service_path:-'/opt/services'}
komodo_passkey=${komodo_passkey:-'changeme123'}

### MAKE KOMODO DIRECTORY
mkdir -p $service_path/$service

### CREATE .ENV
cat > $service_path/$service/.env <<EOF
PERIPHERY_DISABLE_TERMINALS: false
PERIPHERY_INCLUDE_DISK_MOUNTS: /etc/hostname
PERIPHERY_PASSKEYS: $komodo_passkey
PERIPHERY_ROOT_DIRECTORY: $service_path/$service
PERIPHERY_SSL_ENABLED: true
SERVICE: $service
SERVICE_PATH: $service_path
EOF

### GET COMPOSE FILE
curl -sL -o $service_path/$service/compose.yaml -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/chadwagoner/GARAGELAB.utils/main/docker/$service/compose.yaml

### START SERVICE
docker compose -f $service_path/$service/compose.yaml up -d
