# Overview

The EIDF GPU Service (EIDFGPUS) uses Nvidia A100 GPUs as accelerators.

Full Nvidia A100 GPUs are either connected to 40GBs of dynamic memory.

Multi-instance usage (MIG) GPUs allow multiple tasks or users to share the same GPU (similar to CPU threading).

There are two types of MIG GPUs inside the EIDFGPUS the Nvidia A100 3G.20GB GPUs and the Nvidia A100 1G.5GB GPUs which equate to ~1/2 and ~1/7 of a full Nvidia A100 40 GB GPU.

The current specification of the EIDFGPUS is:

- 1856 CPU Cores
- 8.7 TiB Memory
- Local Disk Space (Node Image Cache and Local Workspace) - 21 TiB
- Ceph Persistent Volumes (Long Term Data) - up to 100TiB
- 70 Nvidia A100 40 GB GPUs
- 14 MIG Nvidia A100 40 GB GPUs equating to 28 Nvidia A100 3G.20GB GPUs
- 20 MIG Nvidia A100 40 GB GPU equating to 140 A100 1G.5GB GPUs

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

Note these quotas are maximum use by a single project, and that during periods of high usage Kubernetes Jobs maybe queued waiting for resource to become available on the cluster.

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
