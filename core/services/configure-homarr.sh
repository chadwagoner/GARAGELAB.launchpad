#!/bin/bash

### USER INPUT VARIABLES
read -p '[REQUIRED] SERVICE PATH [/opt/services]: ' service_path < /dev/tty
service_path=${service_path:-'/opt/services'}

read -p '[REQUIRED] SERVICE URL [https://<service>.<tailnet>.ts.net]: ' service_url < /dev/tty
if [[ -z $service_url ]]; then
  echo "ERROR: SERVICE URL REQUIRED... Exiting"
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
fi

### MAKE HOMARR SERVICE DIRECTORIES
mkdir -p $service_path/core/homarr/data

### CREATE .ENV.HOMARR
cat > $service_path/core/.env.homarr <<EOF
SECRET_ENCRYPTION_KEY: $(openssl rand -hex 32)
BASE_URL: $service_url
EOF

### INJECT AUTH VARIABLES BASED ON OIDC
if [[ $oidc_enable == true ]]; then
  cat >> $service_path/core/.env.homarr <<EOF
AUTH_OIDC_CLIENT_ID: $oidc_client_id
AUTH_OIDC_CLIENT_SECRET: $oidc_client_secret
AUTH_OIDC_ISSUER: $oidc_provider
AUTH_PROVIDERS: oidc
EOF
fi
