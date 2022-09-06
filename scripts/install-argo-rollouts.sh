#!/bin/bash

set -euo pipefail

NC='\033[0m'
CYAN='\033[0;36m'

echo -e "${CYAN}Installing argo-rollouts controller...${NC}"

kubectl create namespace argo-rollouts
kubectl apply -n argo-rollouts -f https://github.com/argoproj/argo-rollouts/releases/latest/download/install.yaml
kubectl create namespace rollout-demo
kubectl label namespace rollout-demo istio-injection=enabled
