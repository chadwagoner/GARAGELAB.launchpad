#!/bin/bash

### INTERNAL VARIABLES
tailscale_command=""

### USER INPUT VARIABLES
read -p '[OPTIONAL] ENABLE TAILSCALE SSH [true/FALSE]: ' tailscale_ssh < /dev/tty
tailscale_ssh=${tailscale_ssh:-false}

read -p '[OPTIONAL] ENABLE TAILSCALE EXIT NODE [true/FALSE]: ' tailscale_exit < /dev/tty
tailscale_exit=${tailscale_exit:-false}

read -p '[OPTIONAL] ENABLE TAILSCALE SUBNET ROUTER [true/FALSE]: ' tailscale_subnet < /dev/tty
tailscale_subnet=${tailscale_subnet:-false}

if [[ $tailscale_subnet == true ]]; then
  read -p '[REQUIRED] TAILSCALE SUBNET SPACE [1.2.3.4/24]: ' tailscale_subnet_space < /dev/tty

  if [[ -z $tailscale_subnet_space ]]; then
    echo "ERROR: TAILSCALE SUBNET SPACE REQUIRED... Exiting"
    exit 1
  fi
fi

### TAILSCALE SSH LOGIC
if [[ $tailscale_ssh == true ]]; then
  tailscale_command+="--ssh "
fi

### TAILSCALE EXIT NODE LOGIC
if [[ $tailscale_exit == true ]]; then
  tailscale_command+="--advertise-exit-node "
fi

### TAILSCALE SUBNET ROUTER LOGIC
if [[ $tailscale_subnet == true ]]; then
  tailscale_command+="--advertise-routes=$tailscale_subnet_space "
fi

### TAILSCALE SUBNET ROUTER TWEAKS
if [[ $tailscale_subnet == true ]]; then
  echo -e "net.ipv4.ip_forward = 1" | doas tee -a /etc/sysctl.d/99-tailscale.conf >/dev/null
  echo -e "net.ipv6.conf.all.forwarding = 1" | doas tee -a /etc/sysctl.d/99-tailscale.conf >/dev/null
  doas sysctl -p /etc/sysctl.d/99-tailscale.conf
fi

### START TAILSCALE
doas tailscale up $tailscale_command
