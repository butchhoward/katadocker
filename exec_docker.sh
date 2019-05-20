#!/usr/bin/env bash 
# shellcheck disable=SC2154
set -x

USAGE="exec_docker.sh CONTAINER_ID [other options to pass along to docker exec]"

function usage
{
    printf "%s\n"  'Usage:'
    printf "%s\n"  "${USAGE}"
    printf "%s\n" "\tCONTAINER_ID"
    printf "%s\n"  "\t\tContainer ID for an running container "
    printf "%s\n"  "\t\tbuilt using the build_docker.sh script and run using the run_docker.sh"
    printf "%s\n"  "\toptional extra options"
    printf "%s\n"  "\t\tany extra options will be used in the docker exec command"
    printf "%s\n"  "\t\tafter the pre-defined options and before the container id."
    printf "%s\n"  ""
    printf "%s\n"  ""
    printf "%s\n"  "The current user's home folder is mapped as a volume in the container."
    printf "%s\n"  "The current user is added to the users in the container and made current."
    printf "%s\n"  "The entrypoint.sh script is run as the command inside the container. This puts you"
    printf "%s\n"  "on a command line in the terminal at start."
    printf "%s\n"  ""
    printf "%s\n"  "\tExamples:"
    printf "%s\n"  "\t\t$ ./run_docker.sh katadocker:ubuntu16"
    printf "%s\n"  "\t\t$ ./run_docker.sh katadocker:ubuntu16 -p 8080:8080"
    exit 1
}

if [ $# -lt 1 ]; then
    usage
fi 

DOCKER_CONTAINER=${1:?${USAGE}}
shift

LOCAL_USER_NAME="$(id -un)"

docker exec -it \
    -e LOCAL_PWD="$(pwd)" \
    -e SSH_AUTH_SOCK="${SSH_AUTH_SOCK}" \
    -e LOCAL_USER_NAME="${LOCAL_USER_NAME}" \
    -e LOCAL_USER_ID="$(id -u)" \
    -e LOCAL_GROUP_ID="$(id -g)" \
    -e LOCAL_HTTPS_PROXY="${https_proxy}" \
    -e LOCAL_HTTP_PROXY="${http_proxy}" \
    -e DOCKER_EXEC=1 \
    "$@"     \
    "${DOCKER_CONTAINER}" \
    entrypoint.sh
    