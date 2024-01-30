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
git clone https://devspace_user:fgaTxAUNkBRh8d1rS7Th@git.ecdf.ed.ac.uk/epcc_k8s/devspace/eidf-devspace-rapids.git
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

In some scenarios, you may need to manage multiple deployments to run your application. 
A good example of this is a Notebook server for your interactive
session and a dask cluster for your compute. Of course, you could create a single pod with a large resource request and boot a local dask cluster but
that solution will not scale beyond a single Kubernetes node.
Instead, a dask worker needs to be started on each node you wish to request
resources from.

A DevSpace template for a dask cluster in the EIDF is [available](https://git.ecdf.ed.ac.uk/epcc_k8s/devspace/eidf-devspace-dask)
and it is used in this tutorial to demonstrate a deployment.

First, include the dask template as a dependency in your `devspace.yaml`.

```yaml
dependencies:
  dask:
    git: https://devspace_user:fgaTxAUNkBRh8d1rS7Th@git.ecdf.ed.ac.uk/epcc_k8s/devspace/eidf-devspace-dask.git
```

Now when you run `devspace deploy` or `devspace dev` the dask deployment from the template DevSpace will be included.

The access point for the dask cluster from your container running your application is given by the service name. Services are named endpoints that
automatically connect your pods to discoverable network location. For this
DevSpace we can see the service name `dask-thgcd-scheduler` and the exposed ports. `8786` is the scheduler and `8787` is the dashboard.

```bash
kubectl get services

NAME                   TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)             AGE
dask-thgcd-scheduler   ClusterIP   10.43.255.206   <none>        8786/TCP,8787/TCP   6m53s
```

To connect to the cluster from python one would use

```python
from dask.distributed import Client
client = Client(address='dask-thgcd-scheduler:8786')
```

**Scaling deployments**

You can scale the deployments up or down at anytime using `kubectl scale`.

Check the name of your dask deployment

```bash
kubectl get deployments

NAME                   READY   UP-TO-DATE   AVAILABLE   AGE
dask-thgcd-scheduler   1/1     1            1           13m
dask-thgcd-worker      2/2     2            2           13m
rapids                 0/0     0            0           13m
rapids-devspace        0/1     1            0           13m
```

In this instance, if we want two more workers, we must set the number of replicas to 4.

```bash
kubectl scale --replicas=4 deployment dask-thgcd-worker
```

Check that the number of running worker pods is now four

```bash
kubectl get pods

NAME                                       READY   STATUS             RESTARTS        AGE
pod/dask-thgcd-scheduler-8586d48dd-b5lz4   1/1     Running            0               14m
pod/dask-thgcd-worker-79849ff445-dccv2     1/1     Running            0               14m
pod/dask-thgcd-worker-79849ff445-qb2vz     1/1     Running            0               17s
pod/dask-thgcd-worker-79849ff445-stmzd     1/1     Running            0               14m
pod/dask-thgcd-worker-79849ff445-wzrf6     1/1     Running            0               17s
```

**Sharing Data**

It is generally not a good idea to provision data to a Dask cluster via the
scheduler. Instead, individual workers should load data from a distributed
file system individually. To do this, a shared mount must be available for
each dask worker pod, either as a PVC from the K8s cluster or another networked
resource. Adding mounted volumes will require you to **Modify the deployment**.

**Modify the deployment**

If you need to modify the deployment, you should clone the dask DevSpace template 
repository to your VM and modify the DevSpace `devspace.yaml` before declaring it
as a local dependency for your application `devspace.yaml`.

The template uses a slightly modified Helm chart from Dask which you
can supply additional values to or modify to meet your needs. You
can also modify the `Dockerfile` which defines the scheduler and worker 
container images.

## Cleaning up DevSpace (and the local image registry)

To remove your running deployments from the server, use the command `devspace purge`.
This does not remove the image registry, which must be removed using the command `devspace cleanup local-registry`.
