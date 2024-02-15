# Getting started with Kubernetes

## Introduction

Kubernetes (K8s) is a container orchestration system, originally developed by Google, for the deployment, scaling, and management of containerised applications.

Nvidia GPUs are supported through K8s native Nvidia GPU Operators.

The use of K8s to manage the EIDF GPU Service provides two key advantages:

- support for containers enabling reproducible analysis whilst minimising demand on system admin.
- automated resource allocation management for GPUs and storage volumes that are shared across multiple users.

## Interacting with a K8s cluster

An overview of the key components of a K8s container can be seen on the [Kubernetes docs website](https://kubernetes.io/docs/concepts/overview/components/).

The primary component of a K8s cluster is a pod.

A pod is a set of one or more containers (and their storage volumes) that share resources.

Users define the resource requirements of a pod (i.e. number/type of GPU) and the containers to be ran in the pod by writing a yaml file.

The pod definition yaml file is sent to the cluster using the K8s API and is assigned to an appropriate node to be ran.

A node is a part of the cluster such as a physical or virtual host which exposes CPU, Memory and GPUs.

Multiple pods can be defined and maintained using several different methods depending on purpose: [deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/), [services](https://kubernetes.io/docs/concepts/services-networking/service/) and [jobs](https://kubernetes.io/docs/concepts/workloads/controllers/job/); see the K8s docs for more details.

Users interact with the K8s API using the `kubectl` (short for kubernetes control) commands.

Some of the kubectl commands are restricted on the EIDF cluster in order to ensure project details are not shared across namespaces.

Useful commands are:

- `kubectl create -f <job definition yaml>`: Create a new job with requested resources. Returns an error if a job with the same name already exists.
- `kubectl apply -f <job definition yaml>`: Create a new job with requested resources. If a job with the same name already exists it updates that job with the new resource/container requirements outlined in the yaml.
- `kubectl delete pod <pod name>`: Delete a pod from the cluster.
- `kubectl get pods`: Summarise all pods the namespace has active (or pending).
- `kubectl describe pods`: Verbose description of all pods the namespace has active (or pending).
- `kubectl describe pod <pod name>`: Verbose summary of the specified pod.
- `kubectl logs <pod name>`: Retrieve the log files associated with a running pod.
- `kubectl get jobs`:  List all jobs the namespace has active (or pending).
- `kubectl describe job <job name>`: Verbose summary of the specified job.
- `kubectl delete job <job name>`: Delete a job from the cluster.

## Creating your first job

To access the GPUs on the service, it is recommended to start with one of the prebuild container images provided by Nvidia, these images are intended to perform different tasks using Nvidia GPUs.

The list of Nvidia images is available on their [website](https://catalog.ngc.nvidia.com/orgs/nvidia/teams/k8s/containers/cuda-sample/tags).

The following example uses their CUDA sample code simulating nbody interactions.

1. Open an editor of your choice and create the file test_NBody.yml
1. Copy the following in to the file, replacing `namespace-user-queue` with <your namespace>-user-queue, e.g. eidf001ns-user-queue:

    ``` yaml
    apiVersion: batch/v1
    kind: Job
    metadata:
        generateName: jobtest-
        labels:
            kueue.x-k8s.io/queue-name:  namespace-user-queue
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

1. Save the file and exit the editor
1. Run `kubectl create -f test_NBody.yml`
1. This will output something like:

    ``` bash
    job.batch/jobtest-b92qg created
    ```

1. Run `kubectl get jobs`
1. This will output something like:

    ```bash
    NAME            COMPLETIONS   DURATION   AGE
    jobtest-b92qg   3/3           48s        6m27s
    jobtest-d45sr   5/5           15m        22h
    jobtest-kwmwk   3/3           48s        29m
    jobtest-kw22k   1/1           48s        29m
    ```

    This displays all the jobs in the current namespace, starting with their name, number of completions against required completions, duration and age.

1. Describe your job using the command `kubectl describe job jobtest-b92-qg`, replacing the job name with your job name.
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

1. Run `kubectl get pods`
1. This will output something like:

    ``` bash
    NAME                  READY   STATUS      RESTARTS   AGE
    jobtest-b92qg-lh64s   0/1     Completed   0          11m
    jobtest-b92qg-lvmrf   0/1     Completed   0          10m
    jobtest-b92qg-xhvdm   0/1     Completed   0          10m
    jobtest-d45sr-8tf4d   0/1     Completed   0          22h
    jobtest-d45sr-jjhgg   0/1     Completed   0          22h
    jobtest-d45sr-n5w6c   0/1     Completed   0          22h
    jobtest-d45sr-v9p4j   0/1     Completed   0          22h
    jobtest-d45sr-xgq5s   0/1     Completed   0          22h
    jobtest-kwmwk-cgwmf   0/1     Completed   0          33m
    jobtest-kwmwk-mttdw   0/1     Completed   0          33m
    jobtest-kwmwk-r2q9h   0/1     Completed   0          33m
    ```

1. View the logs of a pod from the job you ran `kubectl logs jobtest-b92qg-lh64s` - note that the pods for the job in this case start with the job name.
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

1. Delete your job with `kubectl delete job jobtest-b92qg` - this will delete the associated pods as well.

## Specifying GPU requirements

If you create multiple jobs with the same definition file and compare their log files you may notice the CUDA device may differ from `Compute 8.0 CUDA device: [NVIDIA A100-SXM4-40GB]`.

The GPU Operator on K8s is allocating the pod to the first node with a GPU free that matches the other resource specifications irrespective of whether what GPU type is present on the node.

The GPU resource requests can be made more specific by adding the type of GPU product the pod is requesting to the node selector:

- `nvidia.com/gpu.product: 'NVIDIA-A100-SXM4-80GB'`
- `nvidia.com/gpu.product: 'NVIDIA-A100-SXM4-40GB'`
- `nvidia.com/gpu.product: 'NVIDIA-A100-SXM4-40GB-MIG-3g.20gb'`
- `nvidia.com/gpu.product: 'NVIDIA-A100-SXM4-40GB-MIG-1g.5gb'`
- `nvidia.com/gpu.product: 'NVIDIA-H100-80GB-HBM3'`

### Example yaml file

```yaml

apiVersion: batch/v1
kind: Job
metadata:
    generateName: jobtest-
    labels:
        kueue.x-k8s.io/queue-name:  namespace-user-queue
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

The recommended use of the EIDF GPU Service is to use a job request which wraps around a pod specification and provide several useful attributes.

Firstly, if a pod is assigned to a node that dies then the pod itself will fail and the user has to manually restart it.

Wrapping a pod within a job enables the self-healing mechanism within K8s so that if a node dies with the job's pod on it then the job will find a new node to automatically restart the pod, if the restartPolicy is set.

Jobs allow users to define multiple pods that can run in parallel or series and will continue to spawn pods until a specific number of pods successfully terminate.

Jobs allow for better scheduling of resources using the Kueue service implemented on the EIDF GPU Service. Pods which attempt to bypass the queue mechanism this provides will affect the experience of other project users.

See below for an example K8s job that requires three pods to successfully complete the example CUDA code before the job itself ends.

``` yaml
apiVersion: batch/v1
kind: Job
metadata:
 generateName: jobtest-
 labels:
    kueue.x-k8s.io/queue-name:  namespace-user-queue
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
