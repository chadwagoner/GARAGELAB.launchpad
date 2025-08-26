#!/bin/bash

### USER INPUT VARIABLES
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

### MAKE KOMODO DIRECTORIES
mkdir -p /opt/core-services/komodo
mkdir -p /opt/core-services/komodo/backups
mkdir -p /opt/core-services/komodo/syncs

### GET COMPOSE FILE
curl -sL -o /opt/core-services/komodo/compose.yaml -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/core-services/komodo/compose.yaml

### GET .ENV FILE
curl -sL -o /opt/core-services/komodo/.env -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/core-services/komodo/.env

### REPLACE .ENV VARIABLES
sed -i "s#__MONGO_USERNAME__#$mongo_username#g" /opt/core-services/komodo/.env
sed -i "s#__MONGO_PASSWORD__#$mongo_password#g" /opt/core-services/komodo/.env
sed -i "s#__KOMODO_PASSKEY__#$komodo_passkey#g" /opt/core-services/komodo/.env
sed -i "s#__APP_URL__#$service_url#g" /opt/core-services/komodo/.env
sed -i "s#__OIDC_PROVIDER__#$oidc_provider#g" /opt/core-services/komodo/.env
sed -i "s#__OIDC_CLIENT_ID__#$oidc_client_id#g" /opt/core-services/komodo/.env
sed -i "s#__OIDC_CLIENT_SECRET__#$oidc_client_secret#g" /opt/core-services/komodo/.env
sed -i "s#__OIDC_USE_EMAIL__#$oidc_use_email#g" /opt/core-services/komodo/.env

### GET INIT FILE
doas curl -sL -o /etc/init.d/container_komodo -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/alpine-linux/templates/init/container_komodo
doas chmod 755 /etc/init.d/container_komodo

### ENABLE BOOT START
doas rc-update add container_komodo default

### START KOMODO
doas rc-service container_komodo start
