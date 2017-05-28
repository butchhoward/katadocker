#!/bin/bash

#specific to running on OSX:
DOCKER_IMAGE=${1:-"kata-docker:16.04"}
shift

LOCAL_USER_NAME=$(id -un)

docker run -it -v ${HOME}:/home/${LOCAL_USER_NAME} \
    -e LOCAL_PWD=$(pwd) \
    -v $(dirname ${SSH_AUTH_SOCK}):$(dirname $SSH_AUTH_SOCK}) \
    -e SSH_AUTH_SOCK=${SSH_AUTH_SOCK} \
    -e LOCAL_USER_NAME=${LOCAL_USER_NAME} \
    -e LOCAL_USER_ID=$(id -u) \
    -e LOCAL_GROUP_ID=$(id -g) \
    -e LOCAL_HTTPS_PROXY=${https_proxy} \
    -e LOCAL_HTTP_PROXY=${http_proxy} \
    $@ \
    ${DOCKER_IMAGE}