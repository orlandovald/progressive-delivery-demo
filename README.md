# Progressive Delivery
Progressive delivery demo using canary deployments with Kubernetes and Argo Rollouts

## Pre-requisites
- Make
- [Docker](https://docs.docker.com/get-docker/)
- [Kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Kind](https://kind.sigs.k8s.io/docs/user/quick-start#installation)
- [Helm](https://helm.sh/docs/intro/install/)
- [Argo Rollouts Kubectl plugin](https://argoproj.github.io/argo-rollouts/installation/) (optional)

## Set up

Everything is configured through Make to keep it simple. Just follow these steps.

### 1. Verify dependencies
This will check for all required and optional dependencies

```shell
$ make verify-prereqs
```

You can continue with the next step once you have all required dependencies.

### 2. Create cluster
The below command will create a Kind cluster named `argo-rollouts-demo` and will install the Argo Controller and CRDs, Prometheus, Istio and Kiali.

```shell
$ make cluster-up
```

### 3. Build sample service images
This command will create a few image tags for our test service

```shell
$ make build-images
```

### 3. Load images to your cluster
Before being able to use images in a Kind cluster, you need to load them first. The below command will take care of that.

```shell
$ make load-images
```

### 4. Deploy first version
Run the below command to deploy the `green` tag version of the service. Since this is the initial deployment, steps/analysis will be skipped and the deployment will become stable as soon as the pods are healthy.

```shell
$ make helm-upgrade
```

### 5. Open the demo app
Open http://localhost:8080/ in your browser to see the demo app. All squares should report back as `green`

### 6. Deploy a canary version

You can use the below command to deploy a canary version. Valid `VERSION` values are `green`, `blue`, `yellow` and `brown`. Version `yellow` simulates a 50% error rate which would fail the error-rate analysis.

```shell
$ make helm-upgrade VERSION=blue
```

You can watch the rollout using the below command (requires the Argo Kubectl plugin),

```shell
$ make watch
```

## Other helpful make commands

```shell
$ make helm-uninstall # removes the rollout in case you want to deploy from scracth
$ make delete-cluster # deletes the cluster creating during cluster-up
```

## Open Kiali

If you want to open the Kiali Web App run the below command (this will block the shell),

```shell
$ kubectl port-forward svc/kiali 20001:20001 -n istio-system
```

Now you can open Kiali in your browser at http://localhost:20001/

## Open Prometheus

If you want to access the Prometheus UI run the below command (this will block the shell),

```shell
$ kubectl port-forward service/prometheus-server 9090:80 -n prometheus
```

Now you can open Prometheus in your browser at http://localhost:9090/