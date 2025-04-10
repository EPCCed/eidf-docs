# Kueue

## Overview

[Kueue](https://kueue.sigs.k8s.io/docs/overview/) is a native Kubernetes quota and job management system.

This is the job queue system for the EIDF GPU Service, starting with April 2025.

All users should submit jobs to their local namespace user queue, this queue will have the name `eidf project namespace`-user-queue.

### Changes to Job Specs

Jobs can be submitted as before but will require the addition of a metadata label:

```yaml
   labels:
      kueue.x-k8s.io/queue-name:  <project namespace>-user-queue
```

This is the only change required to make Jobs Kueue functional. A policy will be in place that will stop jobs without this label being accepted.

## Useful commands for looking at your local queue

### `kubectl get queue`

This command will output the high level status of your namespace queue with the number of workloads currently running and the number waiting to start:

```bash
NAME               CLUSTERQUEUE             PENDING WORKLOADS   ADMITTED WORKLOADS
eidf001-user-queue eidf001-project-gpu-cq   0                   2
```

### `kubectl describe queue <queue>`

This command will output more detailed information on the current resource usage in your queue:

```bash
Name:         eidf001-user-queue
Namespace:    eidf001
Labels:       <none>
Annotations:  <none>
API Version:  kueue.x-k8s.io/v1beta1
Kind:         LocalQueue
Metadata:
  Creation Timestamp:  2024-02-06T13:06:23Z
  Generation:          1
  Managed Fields:
    API Version:  kueue.x-k8s.io/v1beta1
    Fields Type:  FieldsV1
    fieldsV1:
      f:spec:
        .:
        f:clusterQueue:
    Manager:      kubectl-create
    Operation:    Update
    Time:         2024-02-06T13:06:23Z
    API Version:  kueue.x-k8s.io/v1beta1
    Fields Type:  FieldsV1
    fieldsV1:
      f:status:
        .:
        f:admittedWorkloads:
        f:conditions:
          .:
          k:{"type":"Active"}:
            .:
            f:lastTransitionTime:
            f:message:
            f:reason:
            f:status:
            f:type:
        f:flavorUsage:
          .:
          k:{"name":"default-flavor"}:
            .:
            f:name:
            f:resources:
              .:
              k:{"name":"cpu"}:
                .:
                f:name:
                f:total:
              k:{"name":"memory"}:
                .:
                f:name:
                f:total:
          k:{"name":"gpu-a100"}:
            .:
            f:name:
            f:resources:
              .:
              k:{"name":"nvidia.com/gpu"}:
                .:
                f:name:
                f:total:
          k:{"name":"gpu-a100-1g"}:
            .:
            f:name:
            f:resources:
              .:
              k:{"name":"nvidia.com/gpu"}:
                .:
                f:name:
                f:total:
          k:{"name":"gpu-a100-3g"}:
            .:
            f:name:
            f:resources:
              .:
              k:{"name":"nvidia.com/gpu"}:
                .:
                f:name:
                f:total:
          k:{"name":"gpu-a100-80"}:
            .:
            f:name:
            f:resources:
              .:
              k:{"name":"nvidia.com/gpu"}:
                .:
                f:name:
                f:total:
        f:flavorsReservation:
          .:
          k:{"name":"default-flavor"}:
            .:
            f:name:
            f:resources:
              .:
              k:{"name":"cpu"}:
                .:
                f:name:
                f:total:
              k:{"name":"memory"}:
                .:
                f:name:
                f:total:
          k:{"name":"gpu-a100"}:
            .:
            f:name:
            f:resources:
              .:
              k:{"name":"nvidia.com/gpu"}:
                .:
                f:name:
                f:total:
          k:{"name":"gpu-a100-1g"}:
            .:
            f:name:
            f:resources:
              .:
              k:{"name":"nvidia.com/gpu"}:
                .:
                f:name:
                f:total:
          k:{"name":"gpu-a100-3g"}:
            .:
            f:name:
            f:resources:
              .:
              k:{"name":"nvidia.com/gpu"}:
                .:
                f:name:
                f:total:
          k:{"name":"gpu-a100-80"}:
            .:
            f:name:
            f:resources:
              .:
              k:{"name":"nvidia.com/gpu"}:
                .:
                f:name:
                f:total:
        f:pendingWorkloads:
        f:reservingWorkloads:
    Manager:         kueue
    Operation:       Update
    Subresource:     status
    Time:            2024-02-14T10:54:20Z
  Resource Version:  333898946
  UID:               bca097e2-6c55-4305-86ac-d1bd3c767751
Spec:
  Cluster Queue:  eidf001-project-gpu-cq
Status:
  Admitted Workloads:  2
  Conditions:
    Last Transition Time:  2024-02-06T13:06:23Z
    Message:               Can submit new workloads to clusterQueue
    Reason:                Ready
    Status:                True
    Type:                  Active
  Flavor Usage:
    Name:  gpu-a100
    Resources:
      Name:   nvidia.com/gpu
      Total:  2
    Name:     gpu-a100-3g
    Resources:
      Name:   nvidia.com/gpu
      Total:  0
    Name:     gpu-a100-1g
    Resources:
      Name:   nvidia.com/gpu
      Total:  0
    Name:     gpu-a100-80
    Resources:
      Name:   nvidia.com/gpu
      Total:  0
    Name:     default-flavor
    Resources:
      Name:   cpu
      Total:  16
      Name:   memory
      Total:  256Gi
  Flavors Reservation:
    Name:  gpu-a100
    Resources:
      Name:   nvidia.com/gpu
      Total:  2
    Name:     gpu-a100-3g
    Resources:
      Name:   nvidia.com/gpu
      Total:  0
    Name:     gpu-a100-1g
    Resources:
      Name:   nvidia.com/gpu
      Total:  0
    Name:     gpu-a100-80
    Resources:
      Name:   nvidia.com/gpu
      Total:  0
    Name:     default-flavor
    Resources:
      Name:             cpu
      Total:            16
      Name:             memory
      Total:            256Gi
  Pending Workloads:    0
  Reserving Workloads:  2
Events:                 <none>
```

### `kubectl get workloads`

This command will return the list of workloads in the queue:

```bash
NAME                QUEUE                ADMITTED BY              AGE
job-jobtest-366ab   eidf001-user-queue   eidf001-project-gpu-cq   4h45m
job-jobtest-34ba9   eidf001-user-queue   eidf001-project-gpu-cq   6h48m
```

### `kubectl describe workload <workload>`

This command will return a detailed summary of the workload including status and resource usage:

```bash
Name:         job-pytorch-job-0b664
Namespace:    t4
Labels:       kueue.x-k8s.io/job-uid=33bc1e48-4dca-4252-9387-bf68b99759dc
Annotations:  <none>
API Version:  kueue.x-k8s.io/v1beta1
Kind:         Workload
Metadata:
  Creation Timestamp:  2024-02-14T15:22:16Z
  Generation:          2
  Managed Fields:
    API Version:  kueue.x-k8s.io/v1beta1
    Fields Type:  FieldsV1
    fieldsV1:
      f:status:
        f:admission:
          f:clusterQueue:
          f:podSetAssignments:
            k:{"name":"main"}:
              .:
              f:count:
              f:flavors:
                f:cpu:
                f:memory:
                f:nvidia.com/gpu:
              f:name:
              f:resourceUsage:
                f:cpu:
                f:memory:
                f:nvidia.com/gpu:
        f:conditions:
          k:{"type":"Admitted"}:
            .:
            f:lastTransitionTime:
            f:message:
            f:reason:
            f:status:
            f:type:
          k:{"type":"QuotaReserved"}:
            .:
            f:lastTransitionTime:
            f:message:
            f:reason:
            f:status:
            f:type:
    Manager:      kueue-admission
    Operation:    Apply
    Subresource:  status
    Time:         2024-02-14T15:22:16Z
    API Version:  kueue.x-k8s.io/v1beta1
    Fields Type:  FieldsV1
    fieldsV1:
      f:status:
        f:conditions:
          k:{"type":"Finished"}:
            .:
            f:lastTransitionTime:
            f:message:
            f:reason:
            f:status:
            f:type:
    Manager:      kueue-job-controller-Finished
    Operation:    Apply
    Subresource:  status
    Time:         2024-02-14T15:25:06Z
    API Version:  kueue.x-k8s.io/v1beta1
    Fields Type:  FieldsV1
    fieldsV1:
      f:metadata:
        f:labels:
          .:
          f:kueue.x-k8s.io/job-uid:
        f:ownerReferences:
          .:
          k:{"uid":"33bc1e48-4dca-4252-9387-bf68b99759dc"}:
      f:spec:
        .:
        f:podSets:
          .:
          k:{"name":"main"}:
            .:
            f:count:
            f:name:
            f:template:
              .:
              f:metadata:
                .:
                f:labels:
                  .:
                  f:controller-uid:
                  f:job-name:
                f:name:
              f:spec:
                .:
                f:containers:
                f:dnsPolicy:
                f:nodeSelector:
                f:restartPolicy:
                f:schedulerName:
                f:securityContext:
                f:terminationGracePeriodSeconds:
                f:volumes:
        f:priority:
        f:priorityClassSource:
        f:queueName:
    Manager:    kueue
    Operation:  Update
    Time:       2024-02-14T15:22:16Z
  Owner References:
    API Version:           batch/v1
    Block Owner Deletion:  true
    Controller:            true
    Kind:                  Job
    Name:                  pytorch-job
    UID:                   33bc1e48-4dca-4252-9387-bf68b99759dc
  Resource Version:        270812029
  UID:                     8cfa93ba-1142-4728-bc0c-e8de817e8151
Spec:
  Pod Sets:
    Count:  1
    Name:   main
    Template:
      Metadata:
        Labels:
          Controller - UID:  33bc1e48-4dca-4252-9387-bf68b99759dc
          Job - Name:        pytorch-job
        Name:                pytorch-pod
      Spec:
        Containers:
          Args:
            /mnt/ceph_rbd/example_pytorch_code.py
          Command:
            python3
          Image:              pytorch/pytorch:2.0.1-cuda11.7-cudnn8-devel
          Image Pull Policy:  IfNotPresent
          Name:               pytorch-con
          Resources:
            Limits:
              Cpu:             4
              Memory:          4Gi
              nvidia.com/gpu:  1
            Requests:
              Cpu:                     2
              Memory:                  1Gi
          Termination Message Path:    /dev/termination-log
          Termination Message Policy:  File
          Volume Mounts:
            Mount Path:  /mnt/ceph_rbd
            Name:        volume
        Dns Policy:      ClusterFirst
        Node Selector:
          nvidia.com/gpu.product:  NVIDIA-A100-SXM4-40GB
        Restart Policy:            Never
        Scheduler Name:            default-scheduler
        Security Context:
        Termination Grace Period Seconds:  30
        Volumes:
          Name:  volume
          Persistent Volume Claim:
            Claim Name:   pytorch-pvc
  Priority:               0
  Priority Class Source:
  Queue Name:             t4-user-queue
Status:
  Admission:
    Cluster Queue:  project-cq
    Pod Set Assignments:
      Count:  1
      Flavors:
        Cpu:             default-flavor
        Memory:          default-flavor
        nvidia.com/gpu:  gpu-a100
      Name:              main
      Resource Usage:
        Cpu:             2
        Memory:          1Gi
        nvidia.com/gpu:  1
  Conditions:
    Last Transition Time:  2024-02-14T15:22:16Z
    Message:               Quota reserved in ClusterQueue project-cq
    Reason:                QuotaReserved
    Status:                True
    Type:                  QuotaReserved
    Last Transition Time:  2024-02-14T15:22:16Z
    Message:               The workload is admitted
    Reason:                Admitted
    Status:                True
    Type:                  Admitted
    Last Transition Time:  2024-02-14T15:25:06Z
    Message:               Job finished successfully
    Reason:                JobFinished
    Status:                True
    Type:                  Finished
```
