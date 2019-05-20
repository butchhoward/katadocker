#!/usr/bin/env bash 
# shellcheck disable=SC2154

USAGE="run_docker.sh name:tag [other options to pass along to docker run]"

function usage
{
    printf "%s\n"  'Usage:'
    printf "%s\n"  "${USAGE}"
    printf "%s\n"  "\tname:tag"
    printf "%s\n"  "\t\tname and (optional) tag for an existing docker image"
    printf "%s\n"  "\t\tbuilt using the build_docker.sh script"
    printf "%s\n"  "\toptional extra options"
    printf "%s\n"  "\t\tany extra options will be used in the docker run command"
    printf "%s\n"  "\t\tafter the pre-defined options and before the docker image tag."
    printf "%s\n"  ""
    printf "%s\n"  ""
    printf "%s\n"  "The current user's home folder is mapped as a volume in the container."
    printf "%s\n"  "The current user is added to the users in the container and made current."
    printf "%s\n"  ""
    printf "%s\n"  "\tExamples:"
    printf "%s\n"  "\t\t$ ./run_docker.sh katadocker:ubuntu16"
    printf "%s\n"  "\t\t$ ./run_docker.sh katadocker:ubuntu16 -p 8080:8080"
    exit 1
}


if [ $# -lt 1 ]; then
    usage
fi 

DOCKER_IMAGE=${1:?${USAGE}}
shift

LOCAL_USER_NAME=$(id -un)

docker run -it -v "${HOME}":/home/"${LOCAL_USER_NAME}" \
    -e LOCAL_PWD="$(pwd)" \
    -v "$(dirname "${SSH_AUTH_SOCK}"):$(dirname "$SSH_AUTH_SOCK}")" \
    -e SSH_AUTH_SOCK="${SSH_AUTH_SOCK}" \
    -e LOCAL_USER_NAME="${LOCAL_USER_NAME}" \
    -e LOCAL_USER_ID="$(id -u)" \
    -e LOCAL_GROUP_ID="$(id -g)" \
    -e LOCAL_HTTPS_PROXY="${https_proxy}" \
    -e LOCAL_HTTP_PROXY="${http_proxy}" \
    "$@" \
    "${DOCKER_IMAGE}"
    