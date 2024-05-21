#!/bin/bash

# see blog article "Using Traefik with Podman" for reference
# https://blog.cthudson.com/2023-11-02-running-traefik-with-podman/
#
# we want to run our Docker containers and also Traefik with user level
# privileges using Podman. Some preparations need to be done.

# Exit on error, print commands, treat unset variables as errors, and ensure pipeline fails on error
set -eu -o pipefail

# Start socket for current session of unprivileged user
systemctl --user start podman.socket

# Start socket for unprivileged user on boot
systemctl --user enable podman.socket

# Allow long-running processes even when user logs out. Otherwise
# the docker processes started by the user will terminate
loginctl enable-linger $UID

# Verifying setup
podman run --it --rm quay.io/podman/hello

# create an combined IPv4 and IPv6 network
podman network create \
  --subnet 10.89.0.0/16 \
  --subnet fd00:dead:beef::/48 \
  --gateway 10.89.0.1 \
  --gateway fd00:dead:beef::1 \
  proxy

# Verify network
podman network inspect proxy