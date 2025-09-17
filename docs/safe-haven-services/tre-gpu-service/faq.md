# GPU Service FAQ

## GPU Service Frequently Asked Questions

### How do I access the GPU Service?

The default access route to the TRE GPU Service is via an TRE Project VM. The TRE Project VM will have access to all TRE resources for your project and can be accessed through the VDI (SSH or if enabled RDP). [Safe Haven Service Access](../safe-haven-access.md) 

### How do I obtain my project kubeconfig file?

Project Leads and Managers can access the kubeconfig file from TRE GPU Cluster. Project Leads and Managers can provide the file on any of the project VMs or give it to individuals within the project.

### Access to GPU Service resources in default namespace is 'Forbidden'

```bash
Error from server (Forbidden): error when creating "myjobfile.yml": jobs is forbidden: User <user> cannot create resource "jobs" in API group "" in the namespace "default"
```

Some version of the above error is common when submitting jobs/pods to the GPU cluster using the kubectl command. This arises when the project namespace is not included in the kubectl command for submitting job/pods and kubectl tries to use the "default" namespace which projects do not have permissions to use. Resubmitting the job/pod with `kubectl -n <project-namespace> create "myjobfile.yml"` should solve the issue.

### Can I mount my PVC in multiple containers or pods at the same time?

The service now provides a **BeeGFS CSI driver** provisioner, which allows for `ReadWriteMany` PVCs. This means a PVC can be mounted to multiple pods at the same time.
**Note:** In Trusted Research Environments (TREs), users cannot create their own PVCs, so this information is only relevant if your project has been provisioned with a BeeGFS-backed PVC by the system administrators.

### How many GPUs can I use in a pod?

The current limit is 8 GPUs per pod. Each underlying host node has 8 GPUs. If you request 8 GPUs, you will be placed in a queue until a node with 8 GPUs is free or other jobs to run. If you request 4 GPUs this could run on a node with 4 or 8 GPUs.

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

### My large number of GPUs Job takes a long time to be scheduled

When requesting a large number of GPUs for a job, this may require an entire node to be free. This could take some time to become available, the default scheduling algorithm in the queues in place is Best Effort FIFO - this means that large jobs will not block small jobs from running if there is sufficient quota and space available.
