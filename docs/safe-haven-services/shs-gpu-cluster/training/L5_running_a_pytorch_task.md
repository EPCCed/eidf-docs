# Running a PyTorch task

## Requirements

It is recommended that users complete [Getting started with Kubernetes](./L1_getting_started.md) and [Requesting persistent volumes With Kubernetes](./L4_requesting_persistent_volumes.md) before proceeding with this tutorial.

## Overview

In this tutorial, we will build a Convolutional Neural Network (CNN) and train it using the SHS GPU Cluster.

The model was taken from the [PyTorch Tutorials](https://pytorch.org/tutorials/beginner/basics/quickstart_tutorial.html).

The tutorial will be split into three parts:

- Requesting a persistent volume and transferring code/data to it
- Creating a pod with a PyTorch container downloaded from DockerHub
- Submitting a job to the SHS GPU Cluster and retrieving the results

## Load training data and ML code into a persistent volume

### Create a persistent volume

Request memory from the Ceph server by submitting a PVC to K8s (example pvc spec yaml below).

``` bash
kubectl -n <project-namespace> create -f <pvc-spec-yaml>
```

### Example PyTorch PersistentVolumeClaim

``` yaml
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
 name: pytorch-pvc
spec:
 accessModes:
  - ReadWriteMany
 resources:
  requests:
   storage: 2Gi
 storageClassName: csi-cephfs-sc
```

### Transfer code/data to persistent volume

1. Check PVC has been created

    ``` bash
    kubectl -n <project-namespace> get pvc <pv-name>
    ```

1. Create a lightweight job with pod with PV mounted (example job below)

    ``` bash
    kubectl -n <project-namespace> create -f lightweight-pod-job.yaml
    ```

1. Download the PyTorch code

    ``` bash
    wget https://github.com/EPCCed/eidf-docs/raw/main/docs/services/gpuservice/training/resources/example_pytorch_code.py
    ```

1. Copy the Python script into the PV

    ``` bash
    kubectl -n <project-namespace> cp example_pytorch_code.py lightweight-job-<identifier>:/mnt/ceph_rbd/
    ```

1. Check whether the files were transferred successfully

    ``` bash
    kubectl -n <project-namespace> exec lightweight-job-<identifier> -- ls /mnt/ceph
    ```

1. Delete the lightweight job

    ``` bash
    kubectl -n <project-namespace> delete job lightweight-job-<identifier>
    ```

### Example lightweight job specification

``` yaml
apiVersion: batch/v1
kind: Job
metadata:
  generateName: lightweight-job-
  labels:
    kueue.x-k8s.io/queue-name: <project namespace>-user-queue
spec:
  completions: 1
  backoffLimit: 1
  ttlSecondsAfterFinished: 1800
  template:
    metadata:
      name: lightweight-pod
    spec:
      containers:
      - name: data-loader
        image: busybox
        args: ["sleep", "infinity"]
        resources:
          requests:
            cpu: 1
            memory: '1Gi'
          limits:
            cpu: 1
            memory: '1Gi'
        volumeMounts:
          - mountPath: /mnt/ceph
            name: volume
      restartPolicy: Never
      volumes:
        - name: volume
          persistentVolumeClaim:
            claimName: pytorch-pvc
```

## Creating a Job with a PyTorch container

We will use the pre-made PyTorch Docker image available on Docker Hub to run the PyTorch ML model.

The PyTorch container will be held within a pod that has the persistent volume mounted and access a MIG GPU.

Submit the specification file below to K8s to create the job, replacing the queue name with your project namespace queue name.

``` bash
kubectl -n <project-namespace> create -f <pytorch-job-yaml>
```

### Example PyTorch Job Specification File

``` yaml
apiVersion: batch/v1
kind: Job
metadata:
  generateName: pytorch-job-
  labels:
    kueue.x-k8s.io/queue-name: <project namespace>-user-queue
spec:
  completions: 1
  backoffLimit: 1
  ttlSecondsAfterFinished: 1800
  template:
    metadata:
      name: pytorch-pod
    spec:
      restartPolicy: Never
      containers:
      - name: pytorch-con
        image: pytorch/pytorch:2.0.1-cuda11.7-cudnn8-devel
        command: ["python3"]
        args: ["/mnt/ceph/example_pytorch_code.py"]
        volumeMounts:
          - mountPath: /mnt/ceph
            name: volume
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
      volumes:
        - name: volume
          persistentVolumeClaim:
            claimName: pytorch-pvc
```

## Reviewing the results of the PyTorch model

This is not intended to be an introduction to PyTorch, please see the [online tutorial](https://pytorch.org/tutorials/intermediate/torchvision_tutorial.html) for details about the model.

1. Check that the model ran to completion

    ``` bash
    kubectl -n <project-namespace> logs <pytorch-pod-name>
    ```

1. Spin up a lightweight pod to retrieve results

    ``` bash
    kubectl -n <project-namespace> create -f lightweight-pod-job.yaml
    ```

1. Copy the trained model back to your access VM

    ``` bash
    kubectl -n <project-namespace> cp lightweight-job-<identifier>:mnt/ceph_rbd/model.pth model.pth
    ```

## Using a Kubernetes job to train the pytorch model multiple times

A common ML training workflow may consist of training multiple iterations of a model, such as models with different hyperparameters or models trained on multiple different data sets.

A Kubernetes job can create and manage multiple pods with identical or different initial parameters.

Nvidia provide a detailed tutorial on how to conduct a ML hyperparameter search with a [Kubernetes job](https://developer.nvidia.com/blog/kubernetes-ai-hyperparameter-search-experiments/).

Below is an example job yaml for running the pytorch model which will continue to create pods until three have successfully completed the task of training the model.

``` yaml
apiVersion: batch/v1
kind: Job
metadata:
  generateName: pytorch-job-
  labels:
    kueue.x-k8s.io/queue-name: <project namespace>-user-queue
spec:
  ttlSecondsAfterFinished: 3600
  completions: 3
  backoffLimit: 4
  template:
    metadata:
      name: pytorch-pod
    spec:
      restartPolicy: Never
      containers:
      - name: pytorch-con
        image: pytorch/pytorch:2.0.1-cuda11.7-cudnn8-devel
        command: ["python3"]
        args: ["/mnt/ceph/example_pytorch_code.py"]
        volumeMounts:
          - mountPath: /mnt/ceph
            name: volume
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
      volumes:
          - name: volume
            persistentVolumeClaim:
              claimName: pytorch-pvc
```

## Clean up

``` bash
kubectl -n <project-namespace> delete pod pytorch-job

kubectl -n <project-namespace> delete pvc pytorch-pvc
```
