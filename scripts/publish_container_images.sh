#!/bin/bash

GIT_TAG=$(echo $GITHUB_REF | sed 's/refs\/tags\///g')

# download install/package.json
wget https://raw.githubusercontent.com/NodeBB/NodeBB/${GIT_TAG}/install/package.json

# container registry
REGISTRY='quay.io/jkandasa'
ALT_REGISTRY='docker.io/jkandasa'
#PLATFORMS="linux/arm/v7,linux/arm64/v8,linux/amd64,linux/386,linux/ppc64le,linux/s390x"
PLATFORMS="linux/amd64,linux/386,linux/ppc64le,linux/s390x"
IMAGE_TAG=${GIT_TAG}

# build and push to quay.io
docker buildx build --push \
  --progress=plain \
  --platform ${PLATFORMS} \
  --file Dockerfile \
  --tag ${REGISTRY}/nodebb-alpine:${IMAGE_TAG} .

# build and push to docker.io
docker buildx build --push \
  --progress=plain \
  --platform ${PLATFORMS} \
  --file Dockerfile \
  --tag ${ALT_REGISTRY}/nodebb-alpine:${IMAGE_TAG} .