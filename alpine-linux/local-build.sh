#!/bin/bash

alpine launch --disk 20G --memory 4096 --name launchpad && \
echo -e "PAUSING FOR 5 SECONDS" && \
sleep 5 && \
alpine exec launchpad 'setup-hostname launchpad && setup-user -a -f "" alpine && reboot' && \
echo -e "\n\nWILL HAVE TO SET PASSWORD FOR ALPINE USER MANUALLY\n### alpine ssh launchpad > passwd alpine\n### su - alpine"
