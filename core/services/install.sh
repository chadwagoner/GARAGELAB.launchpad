#!/bin/bash

### USER INPUT VARIABLES
read -p '[REQUIRED] SERVICE PATH [/opt/services]: ' service_path < /dev/tty
service_path=${service_path:-'/opt/services'}

read -p '[REQUIRED] TAILSCALE OAUTH CLIENT ID: ' tailscale_oauth_id < /dev/tty
if [[ -z $tailscale_oauth_id ]]; then
  echo "ERROR: TAILSCALE OAUTH CLIENT ID REQUIRED... Exiting"
  exit 1
fi

read -p '[REQUIRED] TAILSCALE OAUTH CLIENT SECRET: ' tailscale_oauth_secret < /dev/tty
if [[ -z $tailscale_oauth_secret ]]; then
  echo "ERROR: TAILSCALE OAUTH CLIENT SECRET REQUIRED... Exiting"
  exit 1
fi

### MAKE CORE SERVICE DIRECTORIES
mkdir -p $service_path/core/komodo/{repo-cache,syncs}
mkdir -p $service_path/core/mongo/{config,data}
mkdir -p $service_path/core/pocket-id/data
mkdir -p $service_path/core/tsbridge/data

### CREATE .ENV.KOMODO
cat > $service_path/core/.env.komodo <<EOF
SERVICE: komodo
SERVICE_PATH: $service_path
EOF

### CREATE .ENV.MONGO
cat > $service_path/core/.env.mongo <<EOF
SERVICE: mongo
SERVICE_PATH: $service_path
EOF

### CREATE .ENV.POCKET-ID
cat > $service_path/core/.env.pocket-id <<EOF
SERVICE: pocket-id
SERVICE_PATH: $service_path
EOF

### CREATE .ENV.TSBRIDGE
cat > $service_path/core/.env.tsbridge <<EOF
SERVICE: tsbridge
SERVICE_PATH: $service_path
TS_OAUTH_CLIENT_ID: $tailscale_oauth_id
TS_OAUTH_CLIENT_SECRET: $tailscale_oauth_secret
EOF

### GET COMPOSE FILE
curl -sL -o $service_path/core/compose.yaml -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/core/services//compose.yaml

### START SERVICE(S)
docker compose -f $service_path/core/compose.yaml up -d
