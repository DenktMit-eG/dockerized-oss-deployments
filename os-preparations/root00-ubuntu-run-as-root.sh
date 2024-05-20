#!/bin/bash

# Exit on error, print commands, treat unset variables as errors, and ensure pipeline fails on error
set -eu -o pipefail

# Check if the script is running with sudo privileges
if [ "$EUID" -ne 0 ]; then
    echo "This script requires sudo privileges. Please run with sudo."
    exit 1
fi

source .env

echo "HOSTNAME: ${HOSTNAME}"
echo "LETS_ENCRYPT_EMAIL: ${LETS_ENCRYPT_EMAIL}"
echo "PODMAN_COMMENT: ${PODMAN_COMMENT}"
echo "PODMAN_PASSWORD: ${PODMAN_PASSWORD}"
echo "PODMAN_USER: ${PODMAN_USER}"

./root01-ubuntu-map-https-to-unprivileged-ports.sh "${PODMAN_USER}" "${PODMAN_PASSWORD}" "${PODMAN_COMMENT}" "sudo" "docker"
./root02-ubuntu-install-podman.sh
./root03-ubuntu-create-new-user.sh
