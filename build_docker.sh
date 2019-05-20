#!/usr/bin/env bash 

USAGE="usage:  build_docker.sh name:tag dockerfile"

if [ $# -lt 2 ]; then
    echo "${USAGE}"
    exit 1
fi 

REPOSITORY_PATH=.
DOCKER_IMAGE=${1:?${USAGE}}
DOCKER_FILE=${2:?${USAGE}}

docker build --rm \
    -t "${DOCKER_IMAGE}" "${REPOSITORY_PATH}" -f "${DOCKER_FILE}"
