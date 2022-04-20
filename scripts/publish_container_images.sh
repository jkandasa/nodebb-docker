#!/bin/bash

GIT_TAG=$(echo $GITHUB_REF | sed 's/refs\/tags\///g')

# backup Docker file
mkdir docker-repo
cp Dockerfile docker-repo/Dockerfile

# download NodeBB source code
wget https://github.com/NodeBB/NodeBB/archive/refs/tags/${GIT_TAG}.zip -O NodeBB.zip
unzip NodeBB.zip
rm NodeBB.zip
mv NodeBB*/* .
ls -alh
cp install/package.json package.json

# container registry
REGISTRY='quay.io/jkandasa'
ALT_REGISTRY='docker.io/jkandasa'
#PLATFORMS="linux/arm/v7,linux/arm64,linux/amd64,linux/386,linux/ppc64le,linux/s390x"
PLATFORMS="linux/arm64,linux/amd64"
IMAGE_TAG=${GIT_TAG}

# build and push to quay.io
docker buildx build --push \
  --progress=plain \
  --platform ${PLATFORMS} \
  --file Dockerfile.buildx \
  --tag ${REGISTRY}/nodebb-alpine:${IMAGE_TAG} .

# build and push to docker.io
docker buildx build --push \
  --progress=plain \
  --platform ${PLATFORMS} \
  --file Dockerfile.buildx \
  --tag ${ALT_REGISTRY}/nodebb-alpine:${IMAGE_TAG} .
