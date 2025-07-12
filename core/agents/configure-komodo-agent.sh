#!/bin/bash

### USER INPUT VARIABLES
read -p '[REQUIRED] SERVICE PATH [/opt/services]: ' service_path < /dev/tty
service_path=${service_path:-'/opt/services'}

read -p '[REQUIRED] KOMODO PASSKEY [changeme123]: ' komodo_passkey < /dev/tty
komodo_passkey=${komodo_passkey:-'changeme123'}

### CREATE .ENV
cat > $service_path/agents/.env.komodo-agent <<EOF
PERIPHERY_DISABLE_TERMINALS: false
PERIPHERY_INCLUDE_DISK_MOUNTS: /etc/hostname
PERIPHERY_PASSKEYS: $komodo_passkey
PERIPHERY_ROOT_DIRECTORY: $service_path/komodo-agent
PERIPHERY_SSL_ENABLED: true
EOF

### START SERVICE(S)
docker compose -f $service_path/agents/compose.yaml --env-file $service_path/agents/.env --env-file $service_path/agents/.env.komodo-agent --profile komodo-agent up -d --force-recreate > /dev/null 2>&1
