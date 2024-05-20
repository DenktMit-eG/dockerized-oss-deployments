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

# Verifying setup
podman run --it --rm quay.io/podman/hello