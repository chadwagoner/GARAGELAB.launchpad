#!/bin/bash

### INTERNAL VARIABLES
apk_command="htop vim "

### USER INPUT VARIABLES
read -p '[OPTIONAL] INSTALL DRIVER - BLUETOOTH [true/FALSE]: ' install_driver_bluetooth < /dev/tty
install_driver_bluetooth=${install_driver_bluetooth:-false}

if [[ $install_driver_bluetooth == true ]]; then
  apk_command+="bluez "
fi

read -p '[OPTIONAL] INSTALL DRIVER - INTEL [true/FALSE]: ' install_driver_intel < /dev/tty
install_driver_intel=${install_driver_intel:-false}

if [[ $install_driver_intel == true ]]; then
  apk_command+="intel-media-driver intel-ucode mesa-dri-gallium "
fi

read -p '[OPTIONAL] INSTALL DOCKER [true/FALSE]: ' install_docker < /dev/tty
install_docker=${install_docker:-false}

if [[ $install_docker == true ]]; then
  apk_command+="docker docker-cli-compose "
fi

read -p '[OPTIONAL] INSTALL NFS [true/FALSE]: ' install_nfs < /dev/tty
install_nfs=${install_nfs:-false}

if [[ $install_nfs == true ]]; then
  apk_command+="nfs-utils "
fi

read -p '[OPTIONAL] INSTALL RSNAPSHOT [true/FALSE]: ' install_rsnapshot < /dev/tty
install_rsnapshot=${install_rsnapshot:-false}

if [[ $install_rsnapshot == true ]]; then
  apk_command+="rsnapshot "
fi

read -p '[OPTIONAL] INSTALL TAILSCALE [true/FALSE]: ' install_tailscale < /dev/tty
install_tailscale=${install_tailscale:-false}

if [[ $install_tailscale == true ]]; then
  apk_command+="tailscale@edge-community "
fi

read -p '[OPTIONAL] ENABLE AUTOMATIC MONTHLY UPDATES [true/FALSE]: ' enable_patchwork < /dev/tty
enable_patchwork=${enable_patchwork:-false}

read -p '[REQUIRED] IS THIS A PRIMARY DEVICE [TRUE/false]: ' primary_device < /dev/tty
primary_device=${primary_device:-true}

read -p '[OPTIONAL] REBOOT SYSTEM WHEN COMPLETE [TRUE/false]: ' reboot < /dev/tty
reboot=${reboot:-true}

### SET APK REPOSITORIES
doas curl -sL -o /etc/apk/repositories -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/alpine-linux/templates/apk/repositories

### SET ROOT CRONTAB
if [[ $primary_device == true ]]; then
  doas curl -sL -o /etc/crontabs/root -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/alpine-linux/templates/crontab/root.primary
else
  doas curl -sL -o /etc/crontabs/root -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/alpine-linux/templates/crontab/root.secondary
fi

### DISABLE IPV6 NETWORKING
echo -e "net.ipv6.conf.all.disable_ipv6 = 1" | doas tee /etc/sysctl.d/99-system.conf >/dev/null 2>&1
doas sysctl -p /etc/sysctl.d/99-system.conf >/dev/null 2>&1

### UPDATE OS
doas apk upgrade -U --quiet >/dev/null 2>&1

### INSTALL BASE PACKAGES
doas apk add -U $apk_command --quiet >/dev/null 2>&1

### INSTALL DRIVER - BLUETOOTH
if [[ $install_driver_bluetooth == true ]]; then
  ### ENABLE BOOT START
  doas rc-update add bluetooth default >/dev/null 2>&1

  ### START SERVICE
  doas rc-service bluetooth start >/dev/null 2>&1

  ### ADD LP GROUP TO USER
  doas addgroup alpine lp
fi

### INSTALL DOCKER
if [[ $install_docker == true ]]; then
  ### ENABLE BOOT START
  doas rc-update add docker default >/dev/null 2>&1

  ### START SERVICE
  doas rc-service docker start >/dev/null 2>&1

  ### ADD DOCKER GROUP TO USER
  doas addgroup alpine docker

  ### SLEEP TO ALLOW DOCKER TO START
  sleep 5

  ### CREATE DEFAULT DOCKER NETWORKS
  doas docker network create db >/dev/null 2>&1
  doas docker network create gaming >/dev/null 2>&1
  doas docker network create internal >/dev/null 2>&1
  doas docker network create management >/dev/null 2>&1
  doas docker network create proxy >/dev/null 2>&1

  ### CREATE CORE AGENTS DIRECTORY
  doas mkdir -p /opt/core-agents
  doas chown -R alpine:alpine /opt/core-agents

  ### CREATE CORE SERVICES DIRECTORY
  doas mkdir -p /opt/core-services
  doas chown -R alpine:alpine /opt/core-services

  ### CREATE DEFAULT SERVICE DIRECTORY
  doas mkdir -p /opt/services
  doas chown -R alpine:alpine /opt/services
fi

### INSTALL NFS
if [[ $install_nfs == true ]]; then
  ### ENABLE BOOT START
  doas rc-update add nfsmount boot >/dev/null 2>&1

  ### START SERVICE
  doas rc-service nfsmount start >/dev/null 2>&1
fi

### INSTALL TAILSCALE
if [[ $install_tailscale == true ]]; then
  ### ENABLE BOOT START
  doas rc-update add tailscale default >/dev/null 2>&1

  ### START SERVICE
  doas rc-service tailscale start >/dev/null 2>&1
fi

### ENABLE PATCHWORK
if [[ $enable_patchwork == true ]]; then
  ### INSTALL PATCHWORK
  doas curl -sL -o /etc/periodic/monthly/patchwork -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/alpine-linux/templates/periodic/monthly/patchwork
  doas chmod 755 /etc/periodic/monthly/patchwork
fi

### RUN SYNC
doas sync

### REBOOT
if [[ $reboot == true ]]; then
  sleep 60
  doas reboot
fi
