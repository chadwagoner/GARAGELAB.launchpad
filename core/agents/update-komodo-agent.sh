#!/bin/bash

### USER INPUT VARIABLES
read -p '[REQUIRED] SERVICE PATH [/opt/services]: ' service_path < /dev/tty
service_path=${service_path:-'/opt/services'}

### GET COMPOSE FILE
curl -sL -o $service_path/agents/compose.yaml -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/core/agents/compose.yaml

### START SERVICE(S)
docker compose -f $service_path/agents/compose.yaml --env-file $service_path/agents/.env --env-file $service_path/agents/.env.komodo-agent --profile komodo-agent up -d
