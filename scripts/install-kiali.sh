#!/bin/bash

set -euo pipefail

NC='\033[0m'
CYAN='\033[0;36m'

echo -e "${CYAN}Installing Kiali...${NC}"

helm install \
  --namespace istio-system \
  --set auth.strategy="anonymous" \
  --set external_services.prometheus.url="http://prometheus-server.prometheus.svc.cluster.local:80" \
  --repo https://kiali.org/helm-charts \
  kiali-server \
  kiali-server
