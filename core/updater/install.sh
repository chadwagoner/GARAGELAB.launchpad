#!/bin/bash

### USER INPUT VARIABLES
read -p '[REQUIRED] SERVICE PATH [/opt/services]: ' service_path < /dev/tty
service_path=${service_path:-'/opt/services'}

### CREATE CORE-UPDATER
cat << EOF | doas tee /etc/periodic/weekly/core-updater >/dev/null
#!/bin/bash

### UPDATE CORE SERVICES
if [[ -d $service_path/core ]]; then
  local_services=\$(cat $service_path/core/compose.yaml | sha256sum | awk '{print $1}')
  remote_services=\$(curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/core/services/compose.yaml | sha256sum | awk '{print $1}')

  if [[ \$local_services != \$remote_services ]]; then
    curl -sL -o $service_path/core/compose.yaml -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/core/services/compose.yaml

    if [[ -n '\$(docker container list --filter 'name=^tsbridge$' --quiet)' ]]; then
      docker compose -f $service_path/core/compose.yaml --env-file $service_path/core/.env --env-file $service_path/core/.env.id --env-file $service_path/core/.env.komodo --env-file $service_path/core/.env.mongo --env-file $service_path/core/.env.tsbridge up tsbridge -d > /dev/null 2>&1

      sleep 30
    else
      echo "WARNING: TSBRIDGE DOES NOT EXIST... Skipping"
    fi

    if [[ -n '\$(docker container list --filter 'name=^id$' --quiet)' ]]; then
      docker compose -f $service_path/core/compose.yaml --env-file $service_path/core/.env --env-file $service_path/core/.env.id --env-file $service_path/core/.env.komodo --env-file $service_path/core/.env.mongo --env-file $service_path/core/.env.tsbridge up id -d > /dev/null 2>&1

      sleep 30
    else
      echo "WARNING: ID DOES NOT EXIST... Skipping"
    fi

    if [[ -n '\$(docker container list --filter 'name=^mongo$' --quiet)' ]]; then
      docker compose -f $service_path/core/compose.yaml --env-file $service_path/core/.env --env-file $service_path/core/.env.id --env-file $service_path/core/.env.komodo --env-file $service_path/core/.env.mongo --env-file $service_path/core/.env.tsbridge up mongo -d > /dev/null 2>&1

      sleep 30
    else
      echo "WARNING: MONGO DOES NOT EXIST... Skipping"
    fi

    if [[ -n '\$(docker container list --filter 'name=^komodo$' --quiet)' ]]; then
      docker compose -f $service_path/core/compose.yaml --env-file $service_path/core/.env --env-file $service_path/core/.env.id --env-file $service_path/core/.env.komodo --env-file $service_path/core/.env.mongo --env-file $service_path/core/.env.tsbridge up komodo -d > /dev/null 2>&1

      sleep 30
    else
      echo "WARNING: KOMODO DOES NOT EXIST... Skipping"
    fi
  fi
fi

### UPDATE CORE AGENTS
if [[ -d $service_path/agents ]]; then
  local_agents=\$(cat $service_path/agents/compose.yaml | sha256sum | awk '{print $1}')
  remote_agents=\$(curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/core/agents/compose.yaml | sha256sum | awk '{print $1}')

  if [[ \$local_agents != \$remote_agents ]]; then
    curl -sL -o $service_path/agents/compose.yaml -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/core/agents/compose.yaml

    if [[ -n '\$(docker container list --filter 'name=^komodo-agent$' --quiet)' ]]; then
      docker compose -f $service_path/agents/compose.yaml --env-file $service_path/agents/.env --env-file $service_path/agents/.env.komodo-agent up komodo-agent -d > /dev/null 2>&1

      sleep 30
    else
      echo "WARNING: KOMODO-AGENT DOES NOT EXIST... Skipping"
    fi
  fi
fi
EOF

### ENSURE CORRECT PERMISSIONS
doas chmod 755 /etc/periodic/weekly/core-updater
