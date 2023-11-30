# GPU Service FAQ

## GPU Service Frequently Asked Questions

### How do I access the GPU Service?

The default access route to the GPU Service is via an EIDF DSC VM. The DSC VM will have access to all EIDF resources for your project and can be accessed through the VDI (SSH or if enabled RDP) or via the EIDF SSH Gateway.

### How do I obtain my project kubeconfig file?

Project Leads and Managers can access the kubeconfig file from the Project page in the Portal. Project Leads and Managers can provide the file on any of the project VMs or give it to individuals within the project.

### I can't mount my PVC in multiple containers or pods at the same time

The current PVC provisioner is based on Ceph RBD. The block devices provided by Ceph to the Kubernetes PV/PVC providers cannot be mounted in multiple pods at the same time. They can only be accessed by one pod at a time, once a pod has unmounted the PVC and terminated, the PVC can be reused by another pod. The service development team is working on new PVC provider systems to alleviate this limitation.

### How many GPUs can I use in a pod?

The current limit is 8 GPUs per pod. Each underlying host has 8 GPUs.

### Why did a validation error occur when submitting a pod or job with a valid specification file?

If an error like the below occurs:

```bash
error: error validating "myjobfile.yml": error validating data: the server does not allow access to the requested resource; if you choose to ignore these errors, turn validation off with --validate=false
```

There may be an issue with the kubectl version that is being run. This can occur if installing in virtual environments or from packages repositories.

The current version verified to operate with the GPU Service is v1.24.10. kubectl and the Kubernetes API version can suffer from version skew if not with a defined number of releases. More information can be found on this under the [Kubernetes Version Skew Policy](https://kubernetes.io/releases/version-skew-policy/).

### Insufficient Shared Memory Size

My SHM is very small, and it causes "OSError: [Errno 28] No space left on device" when I train a model using multi-GPU. How to increase SHM size?

The default size of SHM is only 64M. You can mount an empty dir to /dev/shm to solve this problem:

```yaml
   spec:
     containers:
       - name: [NAME]
         image: [IMAGE]
         volumeMounts:
         - mountPath: /dev/shm
           name: dshm
     volumes:
       - name: dshm
         emptyDir:
            medium: Memory
```

### Pytorch Slow Performance Issues

Pytorch on Kubernetes may operate slower than expected - much slower than an equivalent VM setup.

Pytorch defaults to auto-detecting the number of OMP Threads and it will report an incorrect number of potential threads compared to your requested CPU core count. This is a consequence in operating in a container environment, the CPU information is reported by standard libraries and tools will be the node level information rather than your container.

To help correct this issue, the environment variable OMP_NUM_THREADS should be set in the job submission file to the number of cores requested or less.

This has been tested using:

- OMP_NUM_THREADS=1
- OMP_NUM_THREADS=(number of requested cores).

Example fragment for a Bash command start:

```yaml
  containers:
    - args:
        - >
          export OMP_NUM_THREADS=1;
          python mypytorchprogram.py;
      command:
        - /bin/bash
        - '-c'
        - '--'
```
