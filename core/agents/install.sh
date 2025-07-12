#!/bin/bash

### USER INPUT VARIABLES
read -p '[REQUIRED] SERVICE PATH [/opt/services]: ' service_path < /dev/tty
service_path=${service_path:-'/opt/services'}

### MAKE CORE AGENTS DIRECTORIES
mkdir -p $service_path/core/agents/komodo-agent

### CREATE .ENV
cat > $service_path/core/agents/.env <<EOF
SERVICE_PATH: $service_path
EOF

### CREATE .ENV.KOMODO-AGENT
cat > $service_path/core/agents/.env.komodo-agent <<EOF
SERVICE: komodo-agent
EOF

### GET COMPOSE FILE
curl -sL -o $service_path/core/agents/compose.yaml -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/core/agents/compose.yaml

### START SERVICE(S)
docker compose -f $service_path/core/agents/compose.yaml --env-file $service_path/core/agents/.env --env-file $service_path/core/agents/.env.komodo-agent up -d > /dev/null 2>&1
