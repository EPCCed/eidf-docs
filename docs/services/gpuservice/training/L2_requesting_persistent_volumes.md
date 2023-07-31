# Requesting Persistent Volumes With Kubernetes

Pods in the K8s EIDFGPUS are intentionally ephemeral.

They only last as long as required to complete the task that they were created for.

Keeping pods ephemeral ensures the cluster resources are released for other users to request.

However, this means the default storage volumes within a pod are temporary.

If multiple pods require access to the same large data set or they output large files, then computationally costly file transfers need to be included in every pod instance.

Instead, K8s allows you to request persistent volumes that can be mounted to multiple pods to share files or collate outputs.

These persistent volumes will remain even if the pods it is mounted to are deleted, are updated or crash.

## Submitting a Persistent Volume Claim

Before a persistent volume can be mounted to a pod, the required storage resources need to be requested and reserved to your namespace.

A PersistentVolumeClaim (PVC) needs to be submitted to K8s to request the storage resources.

The storage resources are held on a Ceph server which can accept requests up 100 TiB. Currently, each PVC can only be accessed by one pod at a time, this limitation is being addressed in further development of the EIDFGPUS. This means at this stage, pods can mount the same PVC in sequence, but not concurrently.

Example PVCs can be seen on the [Kubernetes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) documentation page.

All PVCs on the EIDFGPUS must use the `csi-rbd-sc` storage class.

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

You create a persistent volume by passing the yaml file to kubectl like a pod specification yaml `kubectl create <PV specification yaml>`
Once you have successfully created a persistent volume you can interact with it using the standard kubectl commands:

- `kubectl delete pvc <PV name>`
- `kubectl get pvc <PV name>`
- `kubectl apply -f <PV specification yaml>`

## Mounting a persistent Volume to a Pod

Introducing a persistent volume to a pod requires the addition of a volumeMount option to the container and a volume option linking to the PVC in the pod specification yaml.

### Example pod specification yaml with mounted persistent volume

``` yaml
apiVersion: v1
kind: Pod
metadata:
 name: test-ceph-pvc-pod
spec:
 containers:
 - name: trial
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
    claimName: test-ceph-pvc
```

## Accessing the persistent volume outside a pod

To move files in/out of the persistent volume from outside a pod you can use the kubectl cp command.

```bash
*** On Login Node ***
kubectl cp /home/data/test_data.csv test-ceph-pvc-pod:/mnt/ceph_rbd
```

For more complex file transfers and synchronisation, create a low resource pod with the persistent volume mounted.

The bash command rsync can be amended to manage file transfers into the mounted PV following [this GitHub repo](https://github.com/toelke/docker-rsync/#in-kubernetes-cronjob).

## Clean up

```bash
kubectl delete pod test-ceph-pvc-pod

kubectl delete pvc test-ceph-pvc
```
