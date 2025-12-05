#!/bin/bash

### INTERNAL VARIABLES

### USER INPUT VARIABLES
read -p '[OPTIONAL] CHANGE HOSTNAME [true/FALSE]: ' set_hostname < /dev/tty
set_hostname=${set_hostname:-false}

if [[ $set_hostname == true ]]; then
  read -p '[REQUIRED] DESIRED HOSTNAME: ' desired_hostname < /dev/tty

  if [[ -z $desired_hostname ]]; then
    echo "ERROR: DESIRED HOSTNAME REQUIRED... Exiting"
    exit 1
  fi
fi

read -p '[OPTIONAL] SET STATIC IP [true/FALSE]: ' set_network_static < /dev/tty
set_network_static=${set_network_static:-false}

if [[ $set_network_static == true ]]; then
  read -p '[REQUIRED] STATIC IP ADDRESS: [1.2.3.4/24]' desired_network_static_address < /dev/tty

  if [[ -z $desired_network_static_address ]]; then
    echo "ERROR: STATIC IP ADDRESS REQUIRED... Exiting"
    exit 1
  fi

  read -p '[REQUIRED] GATEWAY: [1.2.3.4]' desired_network_static_gateway < /dev/tty

  if [[ -z $desired_network_static_gateway ]]; then
    echo "ERROR: GATEWAY REQUIRED... Exiting"
    exit 1
  fi

  read -p '[REQUIRED] DNS: [1.2.3.4]' desired_network_static_dns < /dev/tty

  if [[ -z $desired_network_static_dns ]]; then
    echo "ERROR: DNS REQUIRED... Exiting"
    exit 1
  fi
fi

read -p '[OPTIONAL] REBOOT SYSTEM WHEN COMPLETE [TRUE/false]: ' reboot < /dev/tty
reboot=${reboot:-true}

### UPDATE OS
sudo dnf update -y && sudo dnf clean all >/dev/null 2>&1

### SET HOSTNAME
if [[ $set_hostname == true ]]; then
  sudo hostnamectl set-hostname $desired_hostname >/dev/null 2>&1
fi

### SET STATIC IP
if [[ $set_network_static == true ]]; then
  ### FIND ACTIVE ETHERNET CONNECTION
  connection=$(sudo nmcli connection show | grep ethernet | awk '{print $1}' >/dev/null 2>&1)

  ### SET STATIC IP
  sudo nmcli connection modify "$connection" ipv4.method manual ipv4.addresses $desired_network_static_address ipv4.gateway $desired_network_static_gateway ipv4.dns "$desired_network_static_dns" >/dev/null 2>&1

  ### RESTART NETWORK
  sudo nmcli connection up "$connection"
fi

### REBOOT
if [[ $reboot == true ]]; then
  sleep 10
  sudo shutdown -r now
fi
