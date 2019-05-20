#!/usr/bin/env bash 

# Expected usage for the entrypoint.sh for the docker image
    #  docker run -it -v ${HOME}:${HOME}
    #      -e LOCAL_PWD=$(pwd)
    #      -v $(dirname ${SSH_AUTH_SOCK}):$(dirname $SSH_AUTH_SOCK})
    #      -e SSH_AUTH_SOCK=${SSH_AUTH_SOCK}
    #      -e LOCAL_USER_NAME=$(id -un)
    #      -e LOCAL_USER_ID=$(id -u)
    #      -e LOCAL_GROUP_ID=$(id -g)
    #      [ -e LOCAL_HTTPS_PROXY=<host_https_proxy_value> ]
    #      [ -e LOCAL_HTTP_PROXY=<host_http_proxy_value> ]
    #      [ -e DOCKER_EXEC=1]
    #      <image_name>:<version>


[ -n "${LOCAL_HTTPS_PROXY}" ] && export https_proxy="${LOCAL_HTTPS_PROXY}"
[ -n "${LOCAL_HTTP_PROXY}" ] && export http_proxy="${LOCAL_HTTP_PROXY}"

USER_NAME=${LOCAL_USER_NAME:-user}
USER_ID=${LOCAL_USER_ID:-9001}

# # DOCKER_EXEC is set when using the docker exec command
# # in that case we are attaching a new tty to a running container
# # and do not need to do some of the user business
if [ -z ${DOCKER_EXEC+1} ]; then
    #not using the groupid because that does not seem to work when hosting on OSX
    addgroup --force-badname "${USER_NAME}"

    EXISTING_USER=$(getent passwd "${USER_ID}" | cut -d: -f1)
    if [ -n "${EXISTING_USER}" ]; then
         "Existing user found: '${EXISTING_USER}'"
        deluser "${EXISTING_USER}" 
    fi
    adduser --force-badname --no-create-home --disabled-password --gecos GECOS --uid "${USER_ID}" --ingroup "${USER_NAME}" "${USER_NAME}"
    adduser "${USER_NAME}" sudo
fi

export HOME=/home/${USER_NAME}
su - "${USER_NAME}"
