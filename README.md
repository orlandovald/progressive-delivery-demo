# Progressive Delivery
Progressive delivery demo using canary deployments with Kubernetes and Argo Rollouts

## Pre-requisites
- Make
- [Docker](https://docs.docker.com/get-docker/)
- [Kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Kind](https://kind.sigs.k8s.io/docs/user/quick-start#installation)
- [Helm](https://helm.sh/docs/intro/install/)
- [Argo Rollouts Kubectl plugin](https://argoproj.github.io/argo-rollouts/installation/) (optional)

## Make commands

Everything is configured through Make to keep it simple

| Target           | Description 
| :---------------:|----------------
| `verify-prereqs` | Verifies you have all dependencies installed
| `cluster-up`     | This will create a cluster and install argo-rollouts, istio, prometheus and kiali
| `build-images`   | Build the sample service images
| `load-images`    | Load images to the kind cluster
