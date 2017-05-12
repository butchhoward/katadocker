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
    echo '    <image_name>:<version>'
    exit 1
}

[ -z "${LOCAL_PWD}" ] && usage
[ -z "${SSH_AUTH_SOCK}" ] && usage
[ -z "${LOCAL_USER_NAME}" ] && usage
[ -z "${LOCAL_USER_ID}" ] && usage
[ -z "${LOCAL_GROUP_ID}" ] && usage

[ -n "${LOCAL_HTTPS_PROXY}" ] && export https_proxy="${LOCAL_HTTPS_PROXY}"
[ -n "${LOCAL_HTTP_PROXY}" ] && export http_proxy="${LOCAL_HTTP_PROXY}"

PREVIOUS_USER_NAME="$(getent passwd ${LOCAL_USER_ID} | cut -d: -f1)"
if [ -n "${PREVIOUS_USER_NAME}" ]
then
    deluser ${PREVIOUS_USER_NAME} >/dev/null 2>&1
    delgroup ${PREVIOUS_USER_NAME} >/dev/null 2>&1
fi

addgroup --gid ${LOCAL_GROUP_ID} ${LOCAL_USER_NAME} >/dev/null 2>&1
adduser --no-create-home \
    --disabled-password \
    --gecos '' \
    --uid ${LOCAL_USER_ID} \
    --ingroup ${LOCAL_USER_NAME} \
    ${LOCAL_USER_NAME} >/dev/null 2>&1
adduser ${LOCAL_USER_NAME} sudo >/dev/null 2>&1

cd "${LOCAL_PWD}" || cd "/home/${LOCAL_USER_NAME}"
su ${LOCAL_USER_NAME}