#!/usr/bin/env bash

# create namespace
sudo kubectl apply -f ./namespaces/flux-system/namespace.yaml


# install flux
sudo helm repo add fluxcd https://charts.fluxcd.io
sudo helm upgrade flux fluxcd/flux --wait \
--install \
--namespace flux-system \
--version=1.3.0 \
--set git.url=git@github.com:Rubru94/gitops-get-started \
--set git.branch=master \
--set git.path=namespaces \
--set git.pollInterval=5m \
--set sync.interval=2m \
--set manifestGeneration=false \
--set registry.automationInterval=2m \
#--set registry.includeImage="*/mmorejon/*" \
--set syncGarbageCollection.enabled=true \
--set syncGarbageCollection.dry=true \
--set memcached.hostnameOverride=flux-memcached.flux-system

# install flux-helm-operator
sudo helm upgrade helm-operator fluxcd/helm-operator --wait \
--install \
--namespace flux-system \
--version=1.0.1 \
--set createCRD=false \
--set git.ssh.secretName=flux-git-deploy \
--set chartsSyncInterval=2m \
--set helm.versions=v3