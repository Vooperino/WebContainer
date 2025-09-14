#!/bin/bash

SCRIPT_DIR=$(cd $(dirname $0); pwd)
ROOT_DIR=$(cd ${SCRIPT_DIR}/..; pwd)

BASE_IMAGE_NAME="vooplv/webcontainer"
BASE_TAG="dev"

function build_image() {
    local image_name=$1
    local dockerfile_path=$2
    local context_path=$3

    echo "Building image ${image_name} using Dockerfile at ${dockerfile_path}..."
    docker build -t ${image_name} -f ${dockerfile_path} ${context_path}
}

function check_image_and_remove() {
    local image_name=$1

    if docker images | grep -q "${image_name}"; then
        echo "Removing existing image ${image_name}..."
        docker rmi -f ${image_name}
    fi
}

check_image_and_remove "${BASE_IMAGE_NAME}:core-${BASE_TAG}"
check_image_and_remove "${BASE_IMAGE_NAME}:nginx-${BASE_TAG}"
check_image_and_remove "${BASE_IMAGE_NAME}:openresty-${BASE_TAG}"

build_image "${BASE_IMAGE_NAME}:core-${BASE_TAG}" "${ROOT_DIR}/Dockerfile" "${ROOT_DIR}"
build_image "${BASE_IMAGE_NAME}:nginx-${BASE_TAG}" "${ROOT_DIR}/nginx-build/Dockerfile" "${ROOT_DIR}/nginx-build"
build_image "${BASE_IMAGE_NAME}:openresty-${BASE_TAG}" "${ROOT_DIR}/openresty-build/Dockerfile" "${ROOT_DIR}/openresty-build"

docker builder prune -a -f