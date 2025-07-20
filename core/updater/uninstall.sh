#!/bin/bash

### REMOVE CORE-UPDATER
if [[ -e /etc/periodic/weekly/core-updater ]]; then
  doas rm /etc/periodic/weekly/core-updater
else
  echo "ERROR: CORE-UPDATER DOES NOT EXIST... EXITING"
  exit 1
fi
