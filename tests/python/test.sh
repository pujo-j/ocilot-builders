#!/usr/bin/env bash

CACHE_REGISTRY_PATH=docker.pkg.github.com/pujo-j/ocilot-builders/cache
DESTINATION_IMAGE=docker.pkg.github.com/pujo-j/ocilot-builders/python-test
MODULE=app

echo "Building Test Image"
docker run \
  -v "${HOME}/.config/gcloud":/root/.config/gcloud/ \
  -v "${HOME}/.docker":/root/.docker/ \
  -v "$(pwd)":/deploy/ \
  docker.pkg.github.com/pujo-j/ocilot-builders/python-builder \
  $CACHE_REGISTRY_PATH \
  $DESTINATION_IMAGE \
  $MODULE
