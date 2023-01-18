#!/usr/bin/env bash
# Default bootstrap script
set -e -x
REGION="`echo \"${ZONE}\" | sed -e 's:\([0-9][0-9]*\)[a-z]*\$:\\1:'`"

# Set the host name
HOST_NAME=${HOST_PART}-${ZONE}-${HEX}
sudo hostnamectl set-hostname ${HOST_NAME}.${DOMAIN}
