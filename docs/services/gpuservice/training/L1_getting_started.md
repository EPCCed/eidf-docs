# Getting started with Kubernetes

## Introduction

Kubernetes (K8s) is a systems administration tool originally developed by Google to orchestrate the deployment, scaling, and management of containerised applications.

Nvidia have created drivers to officially support clusters of Nvidia GPUs managed by K8s.

Using K8s to manage the EIDFGPUS provides two key advantages:

- native support for containers enabling reproducible analysis whilst minimising demand on system admin.
- automated resource allocation for GPUs and storage volumes that are shared across multiple users.

## Setting up K8s on your virtual machine

To access the GPU system through Kubernetes you will need a virtual machine setup in the EIDF infrastructure.

## Interacting with a K8s cluster

An overview of the key components of a K8s container can be seen on the [Kubernetes docs website](https://kubernetes.io/docs/concepts/overview/components/).

The primary component of a K8s cluster is a pod.

A pod is a set of one or more containers (and their storage volumes) that share resources.

Users define the resource requirements of a pod (i.e. number/type of GPU) and the containers to be ran in the pod by writing a yaml file.

The pod definition yaml file is sent to the cluster using the K8s API and is assigned to an appropriate node to be ran.

A node is a unit of the cluster, e.g. a group of GPUs or virtual GPUs.

Multiple pods can be defined and maintained using several different methods depending on purpose: [deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/), [services](https://kubernetes.io/docs/concepts/services-networking/service/) and [jobs](https://kubernetes.io/docs/concepts/workloads/controllers/job/); see the K8s docs for more details.

Users interact with the K8s API using the `kubectl` (short for kubernetes control) commands.
Some of the kubectl commands are restricted on the EIDF cluster in order to ensure project details are not shared across namespaces.
Useful commands are:

- `kubectl create -f <pod definition yaml>`: Create a new pod with requested resources. Returns an error if a pod with the same name already exists.
- `kubectl apply -f <pod definition yaml>`: Create a new pod with requested resources. If a pod with the same name already exists it updates that pod with the new resource/container requirements outlined in the yaml.
- `kubectl delete pod <pod name>`: Delete a pod from the cluster.
- `kubectl get pods`: Summarise all pods the users has active (or queued).
- `kubectl describe pods`: Verbose description of all pods the users has active (or queued).
- `kubectl logs <pod name>`: Retrieve the log files associated with a running pod.

## Creating your first pod

Nvidia have several prebuilt docker images to perform different tasks on their GPU hardware.

The list of docker images is available on their [website](https://catalog.ngc.nvidia.com/orgs/nvidia/teams/k8s/containers/cuda-sample/tags).

This example uses their CUDA sample code simulating nbody interactions.

1. Open an editor of your choice and create the file test_NBody.yml
1. Copy the following in to the file:

The pod resources are defined with the `requests` and `limits` tags.

Resources defined in the `requests` tags are the minimum possible resources required for the pod to run.

If a pod is assigned to an unused node then it may use resources beyond those requested.

This may allow the task within the pod to run faster, but it also runs the risk of unnecessarily blocking off resources for future pod requests.

The `limits` tag specifies the maximum resources that can be assigned to a pod.

The EIDFGPUS cluster requires all pods to have `requests` and `limits` tags for cpu and memory resources in order to be accepted.

Finally, it optional to define GPU resources but only the `limits` tag is used to specify the use of a GPU, `limits: nvidia.com/gpu: 1`.

``` yaml
apiVersion: v1
kind: Pod
metadata:
  generateName: first-pod-
spec:
 restartPolicy: OnFailure
 containers:
 - name: cudasample
   image: nvcr.io/nvidia/k8s/cuda-sample:nbody-cuda11.7.1
   args: ["-benchmark", "-numbodies=512000", "-fp64", "-fullscreen"]
   resources:
    requests:
     cpu: 2
     memory: "1Gi"
    limits:
     cpu: 4
     memory: "4Gi"
     nvidia.com/gpu: 1
```

1. Save the file (we are assuming you will use the fule `test_NBody.yml`, if you use a different filename you will need to update the command below) and exit the editor
1. Run `kubectl create -f test_NBody.yml -n projectnamens` (the `-n projectnamens` specifies the namespace to use for permissions to create the pod, this should be your EIDF project name plus the letters "ns" at the end, i.e. `eidf069ns`) 
1. This will output something like:

    ``` bash
    pod/first-pod-7gdtb created
    ```

1. Run `kubectl get pods`
1. This will output something like:

    ``` bash
    pi-tt9kq                                                          0/1     Completed   0              24h
    first-pod-24n7n                                                   0/1     Completed   0              24h
    first-pod-2j5tc                                                   0/1     Completed   0              24h
    first-pod-2kjbx                                                   0/1     Completed   0              24h
    sample-2mnvg                                                      0/1     Completed   0              24h
    sample-4sng2                                                      0/1     Completed   0              24h
    sample-5h6sr                                                      0/1     Completed   0              24h
    sample-6bqql                                                      0/1     Completed   0              24h
    first-pod-7gdtb                                                   0/1     Completed   0              39s
    sample-8dnht                                                      0/1     Completed   0              24h
    sample-8pxz4                                                      0/1     Completed   0              24h
    sample-bphjx                                                      0/1     Completed   0              24h
    sample-cp97f                                                      0/1     Completed   0              24h
    sample-gcbbb                                                      0/1     Completed   0              24h
    sample-hdlrr                                                      0/1     Completed   0              24h
    ```

1. View the logs of the pod you ran `kubectl logs first-pod-7gdtb`
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

1. delete your pod with `kubectl delete pod first-pod-7gdtb`

## Specifying GPU requirements

If you create multiple pods with the same yaml file and compare their log files you may notice the CUDA device may differ from `Compute 8.0 CUDA device: [NVIDIA A100-SXM4-40GB]`.

This is because K8s is allocating the pod to any free node irrespective of whether that node contains a full 80GB Nvida A100 or a GPU from a MIG Nvida A100.

The GPU resource request can be more specific by adding the type of product the pod is requesting to the node selector:

- `nvidia.com/gpu.product: 'NVIDIA-A100-SXM4-80GB'` (not all users have access to these GPUs)
- `nvidia.com/gpu.product: 'NVIDIA-A100-SXM4-40GB'`
- `nvidia.com/gpu.product: 'NVIDIA-A100-SXM4-40GB-MIG-3g.20gb'`
- `nvidia.com/gpu.product: 'NVIDIA-A100-SXM4-40GB-MIG-1g.5gb'`

### Example yaml file

``` yaml
apiVersion: v1
kind: Pod
metadata:
 generateName: first-pod-
spec:
 restartPolicy: OnFailure
 containers:
  - name: cudasample
    image: nvcr.io/nvidia/k8s/cuda-sample:nbody-cuda11.7.1
    args: ["-benchmark", "-numbodies=512000", "-fp64", "-fullscreen"]
    resources:
     requests:
      cpu: 2
      memory: "1Gi"
     limits:
      cpu: 4
      memory: "4Gi"
      nvidia.com/gpu: 1
 nodeSelector:
  nvidia.com/gpu.product: NVIDIA-A100-SXM4-40GB-MIG-1g.5gb
```

## Running multiple pods with K8s jobs

A typical use case of the EIDFGPUS cluster will not consist of sending pod requests directly to Kubernetes.

Instead, users will use a job request which wraps around a pod specification and provide several useful attributes.

Firstly, if a pod is assigned to a node that dies then the pod itself will fail and the user has to manually restart it.

Wrapping a pod within a job enables the self-healing mechanism within K8s so that if a node dies with the job's pod on it then the job will find a new node to automatically restart the pod.

Furthermore, jobs allow users to define multiple pods that can run in parallel or series and will continue to spawn pods until a specific number of pods successfully terminate.

See below for an example K8s pod that requires three pods to successfully complete the example CUDA code before the job itself ends.

``` yaml
apiVersion: batch/v1
kind: Job
metadata:
 generateName: jobtest-
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
