#!/bin/bash

SCRIPT_DIR=$(cd $(dirname $0); pwd)
ROOT_DIR=$(cd ${SCRIPT_DIR}/..; pwd)

BASE_IMAGE_NAME="webcontainer"
BASE_TAG="dev"

S_SET_ALL=true
S_SET_OPENRESTY_ONLY=false
S_SET_NGINX_ONLY=false
S_SET_CORE_ONLY=false

function print_usage() {
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  --openresty-only    Build only the OpenResty image"
    echo "  --nginx-only        Build only the Nginx image"
    echo "  --core-only         Build only the Core image"
    echo "  -h, --help          Show this help message and exit"
}

while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -h|--help)
            print_usage
            exit 0
            ;;
        --openresty-only)
            unset S_SET_ALL S_SET_OPENRESTY_ONLY
            S_SET_ALL=false
            S_SET_OPENRESTY_ONLY=true
            ;;
        --nginx-only )
            unset S_SET_ALL S_SET_NGINX_ONLY
            S_SET_ALL=false
            S_SET_NGINX_ONLY=true
            ;;
        --core-only)
            unset S_SET_ALL S_SET_CORE_ONLY
            S_SET_ALL=false
            S_SET_CORE_ONLY=true
            ;;
        *)
            echo "Error: Unrecognized option '$key'"
            print_usage
            exit 1
            ;;
    esac
    shift
done

if [ ! -z "${CI_TAG_OVERRIDE}" ]; then
    unset BASE_TAG
    BASE_TAG=${CI_TAG_OVERRIDE:-dev}
    echo "[CI] (INFO) CI_TAG_OVERRIDE is set, using tag: ${BASE_TAG}"
fi

if [ ! -z "${CI_BASENAME_OVERRIDE}" ]; then
    unset BASE_IMAGE_NAME
    BASE_IMAGE_NAME=${CI_BASENAME_OVERRIDE:-webcontainer}
    echo "[CI] (INFO) CI_BASENAME_OVERRIDE is set, using name: ${BASE_IMAGE_NAME}"
fi

function build_image() {
    local image_name=$1
    local dockerfile_path=$2
    local context_path=$3
    local is_core=$4

    if [ -z "${is_core}" ]; then
        is_core=true
    fi
    local build_args=""
    if [ "${is_core}" = false ]; then
        if [ ! -z "${CI_BASECORE_OVERRIDE}" ]; then
            build_args="--build-arg BASE_IMAGE=${CI_BASECORE_OVERRIDE}:core-${BASE_TAG}"
        else
            build_args="--build-arg BASE_IMAGE=${BASE_IMAGE_NAME}:core-${BASE_TAG}"
        fi
    fi
    
    echo "Building image ${image_name} using Dockerfile at ${dockerfile_path}..."
    docker build ${build_args} -t ${image_name} -f ${dockerfile_path} ${context_path}
}

if [ "$S_SET_ALL" = true ] || [ "$S_SET_CORE_ONLY" = true ]; then
    echo "Building Core Image..."
    docker rmi -f "${BASE_IMAGE_NAME}:core-${BASE_TAG}" || true
    build_image "${BASE_IMAGE_NAME}:core-${BASE_TAG}" "${ROOT_DIR}/Dockerfile" "${ROOT_DIR}" true
fi

if [ "$S_SET_ALL" = true ] || [ "$S_SET_NGINX_ONLY" = true ]; then
    echo "Building Nginx Image..."
    docker rmi -f "${BASE_IMAGE_NAME}:nginx-${BASE_TAG}" || true
    build_image "${BASE_IMAGE_NAME}:nginx-${BASE_TAG}" "${ROOT_DIR}/nginx-build/Dockerfile" "${ROOT_DIR}/nginx-build" false
fi

if [ "$S_SET_ALL" = true ] || [ "$S_SET_OPENRESTY_ONLY" = true ]; then
    echo "Building OpenResty Image..."
    docker rmi -f "${BASE_IMAGE_NAME}:openresty-${BASE_TAG}" || true
    build_image "${BASE_IMAGE_NAME}:openresty-${BASE_TAG}" "${ROOT_DIR}/openresty-build/Dockerfile" "${ROOT_DIR}/openresty-build" false
fi

docker builder prune -a -f