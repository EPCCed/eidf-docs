# Kueue

## Overview

[Kueue](https://kueue.sigs.k8s.io/docs/overview/) is a native Kubernetes quota and job management system. This is the job queue system for the TRE GPU Cluster.

**Reminder:** All users should submit jobs to their **local namespace user queue**, which follows the naming convention `<safe_heaven>-<project_id>-ns-user-queue`, e.g. `nsh-2024-0000-ns-user-queue`.

### Changes to Job Specs

Jobs can be submitted as before but will require the addition of a metadata label:

```yaml
   labels:
      kueue.x-k8s.io/queue-name:  <tre-project-namespace>-user-queue
```

This is the only change required to make Jobs Kueue functional. A policy will be in place that will stop jobs without this label being accepted.

## Useful commands for looking at your local queue

### `kubectl get queue -n <tre-project-namespace>`

This command will output the high level status of your namespace queue with the number of workloads currently running and the number waiting to start:

```bash
NAME                          CLUSTERQUEUE              PENDING WORKLOADS   ADMITTED WORKLOADS
nsh-2024-0000-ns-user-queue   nsh-2024-0000-ns-gpu-cq   0                   0
```

### `kubectl describe queue <queue> -n <tre-project-namespace>`

This command will output more detailed information on the current resource usage in your queue:

```bash
Name:         nsh-2024-0000-ns-user-queue
Namespace:    nsh-2024-0000-ns
Labels:       <none>
Annotations:  <none>
API Version:  kueue.x-k8s.io/v1beta1
Kind:         LocalQueue
Metadata:
  Creation Timestamp:  2025-08-26T13:22:20Z
  Generation:          1
  Resource Version:    4752354
  UID:                 801163cf-fb8d-4b16-99fe-e8ece1ed3b97
Spec:
  Cluster Queue:  nsh-2024-0000-ns-gpu-cq
  Stop Policy:    None
Status:
  Admitted Workloads:  1
  Conditions:
    Last Transition Time:  2025-08-26T13:22:20Z
    Message:               Can submit new workloads to clusterQueue
    Observed Generation:   1
    Reason:                Ready
    Status:                True
    Type:                  Active
  Flavor Usage:
    Name:  default-flavor
    Resources:
      Name:   cpu
      Total:  0
      Name:   memory
      Total:  0
      Name:   nvidia.com/gpu
      Total:  0
    Name:     gpu-a100
    Resources:
      Name:   cpu
      Total:  2
      Name:   memory
      Total:  1Gi
      Name:   nvidia.com/gpu
      Total:  1
  Flavors:
    Name:  default-flavor
    Resources:
      cpu
      memory
      nvidia.com/gpu
    Name:  gpu-a100
    Node Labels:
      nvidia.com/gpu.present:  true
      nvidia.com/gpu.product:  NVIDIA-A100-SXM4-40GB
    Resources:
      cpu
      memory
      nvidia.com/gpu
  Flavors Reservation:
    Name:  default-flavor
    Resources:
      Name:   cpu
      Total:  0
      Name:   memory
      Total:  0
      Name:   nvidia.com/gpu
      Total:  0
    Name:     gpu-a100
    Resources:
      Name:             cpu
      Total:            2
      Name:             memory
      Total:            1Gi
      Name:             nvidia.com/gpu
      Total:            1
  Pending Workloads:    0
  Reserving Workloads:  1
Events:                 <none>
```

### `kubectl get workloads -n <tre-project-namespace>`

This command will return the list of workloads in the queue:

```bash
NAME                                QUEUE                         RESERVED IN               ADMITTED   FINISHED   AGE
job-nsh-2024-0000-job-xhw7j-6463d   nsh-2024-0000-ns-user-queue   nsh-2024-0000-ns-gpu-cq   True                  35s

```

### `kubectl describe workload <workload> -n <tre-project-namespace>`

This command will return a detailed summary of the workload including status and resource usage:

```bash
Name:         job-nsh-2024-0000-job-xhw7j-6463d
Namespace:    nsh-2024-0000-ns
Labels:       kueue.x-k8s.io/job-uid=1764a53d-d6fe-4fe5-a49b-32e10c43a1ed
Annotations:  <none>
API Version:  kueue.x-k8s.io/v1beta1
Kind:         Workload
Metadata:
  Creation Timestamp:  2025-09-18T09:25:39Z
  Finalizers:
    kueue.x-k8s.io/resource-in-use
  Generation:  1
  Owner References:
    API Version:           batch/v1
    Block Owner Deletion:  true
    Controller:            true
    Kind:                  Job
    Name:                  nsh-2024-0000-job-xhw7j
    UID:                   1764a53d-d6fe-4fe5-a49b-32e10c43a1ed
  Resource Version:        4752335
  UID:                     9b9790a9-5e6c-4d1c-8936-78420aa13230
Spec:
  Active:  true
  Pod Sets:
    Count:  1
    Name:   main
    Template:
      Metadata:
        Labels:
          Shsuser:  u-vkil3hxdrn
        Name:       nsh-2024-0000-job-
      Spec:
        Active Deadline Seconds:  432000
        Containers:
          Args:
            # Extract job ID from pod name by removing trailing -xxxxx
JOB_ID=$(echo ${HOSTNAME} | sed 's/-[a-z0-9]\{5\}$//')
echo "Resolved JOB_ID: $JOB_ID"
sleep 60
# Make job output directory
mkdir -p /safe_outputs/${JOB_ID}

# Copy test file if it exists
if [ -f /safe_data/test ]; then
  cat /safe_data/test > /safe_outputs/${JOB_ID}/test_output
  echo "Copied /safe_data/test to /safe_outputs/${JOB_ID}/test_output"
else
  echo "File /safe_data/test not found!"
fi

# Run CUDA sample with required arguments
echo "Starting CUDA sample..."
exec /app/nbody -benchmark -numbodies=512000 -fp64 -fullscreen

          Command:
            /bin/sh
            -c
          Image:              tre-ghcr-proxy.nsh.loc:5006/umairayub38/cuda-sample:nbody-cuda11.7.1
          Image Pull Policy:  IfNotPresent
          Name:               cudasample
          Resources:
            Limits:
              Cpu:             2
              Memory:          4Gi
              nvidia.com/gpu:  1
            Requests:
              Cpu:                     2
              Memory:                  1Gi
          Termination Message Path:    /dev/termination-log
          Termination Message Policy:  File
          Volume Mounts:
            Mount Path:  /safe_data
            Name:        shared-data
            Read Only:   true
            Mount Path:  /safe_outputs
            Name:        user-output
            Mount Path:  /scratch
            Name:        scratch
        Dns Policy:      ClusterFirst
        Restart Policy:  Never
        Scheduler Name:  default-scheduler
        Security Context:
          Fs Group:                        1998600502
          Run As Group:                    1998602116
          Run As User:                     1998602116
        Termination Grace Period Seconds:  30
        Volumes:
          Name:  shared-data
          Persistent Volume Claim:
            Claim Name:  pvc-nsh-2024-0000-shared
          Name:          user-output
          Persistent Volume Claim:
            Claim Name:  pvc-nsh-2024-0000-users-uayub
          Empty Dir:
          Name:           scratch
  Priority:               0
  Priority Class Name:    default-workload-priority
  Priority Class Source:  kueue.x-k8s.io/workloadpriorityclass
  Queue Name:             nsh-2024-0000-ns-user-queue
Status:
  Admission:
    Cluster Queue:  nsh-2024-0000-ns-gpu-cq
    Pod Set Assignments:
      Count:  1
      Flavors:
        Cpu:             gpu-a100
        Memory:          gpu-a100
        nvidia.com/gpu:  gpu-a100
      Name:              main
      Resource Usage:
        Cpu:             2
        Memory:          1Gi
        nvidia.com/gpu:  1
  Conditions:
    Last Transition Time:  2025-09-18T09:25:39Z
    Message:               Quota reserved in ClusterQueue nsh-2024-0000-ns-gpu-cq
    Observed Generation:   1
    Reason:                QuotaReserved
    Status:                True
    Type:                  QuotaReserved
    Last Transition Time:  2025-09-18T09:25:39Z
    Message:               The workload is admitted
    Observed Generation:   1
    Reason:                Admitted
    Status:                True
    Type:                  Admitted
Events:
  Type    Reason         Age   From             Message
  ----    ------         ----  ----             -------
  Normal  QuotaReserved  66s   kueue-admission  Quota reserved in ClusterQueue nsh-2024-0000-ns-gpu-cq, wait time since queued was 1s
  Normal  Admitted       66s   kueue-admission  Admitted by ClusterQueue nsh-2024-0000-ns-gpu-cq, wait time since reservation was 0s
```
