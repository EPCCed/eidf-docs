# Advanced usage of DevSpace

In the last section we saw how to use DevSpace to launch a simple Jupyter Notebook
project on the K8s cluster with GPU support. In this section we will discuss
further configuration of DevSpace including

  - how to use it to manage a local image cluster and build custom docker images
  - how to deploy cluster frameworks like dask
  - how to customise your resource requests

## Setting up DevSpace in your project

To start using DevSpace in your project, create a `devspace.yaml` file at the top level of your project directory/repo.
It should contain

``` yaml
version: v2beta1
name: <the-name-of-your-project>

# Use defined variables that can be used in this configuration file.
vars:
  IMAGEREG_NAME: $(echo registry-$(whoami))
  IMAGEREG_DEVSPACE: ../eidf-devspace-imagereg/

# Imports from other devspaces. This one is for patching the image registry.
imports:
  - path: ${IMAGEREG_DEVSPACE}
```

The `version` is mandatory and directly from the DevSpace configuration spec.
The `vars` are EIDF specific and help us to manage the local image registry.
`imports` includes our customised template for the DevSpace image registry to make it compatible with EIDFGPUS K8s.

## Adding customised container images to your DevSpace

Images can be customised using Docker files.
Any number of images can be built and utilised by your DevSpace.
Normally, images would be built manually by the user and submitted to an image registry online such as Docker Hub.
This can be slow for large images (both upload and download) and it is typically more efficient to keep the images local to the cluster.

You can deploy a local image registry to your project `NameSpace` in the K8s cluster using DevSpace and the example `eidf-devspace-imagereg` repository.
Image building and storage is then handled by the cluster.
You do not need to install `docker` on your VM.

To include an image in your DevSpace project, add the following to your `devspace.yaml`.

``` yaml
images:
  rapids:
    image: ${USER}/rapids
    dockerfile: rapids/docker/Dockerfile
```

The specification of `images` is available in the DevSpace [documentation](https://www.devspace.sh/docs/configuration/images/).

In short, `images` contains a mapping of image names (`rapids` is one) with the `image` name and a relative path to a `Dockerfile`.
`image` may also be a direct link to an online image and tag if you wish to cache the image locally.

Our `Dockerfile` can modify the image in anyway.
We start by specify the image we wish to use as a base. here that is the `rapidsai-core` image.
Additional software or settings can be applied in the `CUSTOMIZE` section, but in this case we simply create and enter a new directory called `/app`.

``` dockerfile
# https://catalog.ngc.nvidia.com/orgs/nvidia/teams/rapidsai/containers/rapidsai-core/tags
FROM nvcr.io/nvidia/rapidsai/rapidsai-core:cuda11.8-runtime-ubuntu22.04-py3.10

### CUSTOMIZE HERE

### END CUSTOMIZATION

RUN mkdir /app
WORKDIR /app
```

More information on customising the image is available in the template repository [here]().

## Starting a Jupyter notebook

To use DevSpace to setup and interact with a Jupyter notebook we need to create three new sections in our `devspace.yaml`.
The first is a deployment. Deployments in devspace describe either a Helm chart with specific values or a Kubernetes manifest.
Think of a deployment as what you need to run an application.
For Jupyter, we can use a convenient Helm chart provided DevSpace called a [component-chart](https://www.devspace.sh/component-chart/docs/introduction).

We add our deployment definition and component-chart values to our `devspace.yaml`.

``` yaml
deployments:
  rapids: # our deployment name
    helm:
      chart:
        name: component-chart
        repo: https://charts.devspace.sh
      values: # values for our helm chart
        containers:
          - image: ${USER}/rapids # the name of our image from the local registry
            resources:
              limits:
                cpu: 4
                memory: 20Gi
                nvidia.com/gpu: 1
              requests:
                cpu: 2
                memory: 1Gi
                nvidia.com/gpu: 1
        nodeSelector:
          nvidia.com/gpu.product: NVIDIA-A100-SXM4-40GB
        labels:
          eidf/user: ${USER}
```

In this case, we specify the mandatory resources definitions, and a single container which references our image from our local registry (or any remote registry).
The `nodeSelector` section allows us to specify the type of GPU we wish to secure, otherwise the first available GPU will be provided.

We can check our deployment using the command

``` bash
$ devspace deploy
```

This will provide a fair amount of output and take a while, especially if it is the first time the image has been build. When the build is finished, DevSpace will create the deployment.

Checkout the deployment status with

``` bash
$ kubectl get pods
NAME                         READY   STATUS    RESTARTS   AGE
pod/rapids-7f9dc7d65-mh2n8   1/1     Running   0          51s
pod/registry-thgcd-0         2/2     Running   0          45m
```

This shows the rapids pod is up and running with our image.

To access the Jupyter notebook we must now add one more section to our `devspace.yaml`.
The first modifies the deployment and includes the following configuration:

- The syncing of files between our VM to the container.
- The forwarding of the port where our Jupyter server is running to our local VM.

``` yaml
dev:
  rapids:
    # Search for the container that runs this image
    labelSelector:
       app.kubernetes.io/component: rapids
       eidf/user: ${USER}
    # Replace the container image with this dev-optimized image (allows to skip image building during development)
    devImage: ${USER}/rapids
    terminal:
      command: jupyter lab --allow-root
    resources:
      limits:
        cpu: 4
        memory: 20Gi
        nvidia.com/gpu: 1
      requests:
        cpu: 2
        memory: 1Gi
        nvidia.com/gpu: 1
    # Sync files between the devspace folder and the development container
    sync:
      - path: ./:/app
    ports:
      # remote:local
      - port: "8888:8888"
```

To start the development modifications, use the command `devspace deploy`.

> The template repository uses a slightly different approach.
`devspace dev` will return a shell session on the rapids container.
To get Jupyter, use the command `devspace dev -p jupyter`.

You should now be able to use the output of Jupyter server you see (including the token) to access your Jupyter lab instance.



## Cleaning up DevSpace

To remove your running deployments from the server, use the command `devspace purge`.
This does not remove the image registry, which must be removed using the command `devspace cleanup local-registry`.
