#!/bin/bash

### USER INPUT VARIABLES
read -p '[REQUIRED] SERVICE URL [https://<service>.<tailnet>.ts.net]: ' service_url < /dev/tty
if [[ -z $service_url ]]; then
  echo "ERROR: SERVICE URL REQUIRED... Exiting"
  exit 1
fi

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

read -p '[REQUIRED] OIDC ADMIN GROUP: ' oidc_admin_group < /dev/tty
if [[ -z $oidc_admin_group ]]; then
  echo "ERROR: OIDC ADMIN GROUP REQUIRED... Exiting"
  exit 1
fi

### MAKE SECRET ENCRYPTION KEY
encryption_key=$(openssl rand -hex 32)

### MAKE HOMARR DIRECTORIES
mkdir -p /opt/core-services/homarr
mkdir -p /opt/core-services/homarr/data

### GET COMPOSE FILE
curl -sL -o /opt/core-services/homarr/compose.yaml -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/core-services/homarr/compose.yaml

### GET .ENV FILE
curl -sL -o /opt/core-services/homarr/.env -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/core-services/homarr/.env

### REPLACE .ENV VARIABLES
sed -i "s#__APP_URL__#$service_url#g" /opt/core-services/homarr/.env
sed -i "s#__OIDC_CLIENT_ID__#$oidc_client_id#g" /opt/core-services/homarr/.env
sed -i "s#__OIDC_CLIENT_SECRET__#$oidc_client_secret#g" /opt/core-services/homarr/.env
sed -i "s#__OIDC_ADMIN_GROUP__#$oidc_admin_group#g" /opt/core-services/homarr/.env
sed -i "s#__OIDC_PROVIDER__#$oidc_provider#g" /opt/core-services/homarr/.env

### GET INIT FILE
doas curl -sL -o /etc/init.d/homarr -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/alpine-linux/templates/init/homarr
doas chmod 755 /etc/init.d/homarr

### ENABLE BOOT START
doas rc-update add homarr default

### START HOMARR
doas rc-service homarr start
