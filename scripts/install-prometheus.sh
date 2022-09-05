#!/bin/bash

set -euo pipefail

NC='\033[0m'
CYAN='\033[0;36m'

echo -e "${CYAN}Installing Prometheus...${NC}"

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm upgrade --install -n prometheus --create-namespace prometheus prometheus-community/prometheus
