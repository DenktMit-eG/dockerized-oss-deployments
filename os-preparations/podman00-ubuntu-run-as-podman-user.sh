#!/bin/bash

# Exit on error, print commands, treat unset variables as errors, and ensure pipeline fails on error
set -eu -o pipefail

source .env

echo "HOSTNAME: ${HOSTNAME}"
echo "LETS_ENCRYPT_EMAIL: ${LETS_ENCRYPT_EMAIL}"
echo "PODMAN_COMMENT: ${PODMAN_COMMENT}"
echo "PODMAN_PASSWORD: ${PODMAN_PASSWORD}"
echo "PODMAN_USER: ${PODMAN_USER}"

./podman01-ubuntu-podman-start-socket.sh