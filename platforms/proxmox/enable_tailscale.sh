#!/bin/bash

### USER INPUT VARIABLES
read -p '[REQUIRED] TAILSCALE AUTH TOKEN: ' tailscale_token < /dev/tty
if [[ -z $tailscale_token ]]; then
  echo "ERROR: TAILSCALE AUTH TOKEN REQUIRED... Exiting"
  exit 1
fi

read -p '[REQUIRED] ENABLE TAILSCALE SSH [true/FALSE]: ' tailscale_ssh < /dev/tty
tailscale_ssh=${tailscale_ssh:-false}

read -p '[REQUIRED] ENABLE TAILSCALE SERVE FOR WEB UI [true/FALSE]: ' tailscale_serve < /dev/tty
tailscale_serve=${tailscale_serve:-false}

curl -fsSL https://tailscale.com/install.sh | sh

tailscale up --auth-key=$tailscale_token --ssh=$tailscale_ssh

if [[ $tailscale_serve == "true" ]]; then
  tailscale serve --bg https+insecure://localhost:8006
fi