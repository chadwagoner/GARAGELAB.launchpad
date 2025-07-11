#!/bin/bash

### SET APK REPOSITORIES
doas curl -sL -o /etc/apk/repositories -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/alpine-linux/templates/apk/repositories

### UPDATE OS
doas apk upgrade -U --quiet

### RUN SYNC BEFORE REBOOT
doas sync

### SLEEP
sleep 60

### REBOOT
doas reboot
