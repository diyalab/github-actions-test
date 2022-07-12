#!/bin/bash
set -v #echo on
set -e #fail on error
# mkdir -p /root/.ssh
mkdir -p ~/.ssh/
echo "$GITLAB_SSH_PRIVATE_KEY" > ~/.ssh/id_rsa
ssh-keyscan -H gitlab.dev.spotdraft.com > ~/.ssh/known_hosts
chmod 600 ~/.ssh/id_rsa
apk add --no-cache git && apk add yq
yq --version
git config --global user.name "siva"
git config --global user.email "siva@spotdraft.com"
git clone --single-branch --branch master git@gitlab.dev.spotdraft.com:sd/argo-manifests.git