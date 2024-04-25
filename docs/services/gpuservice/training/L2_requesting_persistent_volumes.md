# Requesting persistent volumes With Kubernetes

## Requirements

It is recommended that users complete [Getting started with Kubernetes](../L1_getting_started/#requirements) before proceeding with this tutorial.

## Overview

Pods in the K8s EIDF GPU Service are intentionally ephemeral.

They only last as long as required to complete the task that they were created for.

Keeping pods ephemeral ensures the cluster resources are released for other users to request.

However, this means the default storage volumes within a pod are temporary.

If multiple pods require access to the same large data set or they output large files, then computationally costly file transfers need to be included in every pod instance.

K8s allows you to request persistent volumes that can be mounted to multiple pods to share files or collate outputs.

These persistent volumes will remain even if the pods they are mounted to are deleted, are updated or crash.

## Submitting a Persistent Volume Claim

Before a persistent volume can be mounted to a pod, the required storage resources need to be requested and reserved to your namespace.

A PersistentVolumeClaim (PVC) needs to be submitted to K8s to request the storage resources.

The storage resources are held on a Ceph server which can accept requests up to 100 TiB. Currently, each PVC can only be accessed by one pod at a time, this limitation is being addressed in further development of the EIDF GPU Service. This means at this stage, pods can mount the same PVC in sequence, but not concurrently.

Example PVCs can be seen on the [Kubernetes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) documentation page.

All PVCs on the EIDF GPU Service must use the `csi-rbd-sc` storage class.

### Example PersistentVolumeClaim

``` yaml
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
 name: test-ceph-pvc
spec:
 accessModes:
  - ReadWriteOnce
 resources:
  requests:
   storage: 2Gi
 storageClassName: csi-rbd-sc
```

You create a persistent volume by passing the yaml file to kubectl like a pod specification yaml `kubectl -n <project-namespace> create <PVC specification yaml>`
Once you have successfully created a persistent volume you can interact with it using the standard kubectl commands:

- `kubectl -n <project-namespace> delete pvc <PVC name>`
- `kubectl -n <project-namespace> get pvc <PVC name>`
- `kubectl -n <project-namespace> apply -f <PVC specification yaml>`

## Mounting a persistent Volume to a Pod

Introducing a persistent volume to a pod requires the addition of a volumeMount option to the container and a volume option linking to the PVC in the pod specification yaml.

### Example pod specification yaml with mounted persistent volume

``` yaml
apiVersion: batch/v1
kind: Job
metadata:
    name: test-ceph-pvc-job
    labels:
        kueue.x-k8s.io/queue-name:  <project namespace>-user-queue
spec:
    completions: 1
    template:
        metadata:
            name: test-ceph-pvc-pod
        spec:
            containers:
            - name: cudasample
              image: busybox
              args: ["sleep", "infinity"]
              resources:
                    requests:
                        cpu: 2
                        memory: '1Gi'
                    limits:
                        cpu: 2
                        memory: '4Gi'
              volumeMounts:
                    - mountPath: /mnt/ceph_rbd
                      name: volume
            restartPolicy: Never
            volumes:
                - name: volume
                  persistentVolumeClaim:
                    claimName: test-ceph-pvc
```

## Accessing the persistent volume outside a pod

To move files in/out of the persistent volume from outside a pod you can use the kubectl cp command.

```bash
*** On Login Node - replacing pod name with your pod name ***
kubectl -n <project-namespace> cp /home/data/test_data.csv test-ceph-pvc-job-8c9cc:/mnt/ceph_rbd
```

For more complex file transfers and synchronisation, create a low resource pod with the persistent volume mounted.

The bash command rsync can be amended to manage file transfers into the mounted PV following [this GitHub repo](https://github.com/toelke/docker-rsync/#in-kubernetes-cronjob).

## Clean up

```bash
kubectl -n <project-namespace> delete job test-ceph-pvc-job

kubectl -n <project-namespace> delete pvc test-ceph-pvc
```
