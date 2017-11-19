#!/bin/bash

function usage
{
    echo 'Usage:'
    echo 'docker run -it -v ${HOME}:${HOME}'
    echo '    -e LOCAL_PWD=$(pwd)'
    echo '    -v $(dirname ${SSH_AUTH_SOCK}):$(dirname $SSH_AUTH_SOCK})'
    echo '    -e SSH_AUTH_SOCK=${SSH_AUTH_SOCK}'
    echo '    -e LOCAL_USER_NAME=$(id -un)'
    echo '    -e LOCAL_USER_ID=$(id -u)'
    echo '    -e LOCAL_GROUP_ID=$(id -g)'
    echo '    [ -e LOCAL_HTTPS_PROXY=<host_https_proxy_value> ]'
    echo '    [ -e LOCAL_HTTP_PROXY=<host_http_proxy_value> ]'
    echo '    [ -e DOCKER_EXEC=1]'
    echo '    <image_name>:<version>'
    exit 1
}


[ -n "${LOCAL_HTTPS_PROXY}" ] && export https_proxy="${LOCAL_HTTPS_PROXY}"
[ -n "${LOCAL_HTTP_PROXY}" ] && export http_proxy="${LOCAL_HTTP_PROXY}"

USER_NAME=${LOCAL_USER_NAME:user}
USER_ID=${LOCAL_USER_ID:-9001}
GROUP_ID=${LOCAL_GROUP_ID:-9001}

# # DOCKER_EXEC is set when using the docker exec command
# # in that case we are attaching a new tty to a running container
# # and do not need to do some of the user business
if [ -z ${DOCKER_EXEC+1} ]; then
    #not using the groupid because that does not seem to work when hosting on OSX
    addgroup  ${USER_NAME}

    EXISTING_USER=$(getent passwd ${USER_ID} | cut -d: -f1)
    if [ -n "${EXISTING_USER}" ]; then
        echo "Existing user found: '${EXISTING_USER}'"
        deluser ${EXISTING_USER} 
    fi
    adduser --no-create-home --disabled-password --gecos GECOS --uid $USER_ID --ingroup ${USER_NAME} ${USER_NAME}
    adduser ${USER_NAME} sudo
fi

export HOME=/home/${USER_NAME}
su - ${USER_NAME}