#!/bin/bash

### USER INPUT VARIABLES
read -p '[REQUIRED] SERVICE PATH [/opt/services]: ' service_path < /dev/tty
service_path=${service_path:-'/opt/services'}

read -p '[REQUIRED] SERVICE URL [https://<service>.<tailnet>.ts.net]: ' service_url < /dev/tty
if [[ -z $service_url ]]; then
  echo "ERROR: APP URL REQUIRED... Exiting"
  exit 1
fi

### CREATE .ENV.POCKET-ID
cat > $service_path/core/.env.pocket-id <<EOF
ANALYTICS_DISABLED: true
APP_URL: $service_url
PGID: 1000
PUID: 1000
TRUST_PROXY: true
EOF

### CLEAN SERVICE DIRECTORIES
doas rm -rf $service_path/core/pocket-id/data/*
doas rm -rf $service_path/core/pocket-id/data/.*

### START SERVICE(S)
docker compose -f $service_path/core/compose.yaml --env-file $service_path/core/.env --env-file $service_path/core/.env.pocket-id up pocket-id -d --force-recreate #> /dev/null 2>&1
