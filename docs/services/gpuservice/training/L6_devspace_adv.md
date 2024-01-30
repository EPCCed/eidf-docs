# Advanced usage of DevSpace

In the last section we saw how to use DevSpace to launch a simple Jupyter Notebook
project on the K8s cluster with GPU support. In this section we will discuss
further configuration of DevSpace including

  - how to use it to manage a local image registry and build custom docker images
  - how to deploy cluster frameworks like dask
  - how to customise your resource requests

This project uses a branch of the rapids repository from the last tutorial.
First clone the repository (to a new folder if necessary) and then `git checkout` the feature branch.

```bash
git clone https://git.ecdf.ed.ac.uk/epcc_k8s/devspace/eidf-devspace-rapids.git
cd eidf-devspace-rapids
git checkout feat_wimage_reg
```

## Using a local image registry

You might be wondering why it is a good idea to run a local image repository
when you can just get images from any container registry off the internet.
If you are just using vanilla images, this is probably OK but sometimes we
need to make changes to our images or add files and code to them to use them. Take for example the moments in the [previous example](./L5_devspace.md#making-modifications-to-the-template) where we added
additional packages at runtime. If you have just a few packages, maybe this
isn't a big deal, but if you have many, this can slow down the startup and
readiness of your container. A better option is to pre-install the packages to
the image by customising the image. If you are using an internet based container
registry, this requires you to have an account, build the image locally, push it
to the container registry and then download it back to the cluster for your
deployment. Doing this once is OK, but if you have to make many changes to
the image, not so much.

Enter a local registry, with a local registry housed in the K8s cluster you
get many benefits.

 - Images are built in the cluster by the cluster so they don't burden your
   local machine.
 - Iterating on your image files is faster and more direct.
 - Image downloads after they have been built are much faster, because the image
   is stored locally.
 - You don't need to make an account or remember credentials to upload the
   image.
 - You can store source code or other things you might not want to store on
   a public image registry in your container as they are not getting pushed
   to the internet.

Using DevSpace's local image registry functionality is a little tricky due
to the requirement for resource limits on the EIDF cluster in all 
deployment specs. This isn't done or supported by DevSpace but a custom
DevSpace has been created to overcome this (multiple DevSpaces can be 
dependencies or imported into each other, but that is another topic).

We have setup and tested a patch for the default DevSpace image registry deployment which you can get by importing the DevSpace [`eidf-devspace-imagereg`](https://git.ecdf.ed.ac.uk/epcc_k8s/devspace/eidf-devspace-imagereg). Add the import to your `devspace.yaml`.

```yaml
imports:
  - git: https://devspace_user:fgaTxAUNkBRh8d1rS7Th@git.ecdf.ed.ac.uk/epcc_k8s/devspace/eidf-devspace-imagereg.git
```

To start the local image registry use the command (you must have an image to build - [next section](#building-docker-images-with-devspace))

```bash
devspace build
```

the DevSpace command will get stuck with the output `local-registry: Starting Local Image Registry`. Hit <kbd>Ctrl</kbd>+<kbd>c</kbd>, and then run the command

```bash
devspace run patch-imagereg
```

This is a custom command defined in the imported DevSpace. It changes the deployment spec slightly to allow the local image registry to run.

If it was successful your image registry pod (`registry-<username>-<N>`) should be running.

```bash
kubectl get pods

NAME               READY   STATUS    RESTARTS   AGE
registry-thgcd-0   2/2     Running   0          20m
```

You can then run the `deploy` or `build` commands with DevSpace.
Your custom image will then be build for the first time in the cluster, and
you will get some output from the `Dockerfile` image build.

```bash
deploy:rapids Deploying chart /home/eidf076/eidf076/thgcd/.devspace/component-chart/component-chart-0.9.1.tgz (rapids) with helm...
deploy:image-registry Deploying chart  (image-registry) with helm...
deploy:rapids Deployed helm chart (Release revision: 2)
deploy:rapids Successfully deployed rapids with helm
deploy:image-registry Deployed helm chart (Release revision: 4)
deploy:image-registry Successfully deployed image-registry with helm
info Using namespace 'testtony'
info Using kube context 'devgpu'
local-registry: Starting Local Image Registry
build:dask-rapids Building image 'thgcd.kubernetes.tld/rapids:MNxndGt' with engine 'localregistry'
build:dask-rapids #1 [internal] load remote build context
build:dask-rapids Sending build context to Docker daemon  182.3kB
build:dask-rapids #1 CACHED
build:dask-rapids 
build:dask-rapids #2 copy /context /

... more docker output

build:dask-rapids #5 pushing manifest for localhost:5000/rapids:MNxndGt@sha256:efb36151048f8681517292cc07e2338634003b70c267a006d90fbaf2a88f1a22 0.0s done
build:dask-rapids Done processing image 'thgcd.kubernetes.tld/rapids'
```

The local image registry has now stored our custom image on the cluster in a PVC and future references to the image will be access it from the local
registry.

## Building Docker images with DevSpace

DevSpace can automatically build and publish docker images for you, either 
to a local or public container registry. DevSpace ensures that the container
in your deployments is up-to-date by checking for changes to your `Dockerfiles`.

For this example we will use the `Dockerfile` located in `./rapids/docker/Dockerfile`, which has the contents

```dockerfile
# https://catalog.ngc.nvidia.com/orgs/nvidia/teams/rapidsai/containers
FROM nvcr.io/nvidia/rapidsai/notebooks:23.12-cuda11.8-py3.10

### CUSTOMIZE HERE
RUN mamba install -y pytorch torchvision torchaudio
### END CUSTOMIZATION
```

Covering `Dockerfile`s is beyond this tutorial but here, we simply extend a base image by adding some new conda packages (`pytorch`, `torchvision` and `torchaudio`). `mamba` is a more performant installer for conda included with this image.

To add the custom image to our `devspace.yaml` build we must add the `images` section. The specification of `images` is available in the DevSpace [documentation](https://www.devspace.sh/docs/configuration/images/).

To specify a `Dockerfile` for DevSpace use the `images` section in your `devspace.yaml`. Our example looks like this.

```yaml
images:
  dask-rapids: # name
    image: ${USER}.kubernetes.tld/rapids # full cr name (can be remote)
    dockerfile: rapids/docker/Dockerfile # Dockerfile to build
```

The `image` is how we will identify this image in other sections of our 
`devspace.yaml` and the `dockerfile` is the aforementioned image definition 
to build. The `image` also tells DevSpace where to push the image to after
the build completes. If the local registry is running then you do not need
to worry about authentication, but remote registries will require you to 
login following the DevSpace documentation [authentication](https://www.devspace.sh/docs/configuration/images/push#authentication).

## Multi-deployments (e.g. dask)


## Scaling deployments



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



## Cleaning up DevSpace (and the local image registry)

To remove your running deployments from the server, use the command `devspace purge`.
This does not remove the image registry, which must be removed using the command `devspace cleanup local-registry`.
