#!/bin/bash

REPOSITORY_PATH=.
REPOSITORY_NAME=kata-docker
VERSION=14.04

docker build --rm \
    -t ${REPOSITORY_NAME}:${VERSION} ${REPOSITORY_PATH}