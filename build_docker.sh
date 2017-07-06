#!/bin/bash

REPOSITORY_PATH=.
DOCKER_IMAGE=${1:?"Image 'name:tag' designation is required"}
DOCKER_FILE=${2:?"Dockerfile required"}

docker build --rm \
    -t ${DOCKER_IMAGE} ${REPOSITORY_PATH} -f ${DOCKER_FILE}