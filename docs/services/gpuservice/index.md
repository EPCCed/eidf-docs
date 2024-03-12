# Overview

The EIDF GPU Service (EIDF GPU Service) provides access to a range of Nvidia GPUs, in both full GPU and MIG variants. The EIDF GPU Service is built upon [Kubernetes](https://kubernetes.io).

MIG (Multi-instance GPU) allow a single GPU to be split into multiple isolated smaller GPUs. This means that multiple users can access a portion of the GPU without being able to access what others are running on their portion.

The EIDF GPU Service hosts 3G.20GB and 1G.5GB MIG variants which are approximately 1/2 and 1/7 of a full Nvidia A100 40 GB GPU respectively.

The service provides access to:

- Nvidia A100 40GB
- Nvidia 80GB
- Nvidia MIG A100 1G.5GB
- Nvidia MIG A100 3G.20GB
- Nvidia H100 80GB

The current full specification of the EIDF GPU Service as of 14 February 2024:

- 4912 CPU Cores (AMD EPYC and Intel Xeon)
- 23 TiB Memory
- Local Disk Space (Node Image Cache and Local Workspace) - 40 TiB
- Ceph Persistent Volumes (Long Term Data) - up to 100TiB
- 112 Nvidia A100 40 GB
- 39 Nvidia A100 80 GB
- 16 Nvidia A100 3G.20GB
- 56 Nvidia A100 1G.5GB
- 32 Nvidia H100 80 GB

!!! important "Quotas"
    This is the full configuration of the cluster.

    Each project will have access to a quota across this shared configuration.

    Changes to the default quota must be discussed and agreed with the EIDF Services team.

## Service Access

Users should have an [EIDF Account](../../access/project.md).

Project Leads will be able to request access to the EIDF GPU Service for their project either during the project application process or through a service request to the EIDF helpdesk.

Each project will be given a namespace to operate in and the ability to add a kubeconfig file to any of their Virtual Machines in their EIDF project - information on access to VMs is available [here](../../access/virtualmachines-vdi.md).

All EIDF virtual machines can be set up to access the EIDF GPU Service. The Virtual Machine does not require to be GPU-enabled.

!!! important "EIDF GPU Service vs EIDF GPU-Enabled VMs"
    The EIDF GPU Service is a container based service which is accessed from EIDF Virtual Desktop VMs. This allows a project to access multiple GPUs of different types.

    An EIDF Virtual Desktop GPU-enabled VM is limited to a small number (1-2) of GPUs of a single type.

    Projects do not have to apply for a GPU-enabled VM to access the GPU Service.

## Project Quotas

A standard project namespace has the following initial quota (subject to ongoing review):

- CPU: 100 Cores
- Memory: 1TiB
- GPU: 12

!!! important "Quota is a maximum on a Shared Resource"
    A project quota is the maximum proportion of the service available for use by that project.

    During periods of high demand, Jobs will be queued awaiting resource availability on the Service.

    This means that a project has access up to 12 GPUs but due to demand may only be able to access a smaller number at any given time.

## Project Queues

EIDF GPU Service is introducing the Kueue system in February 2024. The use of this is detailed in the [Kueue](kueue.md).

## Additional Service Policy Information

Additional information on service policies can be found [here](policies.md).

## EIDF GPU Service Tutorial

This tutorial teaches users how to submit tasks to the EIDF GPU Service, but it is not a comprehensive overview of Kubernetes.

| Lesson                                                                                                   | Objective                                                                                                      |
|-----------------------------------|-------------------------------------|
| [Getting started with Kubernetes](training/L1_getting_started.md)                             | a. What is Kubernetes?<br>b. How to send a task to a GPU node.<br>c. How to define the GPU resources needed.  |
| [Requesting persistent volumes with Kubernetes](training/L2_requesting_persistent_volumes.md) | a. What is a persistent volume? <br>b. How to request a PV resource.                                          |
| [Running a PyTorch task](training/L3_running_a_pytorch_task.md)                               | a. Accessing a Pytorch container.<br>b. Submitting a PyTorch task to the cluster.<br>c. Inspecting the results. |
| [Setting up a Globus endpoint](training/L4_setting_up_a_globus_endpoint.md)                   | a. IDK ask what does here|

## Further Reading and Help

- The [Nvidia developers blog](https://developer.nvidia.com/blog/search-posts/?q=Kubernetes) provides several examples of how to run ML tasks on a Kubernetes GPU cluster.

- Kubernetes documentation has a useful [kubectl cheat sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/#viewing-and-finding-resources).

- More detailed use cases for the `kubectl` can be found in the [Kubernetes documentation](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#run).
