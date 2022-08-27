# Progressive Delivery
Progressive delivery demo using canary deployments with Kubernetes and Argo Rollouts

## Pre-requisites
- Make
- [Docker](https://docs.docker.com/get-docker/)
- [Golang](https://go.dev/doc/install)
- [Kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Kind](https://kind.sigs.k8s.io/docs/user/quick-start#installation)
- [Helm](https://helm.sh/docs/intro/install/)
- [Argo Rollouts Kubectl plugin](https://argoproj.github.io/argo-rollouts/installation/) (optional)
- [npm](https://nodejs.org/en/download/) (optional)

## Make commands

Everything is configured through Make to keep it simple

| Target             | Description 
| :-----------------:|----------------
| `verify-prereqs`   | Verifies you have all dependencies installed


