# Overview

The EIDF GPU Service is a GPU cluster shared across EIDF projects that allows for large GPU resource allocations.

However, during periods of high usage Kubernetes jobs may be queued whilst waiting for resources to become available on the cluster.

The EIDF GPU Service is separate to the EIDF VM provisioning service with GPUs mounted directly to project VMs which only offers 2 GPUs per VM.

Users still need an EIDF VM to access the EIDF GPU Service.

The EIDF VM can be a low resource VM (~4 CPUs and ~16 Gb Memory) to act as a login node to the cluster or a higher resource VM if data pre/post-processing is required before/after using the GPU cluster.

> **Note**
> 
> Please refrain from requesting access to the EIDF GPU Service and requesting VMs with GPUs mounted directly.

The EIDF GPU Service (EIDFGPUS) uses Nvidia A100 GPUs as accelerators.

Full Nvidia A100 GPUs are connected to 40GB or 80Gb of dynamic memory.

Multi-instance usage (MIG) GPUs allow multiple tasks or users to share the same GPU (similar to CPU threading).

There are two types of MIG GPUs inside the EIDFGPUS the Nvidia A100 3G.20GB GPUs and the Nvidia A100 1G.5GB GPUs which equate to ~1/2 and ~1/7 of a full Nvidia A100 40 GB GPU.

The current specification of the EIDFGPUS is:

- 1856 CPU Cores
- 8.7 TiB Memory
- Local Disk Space (Node Image Cache and Local Workspace) - 21 TiB
- Ceph Persistent Volumes (Long Term Data) - up to 100TiB
- 8 Nvidia A100 80 Gb GPUs (in 2 nodes of 4 GPUs each)
- 80 Nvidia A100 40 Gb GPUs (in 10 nodes of 8 GPUs each)
- 8 MIG Nvidia A100 40 GB GPUs equating to 16 Nvidia A100 3G.20GB GPUs (all on 1 node)
- 8 MIG Nvidia A100 40 GB GPU equating to 56 A100 1G.5GB GPUs (all on 1 node)

The EIDFGPUS is managed using [Kubernetes](https://kubernetes.io), with up to 8 GPUs being on a single node.

## Service Access

Users should have an EIDF account - [EIDF Accounts](../../access/project.md).

Project Leads will be able to have access to the EIDFGPUS added to their project during the project application process or through a request to the EIDF helpdesk.

Each project will be given a namespace to operate in and a kubeconfig file in a Virtual Machine on the EIDF DSC - information on access to VMs is [available here](../../access/virtualmachines-vdi.md).

## Project Quotas

A standard project namespace has the following initial quota (subject to ongoing review):

- CPU: 100 Cores
- Memory: 1TiB
- GPU: 12

Note these quotas are the maximum used by a single project summed over all submitted jobs.

## Additional Service Policy Information

Additional information on service policies can be found [here](policies.md).

## EIDF GPU Service Tutorial

This tutorial teaches users how to submit tasks to the EIDFGPUS, but it is not a comprehensive overview of Kubernetes.

| Lesson                                                                                                   | Objective                                                                                                      |
|-----------------------------------|-------------------------------------|
| [Getting started with Kubernetes](training/L1_getting_started.md)                             | a. What is Kubernetes?<br>b. How to send a task to a GPU node.<br>c. How to define the GPU resources needed.  |
| [Requesting persistent volumes with Kubernetes](training/L2_requesting_persistent_volumes.md) | a. What is a persistent volume? <br>b. How to request a PV resource.                                          |
| [Running a PyTorch task](training/L3_running_a_pytorch_task.md)                               | a. Accessing a Pytorch container.<br>b. Submitting a PyTorch task to the cluster.<br>c. Inspecting the results. |

## Further Reading and Help

- The [Nvidia developers blog](https://developer.nvidia.com/blog/search-posts/?q=Kubernetes) provides several examples of how to run ML tasks on a Kubernetes GPU cluster.

- Kubernetes documentation has a useful [kubectl cheat sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/#viewing-and-finding-resources)

- More detailed use cases for the `kubectl` can be found in the [Kubernetes documentation](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#run)
