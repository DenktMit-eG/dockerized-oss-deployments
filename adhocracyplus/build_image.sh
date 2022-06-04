#!/usr/bin/env bash
set -u
set -o pipefail
set -x

readonly IMAGE_NAME=adhocracyplus
readonly VERSION_TAG=2202.2
readonly FULL_IMAGE_TAG=${IMAGE_NAME}:${VERSION_TAG}

docker build -f Dockerfile --tag ${FULL_IMAGE_TAG} --progress=plain .