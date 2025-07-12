#!/bin/bash

### USER INPUT VARIABLES
read -p '[REQUIRED] SERVICE PATH [/opt/services]: ' service_path < /dev/tty
service_path=${service_path:-'/opt/services'}

read -p '[REQUIRED] MONGO USERNAME [mongo]: ' mongo_username < /dev/tty
mongo_username=${mongo_username:-'mongo'}

read -p '[REQUIRED] MONGO PASSWORD [changeme123]: ' mongo_password < /dev/tty
mongo_password=${mongo_password:-'changeme123'}

read -p '[REQUIRED] KOMODO PASSKEY [changeme123]: ' komodo_passkey < /dev/tty
komodo_passkey=${komodo_passkey:-'changeme123'}

read -p '[REQUIRED] SERVICE URL [https://<service>.<tailnet>.ts.net]: ' service_url < /dev/tty
if [[ -z $service_url ]]; then
  echo "ERROR: APP URL REQUIRED... Exiting"
  exit 1
fi

read -p '[OPTIONAL] ENABLE OIDC [true/FALSE]: ' oidc_enable < /dev/tty
oidc_enable=${oidc_enable:-false}

### OIDC VARIABLES
if [[ $oidc_enable == true ]]; then
  read -p '[REQUIRED] OIDC PROVIDER URL: ' oidc_provider < /dev/tty
  if [[ -z $oidc_provider ]]; then
    echo "ERROR: OIDC PROVIDER URL REQUIRED... Exiting"
    exit 1
  fi

  read -p '[REQUIRED] OIDC CLIENT ID: ' oidc_client_id < /dev/tty
  if [[ -z $oidc_client_id ]]; then
    echo "ERROR: OIDC CLIENT ID REQUIRED... Exiting"
    exit 1
  fi

  read -p '[REQUIRED] OIDC CLIENT SECRET: ' oidc_client_secret < /dev/tty
  if [[ -z $oidc_client_secret ]]; then
    echo "ERROR: OIDC CLIENT SECRET REQUIRED... Exiting"
    exit 1
  fi

  read -p '[OPTIONAL] OIDC USE FULL EMAIL [true/FALSE]: ' oidc_use_email < /dev/tty
  oidc_use_email=${oidc_use_email:-'false'}
fi

### CREATE .ENV.KOMODO
cat > $service_path/core/.env.komodo <<EOF
KOMODO_DATABASE_ADDRESS: "mongo:27017"
KOMODO_DATABASE_PASSWORD: $mongo_password
KOMODO_DATABASE_USERNAME: $mongo_username
KOMODO_DISABLE_CONFIRM_DIALOG: false
KOMODO_DISABLE_NON_ADMIN_CREATE: false
KOMODO_DISABLE_USER_REGISTRATION: false
KOMODO_ENABLE_NEW_USERS: false
KOMODO_GITHUB_OAUTH_ENABLED: false
KOMODO_GOOGLE_OAUTH_ENABLED: false
KOMODO_HOST: $service_url
KOMODO_JWT_SECRET: "a_random_jwt_secret"
KOMODO_JWT_TTL: "1-day"
KOMODO_MONITORING_INTERVAL: "15-sec"
KOMODO_PASSKEY: $komodo_passkey
KOMODO_RESOURCE_POLL_INTERVAL: "1-hr"
KOMODO_TITLE: "Komodo"
KOMODO_TRANSPARENT_MODE: false
KOMODO_WEBHOOK_SECRET: "a_random_secret"
EOF

### INJECT AUTH VARIABLES BASED ON OIDC
if [[ $oidc_enable == true ]]; then
  cat >> $service_path/core/.env.komodo <<EOF
KOMODO_LOCAL_AUTH: false
KOMODO_OIDC_CLIENT_ID: $oidc_client_id
KOMODO_OIDC_CLIENT_SECRET: $oidc_client_secret
KOMODO_OIDC_ENABLED: $oidc_enable
KOMODO_OIDC_PROVIDER: $oidc_provider
KOMODO_OIDC_USE_FULL_EMAIL: $oidc_use_email
EOF
else
  cat >> $service_path/core/.env.komodo <<EOF
KOMODO_LOCAL_AUTH: true
KOMODO_OIDC_ENABLED: $oidc_enable
EOF
fi

### CREATE .ENV.MONGO
cat > $service_path/core/.env.mongo <<EOF
MONGO_INITDB_ROOT_PASSWORD: $mongo_password
MONGO_INITDB_ROOT_USERNAME: $mongo_username
EOF

### STOP SERVICE(S)
docker compose -f $service_path/core/compose.yaml --env-file $service_path/core/.env --env-file $service_path/core/.env.komodo --env-file $service_path/core/.env.mongo --env-file $service_path/core/.env.pocket-id --env-file $service_path/core/.env.tsbridge down komodo mongo

### CLEAN SERVICE DIRECTORIES
doas rm -rf $service_path/core/mongo/data/*
doas rm -rf $service_path/core/mongo/data/.*
doas rm -rf $service_path/core/mongo/config/*
doas rm -rf $service_path/core/mongo/config/.*

### START SERVICE(S)
docker compose -f $service_path/core/compose.yaml --env-file $service_path/core/.env --env-file $service_path/core/.env.komodo --env-file $service_path/core/.env.mongo --env-file $service_path/core/.env.pocket-id --env-file $service_path/core/.env.tsbridge up -d --force-recreate komodo mongo #> /dev/null 2>&1
