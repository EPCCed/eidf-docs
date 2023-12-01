# Getting started with Graphcore IPU Jobs

This guide assumes basic familiarity with Kubernetes (K8s) and usage of `kubectl`. See [GPU service tutorial](../../gpuservice/training/L1_getting_started.md) to get started.

## Introduction

Graphcore provides prebuilt docker containers (full lists [here](https://hub.docker.com/u/graphcore)) which contain the required libraries (pytorch, tensorflow, poplar etc.) and can be used directly within the K8s to run on the Graphcore IPUs.

In this tutorial we will cover running training with a single IPU. The subsequent tutorial will cover using multiple IPUs, which can be used for distrubed training jobs.

## Creating your first IPU job

For our first IPU job, we will be using the Graphcore PyTorch (PopTorch) container image (`graphcore/pytorch:3.3.0`) to run a simple example of training a neural network for classification on the MNIST dataset, which is provided [here](https://github.com/graphcore/examples/tree/master/tutorials/simple_applications/pytorch/mnist). More applications can be found in the repository <https://github.com/graphcore/examples>.

To get started:

1. to specify the job - create the file `mnist-training-ipujob.yaml`, then copy and save the following content into the file:

``` yaml
apiVersion: graphcore.ai/v1alpha1
kind: IPUJob
metadata:
  generateName: mnist-training-
spec:
  # jobInstances defines the number of job instances.
  # More than 1 job instance is usually useful for inference jobs only.
  jobInstances: 1
  # ipusPerJobInstance refers to the number of IPUs required per job instance.
  # A separate IPU partition of this size will be created by the IPU Operator
  # for each job instance.
  ipusPerJobInstance: "1"
  workers:
    template:
      spec:
        containers:
        - name: mnist-training
          image: graphcore/pytorch:3.3.0
          command: [/bin/bash, -c, --]
          args:
            - |
              cd;
              mkdir build;
              cd build;
              git clone https://github.com/graphcore/examples.git;
              cd examples/tutorials/simple_applications/pytorch/mnist;
              python -m pip install -r requirements.txt;
              python mnist_poptorch_code_only.py --epochs 1
          resources:
            limits:
              cpu: 32
              memory: 200Gi
          securityContext:
            capabilities:
              add:
              - IPC_LOCK
          volumeMounts:
          - mountPath: /dev/shm
            name: devshm
        restartPolicy: Never
        hostIPC: true
        volumes:
        - emptyDir:
            medium: Memory
            sizeLimit: 10Gi
          name: devshm
```

1. to submit the job - run `kubectl create -f mnist-training-ipujob.yaml`, which will give the following output:

    ``` bash
    ipujob.graphcore.ai/mnist-training-<random string> created
    ```

1. to monitor progress of the job - run `kubectl get pods`, which will give the following output

    ``` bash
    NAME                      READY   STATUS      RESTARTS   AGE
    mnist-training-<random string>-worker-0   0/1     Completed   0          2m56s
    ```

1. to read the result - run `kubectl logs mnist-training-<random string>-worker-0`, which will give the following output (or similar)

   ``` bash
   ...
   Graph compilation: 100%|██████████| 100/100 [00:23<00:00]
   Epochs: 100%|██████████| 1/1 [00:34<00:00, 34.18s/it]
   ...
   Accuracy on test set: 97.08%
   ```

## Monitoring and Cancelling your IPU job

An IPU job creates an IPU Operator, which manages the required worker or launcher pods. To see running or complete `IPUjobs`, run `kubectl get ipujobs`, which will show:

``` bash
NAME             STATUS      CURRENT   DESIRED   LASTMESSAGE          AGE
mnist-training   Completed   0         1         All instances done   10m
```

To delete the `IPUjob`, run `kubectl delete ipujobs <job-name>`, e.g. `kubectl delete ipujobs mnist-training-<random string>`. This will also delete the associated worker pod `mnist-training-<random string>-worker-0`.

Note: simply deleting the pod via `kubectl delete pods mnist-training-<random-string>-worker-0` does not delete the IPU job, which will need to be deleted separately.

Note: you can list all pods via `kubectl get all` or `kubectl get pods`, but they do not show the ipujobs. These can be obtained using `kubectl get ipujobs`.

Note: `kubectl describe <pod-name>` provides verbose description of a specific pod.

## Description

The Graphcore IPU Operator (Kubernetes interface) extends the Kubernetes API by introducing a custom resource definition (CRD) named `IPUJob`, which can be seen at the beginning of the included yaml file:

``` yaml
apiVersion: graphcore.ai/v1alpha1
kind: IPUJob
```

An `IPUJob` allows users to defineworkloads that can use IPUs. There are several fields specific to an `IPUJob`:

**job instances** : This defines the number of jobs. In the case of training it should be 1.

**ipusPerJobInstance** : This defines the size of IPU partition that will be created for each job instance.

**workers** : This defines a Pod specification that will be used for `Worker` Pods, including the container image and commands.

These fields have been populated in the example .yaml file. For distributed training (with multiple IPUs), additional fields need to be included, which will be described in the [next lesson](./L2_multiple_IPU.md).

## Additional Information

It is possible to further specify the restart policy (`Always`/`OnFailure`/`Never`/`ExitCode`) and clean up policy (`Workers`/`All`/`None`); see [here](https://docs.graphcore.ai/projects/kubernetes-user-guide/en/latest/creating-ipujob.html).
