#!/bin/bash

REPOSITORY_PATH=.
REPOSITORY_NAME=${1:-"kata-docker"}
VERSION=${2:-"16.04"}

docker build --rm \
    -t ${REPOSITORY_NAME}:${VERSION} ${REPOSITORY_PATH}