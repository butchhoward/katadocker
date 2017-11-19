#!/bin/bash

USAGE="run_docker.sh name:tag [other options to pass along to docker run]"

function usage
{
    echo 'Usage:'
    echo "${USAGE}"
    echo "\tname:tag"
    echo "\t\tname and (optional) tag for an existing docker image"
    echo "\t\tbuilt using the build_docker.sh script"
    echo "\toptional extra options"
    echo "\t\tany extra options will be used in the docker run command"
    echo "\t\tafter the pre-defined options and before the docker image tag."
    echo ""
    echo ""
    echo "The current user's home folder is mapped as a volume in the container."
    echo "The current user is added to the users in the container and made current."
    echo ""
    echo "\tExamples:"
    echo "\t\t$ ./run_docker.sh katadocker:ubuntu16"
    echo "\t\t$ ./run_docker.sh katadocker:ubuntu16 -p 8080:8080"
    exit 1
}


if [ $# -lt 1 ]; then
    usage
fi 

DOCKER_IMAGE=${1:?${USAGE}}
shift
echo "args: $@"

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