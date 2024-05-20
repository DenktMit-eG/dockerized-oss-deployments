#!/bin/bash

# Exit on error, print commands, treat unset variables as errors, and ensure pipeline fails on error
set -eu -o pipefail

# Check if the script is running with sudo privileges
if [ "$EUID" -ne 0 ]; then
    echo "This script requires sudo privileges. Please run with sudo."
    exit 1
fi

apt-get update && apt-get dist-upgrade -y
apt-get install podman podman-compose podman-docker -y