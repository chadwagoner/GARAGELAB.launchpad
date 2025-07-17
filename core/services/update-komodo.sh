#!/bin/bash

### USER INPUT VARIABLES
read -p '[REQUIRED] SERVICE PATH [/opt/services]: ' service_path < /dev/tty
service_path=${service_path:-'/opt/services'}

### START SERVICE(S)
docker compose -f $service_path/core/compose.yaml --env-file $service_path/core/.env --env-file $service_path/core/.env.id --env-file $service_path/core/.env.komodo --env-file $service_path/core/.env.mongo --env-file $service_path/core/.env.tsbridge --profile komodo up -d
