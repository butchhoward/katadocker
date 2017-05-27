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

[ -n "${LOCAL_HTTPS_PROXY}" ] && export https_proxy="${LOCAL_HTTPS_PROXY}"
[ -n "${LOCAL_HTTP_PROXY}" ] && export http_proxy="${LOCAL_HTTP_PROXY}"

echo "I'm in the kata-docker entrypoint"
sudo -i