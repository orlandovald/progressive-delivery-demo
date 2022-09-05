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
	docker build . -t rollout-demo:v1
	docker build . --build-arg error_chance=50 -t rollout-demo:v2
	docker build . --build-arg error_chance=2 -t rollout-demo:v3

.PHONY: load-images
load-images:
	kind load docker-image rollout-demo:v1 rollout-demo:v2 rollout-demo:v3 --name argo-rollouts-demo

.PHONY: watch
watch:
	@kubectl argo rollouts get rollout rollout-demo -w
