#!/usr/bin/env bash
echo "Building WebContainer Main Core Build"
docker build -t vooplv/webcontainer:core .

echo "Building WebContainer Nginx Build"

echo "Building WebContainer Openresty Build"