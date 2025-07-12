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

### CREATE .ENV
cat > $service_path/core/.env <<EOF
SERVICE_PATH: $service_path
EOF

### CREATE .ENV.KOMODO
cat > $service_path/core/.env.komodo <<EOF
SERVICE: komodo
EOF

### CREATE .ENV.MONGO
cat > $service_path/core/.env.mongo <<EOF
SERVICE: mongo
EOF

### CREATE .ENV.POCKET-ID
cat > $service_path/core/.env.pocket-id <<EOF
SERVICE: pocket-id
EOF

### CREATE .ENV.TSBRIDGE
cat > $service_path/core/.env.tsbridge <<EOF
SERVICE: tsbridge
TS_OAUTH_CLIENT_ID: $tailscale_oauth_id
TS_OAUTH_CLIENT_SECRET: $tailscale_oauth_secret
EOF

### GET COMPOSE FILE
curl -sL -o $service_path/core/compose.yaml -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/core/services/compose.yaml

### START SERVICE(S)
docker compose -f $service_path/core/compose.yaml --env-file $service_path/core/.env --env-file $service_path/core/.env.komodo --env-file $service_path/core/.env.mongo --env-file $service_path/core/.env.pocket-id --env-file $service_path/core/.env.tsbridge up -d > /dev/null 2>&1
