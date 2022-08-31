#!/usr/bin/env bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

cd $SCRIPT_DIR

echo "Building WebContainer Main Core Build"
docker build -t vooplv/webcontainer:core .

echo "Building WebContainer Nginx Build"
cd $SCRIPT_DIR/nginx-build
docker build -t vooplv/webcontainer:nginx .

echo "Building WebContainer Openresty Build"
cd $SCRIPT_DIR/openresty-build
docker build -t vooplv/webcontainer:openresty .