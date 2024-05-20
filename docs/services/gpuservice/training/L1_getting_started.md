# Getting started with Kubernetes

## Requirements

In order to follow this tutorial on the EIDF GPU Cluster you will need to have:

- An account on the EIDF Portal.

- An active EIDF Project on the Portal with access to the EIDF GPU Service.

- The EIDF GPU Service kubernetes namespace associated with the project, e.g. eidf001ns.

- The EIDF GPU Service queue name associated with the project, e.g. eidf001ns-user-queue.

- Downloaded the kubeconfig file to a Project VM along with the kubectl command line tool to interact with the K8s API.

!!! Important "Downloading the kubeconfig file and kubectl"

    Project Leads should use the 'Download kubeconfig' button on the EIDF Portal to complete this step to ensure the correct kubeconfig file and kubectl version is installed.

    Addtionally, Kubectl can be installed manually by running the following commands:-
    
    `curl -LO https://dl.k8s.io/release/v1.25.3/bin/linux/amd64/kubectl<https://dl.k8s.io/release/v1.25.3/bin/linux/amd64/kubectl>`
    `sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl`


## Introduction

Kubernetes (K8s) is a container orchestration system, originally developed by Google, for the deployment, scaling, and management of containerised applications.

Nvidia GPUs are supported through K8s native Nvidia GPU Operators.

The use of K8s to manage the EIDF GPU Service provides two key advantages:

- support for containers enabling reproducible analysis whilst minimising demand on system admin.
- automated resource allocation management for GPUs and storage volumes that are shared across multiple users.

## Interacting with a K8s cluster

An overview of the key components of a K8s container can be seen on the [Kubernetes docs website](https://kubernetes.io/docs/concepts/overview/components/).

The primary component of a K8s cluster is a pod.

A pod is a set of one or more docker containers (and their storage volumes) that share resources.

It is the EIDF GPU Cluster policy that all pods should be wrapped within a K8s [job](https://kubernetes.io/docs/concepts/workloads/controllers/job/).

This allows GPU/CPU/Memory resource requests to be managed by the cluster queue management system, kueue.

Pods which attempt to bypass the queue mechanism will affect the experience of other project users.

Any pods not associated with a job (or other K8s object) are at risk of being deleted without notice.

K8s jobs also provide additional functionality such as parallelism (described later in this tutorial).

Users define the resource requirements of a pod (i.e. number/type of GPU) and the containers/code to be ran in the pod by defining a template within a job manifest file written in yaml.

The job yaml file is sent to the cluster using the K8s API and is assigned to an appropriate node to be ran.

A node is a part of the cluster such as a physical or virtual host which exposes CPU, Memory and GPUs.

Users interact with the K8s API using the `kubectl` (short for kubernetes control) commands.

Some of the kubectl commands are restricted on the EIDF cluster in order to ensure project details are not shared across namespaces.

!!! important "Ensure kubectl is interacting with your project namespace."

    You will need to pass the name of your project namespace to `kubectl` in order for it to have permission to interact with the cluster.

    `kubectl` will attempt to interact with the `default` namespace which will return a permissions error if it is not told otherwise.

    `kubectl -n <project-namespace> <command>` will tell kubectl to pass the commands to the correct namespace.

Useful commands are:

- `kubectl -n <project-namespace> create -f <job definition yaml>`: Create a new job with requested resources. Returns an error if a job with the same name already exists.
- `kubectl -n <project-namespace> apply -f <job definition yaml>`: Create a new job with requested resources. If a job with the same name already exists it updates that job with the new resource/container requirements outlined in the yaml.
- `kubectl -n <project-namespace> delete pod <pod name>`: Delete a pod from the cluster.
- `kubectl -n <project-namespace> get pods`: Summarise all pods the namespace has active (or pending).
- `kubectl -n <project-namespace> describe pods`: Verbose description of all pods the namespace has active (or pending).
- `kubectl -n <project-namespace> describe pod <pod name>`: Verbose summary of the specified pod.
- `kubectl -n <project-namespace> logs <pod name>`: Retrieve the log files associated with a running pod.
- `kubectl -n <project-namespace> get jobs`:  List all jobs the namespace has active (or pending).
- `kubectl -n <project-namespace> describe job <job name>`: Verbose summary of the specified job.
- `kubectl -n <project-namespace> delete job <job name>`: Delete a job from the cluster.

## Creating your first pod template within a job yaml file

To access the GPUs on the service, it is recommended to start with one of the prebuilt container images provided by Nvidia, these images are intended to perform different tasks using Nvidia GPUs.

The list of Nvidia images is available on their [website](https://catalog.ngc.nvidia.com/orgs/nvidia/teams/k8s/containers/cuda-sample/tags).

The following example uses their CUDA sample code simulating nbody interactions.

``` yaml
apiVersion: batch/v1
kind: Job
metadata:
 generateName: jobtest-
 labels:
  kueue.x-k8s.io/queue-name:  <project-namespace>-user-queue
spec:
 completions: 1
 template:
  metadata:
   name: job-test
  spec:
   containers:
   - name: cudasample
     image: nvcr.io/nvidia/k8s/cuda-sample:nbody-cuda11.7.1
     args: ["-benchmark", "-numbodies=512000", "-fp64", "-fullscreen"]
     resources:
      requests:
       cpu: 2
       memory: '1Gi'
      limits:
       cpu: 2
       memory: '4Gi'
       nvidia.com/gpu: 1
   restartPolicy: Never
```

The pod resources are defined under the `resources` tags using the `requests` and `limits` tags.

Resources defined under the `requests` tags are the reserved resources required for the pod to be scheduled.

If a pod is assigned to a node with unused resources then it may burst up to use resources beyond those requested.

This may allow the task within the pod to run faster, but it will also throttle back down when further pods are scheduled to the node.

The `limits` tag specifies the maximum resources that can be assigned to a pod.

The EIDF GPU Service requires all pods have `requests` and `limits` tags for CPU and memory defined in order to be accepted.

GPU resources requests are optional and only an entry under the `limits` tag is needed to specify the use of a GPU, `nvidia.com/gpu: 1`. Without this no GPU will be available to the pod.

The label `kueue.x-k8s.io/queue-name` specifies the queue you are submitting your job to. This is part of the Kueue system in operation on the service to allow for improved resource management for users.

## Submitting your first job

1. Open an editor of your choice and create the file test_NBody.yml
1. Copy the above job yaml in to the file, filling in `<project-namespace>-user-queue`, e.g. eidf001ns-user-queue:
1. Save the file and exit the editor
1. Run `kubectl -n <project-namespace> create -f test_NBody.yml`
1. This will output something like:

    ``` bash
    job.batch/jobtest-b92qg created
    ```

    The five character code appended to the job name, i.e. `b92qg`, is randomly generated and will differ from your run.

1. Run `kubectl -n <project-namespace> get jobs`
1. This will output something like:

    ```bash
    NAME            COMPLETIONS   DURATION   AGE
    jobtest-b92qg   1/1           48s        29m
    ```

    There may be more than one entry as this displays all the jobs in the current namespace, starting with their name, number of completions against required completions, duration and age.

1. Inspect your job further using the command `kubectl -n <project-namespace> describe job jobtest-b92qg`, updating the job name with your five character code.
1. This will output something like:

    ```bash
    Name:             jobtest-b92qg
    Namespace:        t4
    Selector:         controller-uid=d3233fee-794e-466f-9655-1fe32d1f06d3
    Labels:           kueue.x-k8s.io/queue-name=t4-user-queue
    Annotations:      batch.kubernetes.io/job-tracking:
    Parallelism:      1
    Completions:      3
    Completion Mode:  NonIndexed
    Start Time:       Wed, 14 Feb 2024 14:07:44 +0000
    Completed At:     Wed, 14 Feb 2024 14:08:32 +0000
    Duration:         48s
    Pods Statuses:    0 Active (0 Ready) / 3 Succeeded / 0 Failed
    Pod Template:
        Labels:  controller-uid=d3233fee-794e-466f-9655-1fe32d1f06d3
                job-name=jobtest-b92qg
        Containers:
            cudasample:
                Image:      nvcr.io/nvidia/k8s/cuda-sample:nbody-cuda11.7.1
                Port:       <none>
                Host Port:  <none>
                Args:
                    -benchmark
                    -numbodies=512000
                    -fp64
                    -fullscreen
                Limits:
                    cpu:             2
                    memory:          4Gi
                    nvidia.com/gpu:  1
                Requests:
                    cpu:        2
                    memory:     1Gi
                Environment:  <none>
                Mounts:       <none>
        Volumes:        <none>
    Events:
    Type    Reason            Age    From                        Message
    ----    ------            ----   ----                        -------
    Normal  Suspended         8m1s   job-controller              Job suspended
    Normal  CreatedWorkload   8m1s   batch/job-kueue-controller  Created Workload: t4/job-jobtest-b92qg-3b890
    Normal  Started           8m1s   batch/job-kueue-controller  Admitted by clusterQueue project-cq
    Normal  SuccessfulCreate  8m     job-controller              Created pod: jobtest-b92qg-lh64s
    Normal  Resumed           8m     job-controller              Job resumed
    Normal  SuccessfulCreate  7m44s  job-controller              Created pod: jobtest-b92qg-xhvdm
    Normal  SuccessfulCreate  7m28s  job-controller              Created pod: jobtest-b92qg-lvmrf
    Normal  Completed         7m12s  job-controller              Job completed
    ```

1. Run `kubectl -n <project-namespace> get pods`
1. This will output something like:

    ``` bash
    NAME                  READY   STATUS      RESTARTS   AGE
    jobtest-b92qg-lh64s   0/1     Completed   0          11m
    ```

    Again, there may be more than one entry as this displays all the jobs in the current namespace.
    Also, each pod within a job is given another unique 5 character code appended to the job name.

1. View the logs of a pod from the job you ran `kubectl -n <project-namespace> logs jobtest-b92qg-lh64s` - again update with you run's pod and job five letter code.
1. This will output something like:

    ``` bash
    Run "nbody -benchmark [-numbodies=<numBodies>]" to measure performance.
        -fullscreen       (run n-body simulation in fullscreen mode)
        -fp64             (use double precision floating point values for simulation)
        -hostmem          (stores simulation data in host memory)
        -benchmark        (run benchmark to measure performance)
        -numbodies=<N>    (number of bodies (>= 1) to run in simulation)
        -device=<d>       (where d=0,1,2.... for the CUDA device to use)
        -numdevices=<i>   (where i=(number of CUDA devices > 0) to use for simulation)
        -compare          (compares simulation results running once on the default GPU and once on the CPU)
        -cpu              (run n-body simulation on the CPU)
        -tipsy=<file.bin> (load a tipsy model file for simulation)

    NOTE: The CUDA Samples are not meant for performance measurements. Results may vary when GPU Boost is enabled.

    > Fullscreen mode
    > Simulation data stored in video memory
    > Double precision floating point simulation
    > 1 Devices used for simulation
    GPU Device 0: "Ampere" with compute capability 8.0

    > Compute 8.0 CUDA device: [NVIDIA A100-SXM4-40GB]
    number of bodies = 512000
    512000 bodies, total time for 10 iterations: 10570.778 ms
    = 247.989 billion interactions per second
    = 7439.679 double-precision GFLOP/s at 30 flops per interaction
    ```

1. Delete your job with `kubectl -n <project-namespace> delete job jobtest-b92qg` - this will delete the associated pods as well.

## Specifying GPU requirements

If you create multiple jobs with the same definition file and compare their log files you may notice the CUDA device may differ from `Compute 8.0 CUDA device: [NVIDIA A100-SXM4-40GB]`.

The GPU Operator on K8s is allocating the pod to the first node with a GPU free that matches the other resource specifications irrespective of the type of GPU present on the node.

The GPU resource requests can be made more specific by adding the type of GPU product the pod template is requesting to the node selector:

- `nvidia.com/gpu.product: 'NVIDIA-A100-SXM4-80GB'`
- `nvidia.com/gpu.product: 'NVIDIA-A100-SXM4-40GB'`
- `nvidia.com/gpu.product: 'NVIDIA-A100-SXM4-40GB-MIG-3g.20gb'`
- `nvidia.com/gpu.product: 'NVIDIA-A100-SXM4-40GB-MIG-1g.5gb'`
- `nvidia.com/gpu.product: 'NVIDIA-H100-80GB-HBM3'`

### Example yaml file with GPU type specified

The `nodeSelector:` key at the bottom of the pod template states the pod should be ran on a node with a 1g.5gb MIG GPU.

!!! important "Exact GPU product names only"

    K8s will fail to assign the pod if you misspell the GPU type.

    Be especially careful when requesting a full 80Gb or 40Gb A100 GPU as attempting to load GPUs with more data than its memory can handle can have unexpected consequences.

```yaml

apiVersion: batch/v1
kind: Job
metadata:
    generateName: jobtest-
    labels:
        kueue.x-k8s.io/queue-name:  <project-namespace>-user-queue
spec:
    completions: 1
    template:
        metadata:
            name: job-test
        spec:
            containers:
            - name: cudasample
              image: nvcr.io/nvidia/k8s/cuda-sample:nbody-cuda11.7.1
              args: ["-benchmark", "-numbodies=512000", "-fp64", "-fullscreen"]
              resources:
                    requests:
                        cpu: 2
                        memory: '1Gi'
                    limits:
                        cpu: 2
                        memory: '4Gi'
                        nvidia.com/gpu: 1
            restartPolicy: Never
            nodeSelector:
                nvidia.com/gpu.product: NVIDIA-A100-SXM4-40GB-MIG-1g.5gb
```

## Running multiple pods with K8s jobs

Wrapping a pod within a job provides additional functionality on top of accessing the queuing system.

Firstly, the restartPolicy within a job enables the self-healing mechanism within K8s so that if a node dies with the job's pod on it then the job will find a new node to automatically restart the pod.

Jobs also allow users to define multiple pods that can run in parallel or series and will continue to spawn pods until a specific number of pods successfully terminate.

See below for an example K8s job that requires three pods to successfully complete the example CUDA code before the job itself ends.

``` yaml
apiVersion: batch/v1
kind: Job
metadata:
 generateName: jobtest-
 labels:
    kueue.x-k8s.io/queue-name:  <project-namespace>-user-queue
spec:
 completions: 3
 parallelism: 1
 template:
  metadata:
   name: job-test
  spec:
   containers:
   - name: cudasample
     image: nvcr.io/nvidia/k8s/cuda-sample:nbody-cuda11.7.1
     args: ["-benchmark", "-numbodies=512000", "-fp64", "-fullscreen"]
     resources:
      requests:
       cpu: 2
       memory: '1Gi'
      limits:
       cpu: 2
       memory: '4Gi'
       nvidia.com/gpu: 1
   restartPolicy: Never
```

## Change the default kubectl namespace in the project kubeconfig file

  Passing the `-n <project-namespace>` flag every time you want to interact with the cluster can be cumbersome.

  You can alter the kubeconfig on your VM to send commands to your project namespace by default.

  Only users with sudo privileges can change the root kubectl config file.

1. Open the command line on your EIDF VM with access to the EIDF GPU Service.

1. Open the root kubeconfig file with sudo privileges.

    ```bash
    sudo nano /kubernetes/config
    ```

1. Add the namespace line with your project's kubernetes namespace to the "eidf-general-prod" context entry in your copy of the config file.

    ```txt
    *** MORE CONFIG ***

    contexts:
    - name: "eidf-general-prod"
      context:
        user: "eidf-general-prod"
        namespace: "<project-namespace>" # INSERT LINE
        cluster: "eidf-general-prod"

    *** MORE CONFIG ***
    ```

1. Check kubectl connects to the cluster. If this does not work you delete and re-download the kubeconfig file using the button on the project page of the EIDF portal.

    ```bash
    kubectl get pods
    ```
