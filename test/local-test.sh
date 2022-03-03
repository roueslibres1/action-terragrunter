#!/bin/bash

# This is a script for easily running the local testing
# Comes very handy in local development

TF_VERSION='1.1.7'
TG_VERSION='v0.36.3'
TF_WORKING_DIR='/var/opt'
#TF_SUBCOMMAND='fmt'
#TG_LOCAL_WORK_DIR="$(pwd)"  # TODO, provide some path which has the terragrunt code

function build_docker {
    echo "INFO: Building docker image"
    docker build -t tg .
}

function run_docker {
    echo "INFO: Test running docker"
    docker run -it \
        -e INPUT_TF_ACTIONS_VERSION=$TF_VERSION \
        -e INPUT_TG_ACTIONS_VERSION=$TG_VERSION \
        -e INPUT_TF_ACTIONS_SUBCOMMAND="$TF_SUBCOMMAND" \
        -e INPUT_TF_ACTIONS_WORKING_DIR="$TF_WORKING_DIR" \
        -e GOOGLE_CREDENTIALS="$GOOGLE_CREDENTIALS" \
        -e TF_VAR_GCS_BUCKET="$TF_VAR_GCS_BUCKET" \
        -v $TG_LOCAL_WORK_DIR:$TF_WORKING_DIR \
        tg "$*"
}

function main {

    # Build the image
    build_docker
    TF_SUBCOMMAND=$1
    shift
    echo $*
    # test run it
    run_docker "$*"
}

main "$*"