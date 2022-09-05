#!/bin/bash

set -euo pipefail

NC='\033[0m'
CYAN='\033[0;36m'

echo -e "${CYAN}Installing Istio...${NC}"

helm repo add istio https://istio-release.storage.googleapis.com/charts
helm repo update
kubectl create namespace istio-system
helm install istio-base istio/base -n istio-system
helm install istiod istio/istiod -n istio-system --wait
kubectl create namespace istio-ingress
kubectl label namespace istio-ingress istio-injection=enabled
helm install istio-ingress istio/gateway -n istio-ingress --wait -f ./cluster/istio-values.yaml
