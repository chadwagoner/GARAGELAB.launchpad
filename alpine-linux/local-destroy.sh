#!/bin/bash

alpine stop launchpad && \
echo -e "PAUSING FOR 2 SECONDS" && \
sleep 2 && \
alpine delete launchpad && \
echo -e "LAUNCHPAD HAS SUCCESSFULLY BEEN DELETED"
