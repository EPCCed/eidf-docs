# Running a PyTorch task

In the following lesson, we'll build a NLP neural network and train it using the EIDFGPUS.

The model was taken from the [PyTorch Tutorials](https://pytorch.org/tutorials/beginner/basics/quickstart_tutorial.html).

The lesson will be split into three parts:

-   Requesting a persistent volume and transferring code/data to it
-   Creating a pod with a PyTorch container downloaded from DockerHub
-   Submitting a job to the EIDFGPUS and retrieving the results

## Load training data and ML code into a persistent volume

### Create a persistent volume

Request memory from the Ceph server by submitting a PVC to K8s (example pvc spec yaml below).

``` bash
kubectl create -f <pvc-spec-yaml>
```

### Example PyTorch PersistentVolumeClaim

``` yaml
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
 name: pytorch-pvc
spec:
 accessModes:
  - ReadWriteOnce
 resources:
  requests:
   storage: 2Gi
 storageClassName: csi-rbd-sc
```

### Transfer code/data to persistent volume

1.  Check PVC has been created

    ``` bash
    kubectl get pvc <pv-name>
    ```

2.  Create a lightweight pod with PV mounted (example pod below)

    ``` bash
    kubectl create -f lightweight-pod.yaml
    ```

3.  Download the pytorch code

    ``` bash
    wget https://github.com/EPCCed/eidf-docs/raw/main/docs/services/gpuservice/training/resources/example_pytorch_code.py
    ```

4.  Copy python script into the PV

    ``` bash
    kubectl cp example_pytorch_code.py lightweight-pod:/mnt/ceph_rbd/
    ```

5.  Check files were transferred successfully

    ``` bash
    kubectl exec lightweight-pod -- ls /mnt/ceph_rbd
    ```

6.  Delete lightweight pod

    ``` bash
    kubectl delete pod lightweight-pod
    ```

### Example lightweight pod specification

``` yaml
apiVersion: v1
kind: Pod
metadata:
 name: lightweight-pod
spec:
 containers:
 - name: data-loader
   image: busybox
   command: ["sleep", "infinity"]
   resources:
    requests:
     cpu: 1
     memory: "1Gi"
    limits:
     cpu: 1
     memory: "1Gi"
   volumeMounts:
   - mountPath: /mnt/ceph_rbd
     name: volume
 volumes:
 - name: volume
   persistentVolumeClaim:
    claimName: pytorch-pvc
```

## Creating a pod with a PyTorch container

We will use the pre-made PyTorch Docker image available on Docker Hub to run the PyTorch ML model.

The PyTorch container will be held within a pod that has the persistent volume mounted and access a MIG GPU.

Submit the specification file to K8s to create the pod.

``` bash
kubectl create -f <pytorch-pod-yaml>
```

### Example PyTorch Pod Specification File

``` yaml
apiVersion: v1
kind: Pod
metadata:
 name: pytorch-pod
spec:
 restartPolicy: Never
 containers:
 - name: pytorch-con
   image: pytorch/pytorch:2.0.1-cuda11.7-cudnn8-devel
   command: ["python3"]
   args: ["/mnt/ceph_rbd/example_pytorch_code.py"]
   volumeMounts:
   - mountPath: /mnt/ceph_rbd
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

1.  Check model ran to completion

    ``` bash
    kubectl logs <pytorch-pod-name>
    ```

2.  Spin up lightweight pod to retrieve results

    ``` bash
    kubectl create -f lightweight-pod.yaml
    ```

3.  Copy trained model back to the head node

    ``` bash
    kubectl cp lightweight-pod:mnt/ceph_rbd/model.pth model.pth
    ```

## Using a Kubernetes job to train the pytorch model

A common ML training workflow may consist of training multiple iterations of a model: such as models with different hyperparameters or models trained on multiple different data sets.

A Kubernetes job can create and manage multiple pods with identical or different initial parameters.

NVIDIA provide a detailed tutorial on how to conduct a ML hyperparameter search with a [Kubernetes job](https://developer.nvidia.com/blog/kubernetes-ai-hyperparameter-search-experiments/).

Below is an example job yaml for running the pytorch model which will continue to create pods until three have successfully completed the task of training the model.

``` yaml
apiVersion: batch/v1
kind: Job
metadata:
 name: pytorch-job
spec:
 completions: 3
 parallelism: 1
 template:
  spec:
   restartPolicy: Never
   containers:
   - name: pytorch-con
     image: pytorch/pytorch:2.0.1-cuda11.7-cudnn8-devel
     command: ["python3"]
     args: ["/mnt/ceph_rbd/example_pytorch_code.py"]
     volumeMounts:
     - mountPath: /mnt/ceph_rbd
       name: volume
     resources:
      requests:
       cpu: 1
       memory: "4Gi"
      limits:
       cpu: 1
       memory: "8Gi"
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
kubectl delete pod pytorch-pod

kubectl delete pv pytorch-pvc
```
