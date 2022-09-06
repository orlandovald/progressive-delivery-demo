.PHONY: verify-prereqs
verify-prereqs:
	@scripts/verify-prereqs.sh

.PHONY: cluster-up
cluster-up: install-kiali

.PHONY: create-cluster
create-cluster:
	kind create cluster --config ./cluster/kindconf.yaml
	kubectl cluster-info --context kind-argo-rollouts-demo

.PHONY: delete-cluster
delete-cluster:
	kind delete cluster --name argo-rollouts-demo

.PHONY: install-prometheus
install-prometheus: create-cluster
	@scripts/install-prometheus.sh

.PHONY: install-argo-rollouts
install-argo-rollouts: install-prometheus
	@scripts/install-argo-rollouts.sh

.PHONY: install-istio
install-istio: install-argo-rollouts
	@scripts/install-istio.sh

.PHONY: install-kiali
install-kiali: install-istio
	@scripts/install-kiali.sh

.PHONY: build-images
build-images:
	docker build . -t rollout-demo:green
	docker build . --build-arg error_chance=60 -t rollout-demo:blue
	docker build . --build-arg error_chance=0 -t rollout-demo:yellow

.PHONY: load-images
load-images:
	kind load docker-image rollout-demo:green rollout-demo:blue rollout-demo:yellow --name argo-rollouts-demo

.PHONY: watch
watch:
	@kubectl argo rollouts get rollout rollout-demo -w

# Default tag if none is specified
VERSION = green
.PHONY: helm-upgrade
helm-upgrade:
	helm upgrade -i --set image.tag=$(VERSION) -n rollout-demo  argo-rollout ./rollout-chart

.PHONY: helm-uninstall
helm-uninstall:
	helm uninstall -n rollout-demo  argo-rollout
