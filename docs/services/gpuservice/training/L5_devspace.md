# Getting started with DevSpace

[DevSpace](http://devspace.sh) is a command-line and configuration tool that allows K8s users to automate many of the tedious tasks related to interacting with and running containers on a K8s cluster.

Things such as:

- Managing a local image registry and building of customised containers.
- Creating and scaling one or more deployments.
- Connecting to and interacting with pods, either via port forwarding to your VM or direct SSH connection.
- Automatically syncing files between your local repository (on your VM) and the DevSpace managed containers (but not big data).
- Capturing services logic (e.g. a Dask/Ray cluster) for reuse.

**Disclaimers**

Although DevSpace automates the configuration and deployment process, you will still need to specify and parameterise yaml manifests or helm charts for specific services and pods that you require.

This guide aims to help you get started with DevSpace but it is not a comprehensive guide or configuration manual.
You can discover more about how to configure DevSpace from the [documentation](https://www.devspace.sh/docs/getting-started/introduction).

DevSpace uses Kubernetes deployments rather than Jobs. This means that when you submit requests to
the cluster via DevSpace, the consumed resources will come out of our project allocation. However,
the resources do not interact with the `kueue` service for K8s batch jobs. If you share resources with
other users in your project you might need to internally discuss how best to balance different demands
between using `kueue` and DevSpace interactive sessions.

## Install DevSpace to your VM

Follow the installation instructions for DevSpace [here](https://www.devspace.sh/docs/getting-started/installation?x0=5).
If you don't have sudo access, you can place `devspace` in your home directory or `~/bin`.

Once you have DevSpace installed you will be able to check for DevSpace commands and options
using `devspace --help`.

## First steps - Jupyter Notebooks on the cluster

To help get you started, we have created a template DevSpace
[repository](https://git.ecdf.ed.ac.uk/epcc_k8s/devspace/eidf-devspace-rapids)
that contains the necessary configuration to launch and access a Jupyter Lab session
running on a GPU node in the Kubernetes (K8s) cluster. DevSpace is configured in this
example to do a few admin tasks for us.

 - It will submit a request to the  K8s cluster for a pod running a single container with a GPU.
 - It will start the Jupyter lab server with the right command options.
 - It will automatically forward the Stdout from the container and connect a port to our
    local VM so we can connect to the server like normal in our browser.
 - Allows us to make patches to pod Kubernetes specifications at run time.
 - Finally, it will sync files from specified locations on our local VM with the
    running pod so we can access and edit them locally or from the pod.

First, clone the template repository to your EIDF VM.

```bash
git clone https://git.ecdf.ed.ac.uk/epcc_k8s/devspace/eidf-devspace-rapids.git
```

> The repository is called `rapids` because it is based upon the RAPIDS image supplied
> by NVIDIA for ML and data science workflows using their hardware. Discover more at
> the [RAPIDS website](https://rapids.ai/). We recommend that users build their
> GPU workflows from the RAPIDS container image bases, as drivers, configuration
> and package integration testing are handled by NVIDIA. Details about
> customising containers can be found [here](https://docs.nvidia.com/ngc/gpu-cloud/ngc-catalog-user-guide/index.html#custcontfrm) and are also covered in the
> advanced DevSpace topic of this guide.

Once you have cloned the repository, enter the directory and run `devspace dev` to
start your Jupyter lab session on the cluster. If everything goes to plan, you
will see output like the following

```bash
$ devspace dev
info Using namespace 'testtony'
info Using kube context 'devgpu'
deploy:rapids Deploying chart /home/eidf076/eidf076/thgcd/.devspace/component-chart/component-chart-0.9.1.tgz (rapids) with helm...
deploy:rapids Deployed helm chart (Release revision: 1)
deploy:rapids Successfully deployed rapids with helm
dev:rapids Waiting for pod to become ready...
dev:rapids Selected pod rapids-devspace-7866d5fcff-dxl8z
dev:rapids ports Port forwarding started on: 8889 -> 8889
dev:rapids sync  Sync started on: ./devspace_start.sh <-> /devspace_start.sh
dev:rapids sync  Waiting for initial sync to complete
dev:rapids sync  Sync started on: ./devspace_start_rapids.sh <-> /devspace_start_rapids.sh
dev:rapids sync  Waiting for initial sync to complete
dev:rapids sync  Sync started on: ./devspace_start_jupyter.sh <-> /devspace_start_jupyter.sh
dev:rapids sync  Waiting for initial sync to complete
dev:rapids sync  Sync started on: ./app <-> /app
dev:rapids sync  Waiting for initial sync to complete
dev:rapids sync  Initial sync completed
dev:rapids sync  Initial sync completed
dev:rapids sync  Initial sync completed
dev:rapids sync  Initial sync completed
dev:rapids ssh   Port forwarding started on: 10616 -> 8022
dev:rapids proxy Port forwarding started on: 10925 <- 10567
dev:rapids ssh   Use 'ssh rapids.eidf-devspace-rapids.devspace' to connect via SSH
dev:rapids term  Opening shell to container-0:rapids-devspace-7866d5fcff-dxl8z (pod:container)
```

which will eventually be cleared and replaced by something like this

```bash
     %########%
     %###########%       ____                 _____
         %#########%    |  _ \   ___ __   __ / ___/  ____    ____   ____ ___
         %#########%    | | | | / _ \\ \ / / \___ \ |  _ \  / _  | / __// _ \
     %#############%    | |_| |(  __/ \ V /  ____) )| |_) )( (_| |( (__(  __/
     %#############%    |____/  \___|  \_/   \____/ |  __/  \__,_| \___\\___|
 %###############%                                  |_|
 %###########%


Welcome to your development container!

This is how you can work with it:
- Files will be synchronized between your local machine and this container
- Some ports will be forwarded, so you can access this container via localhost
- Run `python main.py` to start the application

[I 2024-01-25 12:29:35.744 ServerApp] Package jupyterlab took 0.0000s to import
[I 2024-01-25 12:29:36.297 ServerApp] Package dask_labextension took 0.5523s to import

... lots more Jupyter output

    To access the server, open this file in a browser:
        file:///root/.local/share/jupyter/runtime/jpserver-619-open.html
    Or copy and paste one of these URLs:
        http://localhost:8888/lab?token=1a9f3a61261fa36c23674129d45561f133c9c6530e3d2793
        http://127.0.0.1:8888/lab?token=1a9f3a61261fa36c23674129d45561f133c9c6530e3d2793
[I 2024-01-25 12:27:48.122 LabApp] Build is up to date
```

you should now be able to click on or copy the `http` links into your browser and access your lab session. The root directory of the session is the `app` folder of this template.

## Understanding what DevSpace just did

DevSpace has just done a lot of work for you but we will try to unpack the important
bits for this example.

Firstly, the `devspace.yaml` contains a `deployments` section.
This contains the description of the resources we want to request from the K8s cluster
and any special details, like the image we want our container/pod to run and the
type of GPU we want. Think of deployments as the production version of your container,
this is how the service or application would run without you in a batch style mode.

Our `deployments` section looks like this

```yaml
deployments:
  rapids:
    # This deployment uses `helm` but you can also define `kubectl` deployments or kustomizations
    helm:
      # We are deploying this project with the devspace component chart
      # For configuration of this chart: https://www.devspace.sh/component-chart/docs/introduction
      chart:
        name: component-chart
        repo: https://charts.devspace.sh
      # Under `values` we can define the values for this Helm chart used during `helm install/upgrade`
      # You may also use `valuesFiles` to load values from files, e.g. valuesFiles: ["values.yaml"]
      values:
        containers:
          - image: nvcr.io/nvidia/rapidsai/notebooks:23.12-cuda11.8-py3.10
            resources:
              limits:
                cpu: 1
                memory: 1Gi
              requests:
                cpu: 1
                memory: 1Gi
        nodeSelector:
          nvidia/gpu.product: "NVIDIA-H100-80GB-HBM3"
          # alt values | NVIDIA-A100-SXM4-40GB | NVIDIA-A100-SXM4-40GB-MIG-3g.20gb | NVIDIA-H100-80GB-HBM3
        labels:
          eidf/user: ${USER}
```

Deployments in devspace describe either a Helm chart (a Kubernetes manifest templating framework) with specific values or a static Kubernetes manifest.
For Jupyter, we can use a convenient Helm chart provided DevSpace called a [component-chart](https://www.devspace.sh/component-chart/docs/introduction). We then specify the `image` we want to
use and the node type we want to run on `NVIDIA-H100-80GB-HBM3`. The resource limits
here are less important because we don't plan to run our DevSpace in a batch mode.
Not requesting a GPU makes this container quick to schedule and start. We will
ask for a GPU in the `dev` section. Finally, we add a label unique to us so that
we don't get confused with other DevSpaces in our K8s namespace.

The `dev` section allows us to modify the `deployment` and begin the
useful features of our DevSpace (interactivity, port-forwarding, file syncing, specify pod environment variables, patches etc.). Our `dev` section looks like this

```yaml
dev:
  rapids:
    # Search for the container that runs this image
    labelSelector:
       app.kubernetes.io/component: rapids
       eidf/user: ${USER}
    # Replace the container image with this dev-optimized image (allows to skip image building during development)
    devImage: nvcr.io/nvidia/rapidsai/notebooks:23.12-cuda11.8-py3.10
    env:
      - name: JUPYTER_PORT
        value: 8888
    workingDir: /app
    resources:
      limits:
        cpu: 4
        memory: 20Gi
        nvidia.com/gpu: 1
      requests:
        cpu: 4
        memory: 20Gi
        nvidia.com/gpu: 1
    # Sync files between the local filesystem and the development container
    sync:
      - path: ./app:/app
      - path: rapids/environment.yml:/opt/rapids/environment.yml
      - path: ./devspace_start_rapids.sh:/devspace_start_rapids.sh
      - path: ./devspace_start_jupyter.sh:/devspace_start_jupyter.sh
      - path: ./devspace_start.sh:/devspace_start.sh
    # Forward some ports between Pod and Localhost
    ports:
      - port: 8888:8888
    # Open a terminal and use the following command to start it
    terminal:
      command: /devspace_start_jupyter.sh
    # Inject a lightweight SSH server into the container (so your IDE can connect to the remote dev env)
    ssh:
      enabled: true
    # Make the following commands from my local machine available inside the dev container
    proxyCommands:
      - command: devspace
      - command: kubectl
      - command: helm
      - gitCredentials: true
    patches:
      - op: replace
        path: spec.securityContext
        value:
          runAsUser: 0
          runAsGroup: 0
```

There is quite a bit going on here, so lets start at the top.

First we specify a `dev` which we call `rapids`. Then we must specify some label
selectors so that DevSpace can find the `deployment` we want to replace. This is
where our `${USER}` label comes in handy. The `image` is then specified again
which can be the same or different from the `deployment`. The `workingDir` is where
we would like our default working directory to be on the container. Here we set to `/app` which
is one of synchronised directories (keep reading).

Now for the interesting stuff. The `resources` section here allows us to redefine
our resources which now include a GPU request. On nodes with multiple GPUs you
may request more than one. Generally, it is a good idea to make the requests and
limits the same.

The `sync` section specifies either files or directories we wish to have synchronised.
In this case we synchronise a few different objects but the general form is

```yaml
sync:
  - path: <local>:<remote>
```

you can read more about syncing in the DevSpace docs [here](https://www.devspace.sh/docs/configuration/dev/connections/file-sync). Essentially, DevSpace automatically watches both files (local and remote) and if one updates it will perform a `kubectl cp` operation to
automatically copy the new file to the other location. This allows you to develop
content either on your VM or in the container simultaneously, and ensures that if
the container/pod is lost or shutdown that the work is synchronised to your VM.

> Try creating a new Notebook in your lab session. You should see this notebook created locally
in your `./app` folder even though it is running on the cluster. Similarly, if you create
a text file in `./app` on your local VM, you should see the file appear in the explorer
of the Jupyter lab session.

> DevSpace should not be used to sync large datasets or application output between your VM/Project and one or more containers.
> Large datasets should be moved to a provisioned PV, accessed from network supported file systems mounted to your pods or shared via a network attached DBMS from your project. The `app` folder or any synced resource using DevSpace is primarily suited for small text files during development and testing.

The `ports` sections of your `dev` allows the user to specify ports that should
automatically be forwarded from the development pod/container to the local machine
(where you started `devspace dev`). Because Jupyter Lab is served via a micro-webserver
on port `8888` we can forward that port to our local VM and access it via the
VMs web browser. The web application is rendered locally for us to interact with
but all the commands and cells we run are executing on the remote development
container we started on the cluster with DevSpace. Some applications have dashboards
and these can also be forwarded by specify a `ports` entry for those developments.

One might also forward ports manually using `kubectl port-forward` but this must be
run each time the development container is started. DevSpace just handles it for
us.

> If other people are forwarding ports to the same VM, you may need to modify your local port to an alternative. Change `8888:8888` to `8888:8889` for example. You should change the `http` links
> as well to `localhost:8889` in this case.

When docker images are built, they have a `CMD` directive that tells them what to
run when starting up. Sometimes an image we're using may not run the command we want,
or we might need to modify the command for development purposes. The `terminal` section
allows us specify the command, in this case `/devspace_start_jupyter.sh` which is
a special file we've copied from our template repository using `sync`.

The file sources the standard `/devspace_start.sh`, then sources the profile files specific to the RAPIDS image we are using and finally executes a `jupyter lab` server with the necessary
arguments. In this case we needed to leverage the bash profile and entrypoint from NVIDIA which comes pre-loaded
on the image to ensure the `rapids` conda environment is active and configured correctly when we start Jupyter.

> We could also use a different script at start up of our container. Try changing
> `/devspace_start_jupyter.sh` to `/devspace_start_rapids.sh`. This just loads the
> entry point setup and returns a shell session you can interact with. Use `conda list`
> to explore what packages are installed in the container by default.

One can also enter a shell on a container using the command `devspace enter`, which
will present the user with a list of containers to chose from (if there is more than one).

One last thing of note. At the end of our development section is a `patch`.
Patches allow us to modify aspects of the Kubernetes manifest which describes the pod configuration at runtime. NVIDIA have migrated their RAPIDS
images to a model that uses a `rapids` user. While this is fine and proper for production containers it isn't compatible with DevSpace or easy development. So we apply a patch to alter the `securityContext` of this pod to use `root` user instead. Depending on the
image you use, this may or may not be necessary.

```yaml
patches:
  - op: replace
    path: spec.securityContext
    value:
      runAsUser: 0
      runAsGroup: 0
```

So that is more or less, what DevSpace has done in this example. DevSpace can do
quite a bit more but that will be covered in other examples or you can learn more by
investigating the DevSpace [documentation](https://www.devspace.sh/docs/getting-started/introduction).

## Cleaning up DevSpace

To remove your running deployments from the server, use the command `devspace purge`.

## Known Issues

 - Port conflicts may occur on shared VMs. Adjust your forward port options to avoid this.
 - If the resources you request are not available in a short amount of time. Your
    `devspace dev` command may timeout.
 - DevSpace relies on running the development container as `root` user. If the container image you use does not have a `root` user by default, you can modify the development or deploying using the K8s `securityContext` controls (our patch in this example).

## Making modifications to the template

### Resources

One can specify the required resources in this template as long as they do not
exceed what is available on a single K8s node. Refer to the GPU service documentation
for more details.

### PVC volumes

If you require stateful (containers with disk space) sessions on the K8s cluster
you will need to specify a PVC volume for the container to mount.

**Pre-existing PVC**

Lets assume you have already created a PVC using a manifest like this

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: ceph-ns-store
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 500Gi
  storageClassName: ceph-rbd-sc
```

To make this claim available on the container we can add two patches
to our `deployments`. The first patch specifies the PVC that already
exists.

```yaml
- op: add
  path: spec.volumes
  value: [{"name": "ceph-ns-store", "persistentVolumeClaim": {"claimName": "ceph-ns-store"}}]
```

and the second patch mounts it to `/data` on our pod.

```yaml
- op: add
  path: spec.containers[*].volumeMounts
  value: [{"mountPath": "/data", "name": "ceph-ns-store", "readOnly": false}]
```

Any changes you make to data on the pod in `/data` will not be persisted between development sessions. You can also use `kubectl cp` to copy data out of the PVC back to your VM.

**Personal PVC**

In the case where you do not have a pre-existing PVC DevSpace can handle
the creation and management of the PVC for us.

In the `deployments` section of your `devspace.yaml` modify the `values` section to add the following.

```yaml
volumes:
  - name: my-devspace-volume
    size: "10Gi"
```

Then add the `volumeMounts` to the `containers` that need access.

```yaml
containers:
  - image: ...
    volumeMounts:
      - containerPath: /data
        volume:
          name: my-devspace-volume
          readOnly: false
```

### Additional Python packages

Additional Python packages can be installed in three ways.

 - Using a shell, or your notebook, install packages to the container directly.
   The packages will need to be reinstalled each time you launch the container.
 - Specify the resources you require in the file `./rapids/environment.yml`. This
   is a customisation option supported by the rapids containers.

### Shell instead of Notebook

The DevSpace `dev` section for rapids should use the `devspace_start_rapids.sh` script instead.

###

