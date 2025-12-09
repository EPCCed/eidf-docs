# Overview

The EIDF GPU Service (EIDF GPU Service) provides access to a range of Nvidia GPUs, in both full GPU and MIG variants. The EIDF GPU Service is built upon [Kubernetes](https://kubernetes.io).

MIG (Multi-instance GPU) allow a single GPU to be split into multiple isolated smaller GPUs. This means that multiple users can access a portion of the GPU without being able to access what others are running on their portion. The EIDF GPU Service hosts 3G.20GB and 1G.5GB MIG variants which are approximately 1/2 and 1/7 of a full Nvidia A100 40 GB GPU respectively.

The current full specification of the EIDF GPU Service as of April 2025:

- 9254 CPU Cores (AMD EPYC and Intel Xeon)
- 59 TiB Memory
- Ceph Persistent Volumes CephFS - up to 100TiB
- Ceph Persistent Volumes RBD - up to 100TiB
- 16 Nvidia H200 141GB
- 136 Nvidia H100 80GB
- 80 Nvidia A100 80GB
- 56 Nvidia A100 40GB
- 16 Nvidia MIG A100 3G.20GB
- 56 Nvidia MIG A100 1G.5GB

!!! important "Quotas"

    This is the full configuration of the cluster.

    Each project will have access to a quota across this shared configuration.

    Changes to the default quota must be discussed and agreed with the EIDF Services team.

> **NOTE**
>
> If you request a GPU on the EIDF GPU Service you will be assigned one at random unless you specify a GPU type.
> Please see [Getting started with Kubernetes](training/L1_getting_started.md) to learn about specifying GPU resources.

## Service Access

Users should have an [EIDF Account](../../access/project.md) as the EIDF GPU Service is only accessible through EIDF Virtual Machines.

Existing projects can request access to the EIDF GPU Service through a service request to the [EIDF helpdesk](https://portal.eidf.ac.uk/queries/submit) or emailing [eidf@epcc.ed.ac.uk](mailto:eidf@epcc.ed.ac.uk) .

New projects wanting to using the GPU Service should include this in their EIDF Project Application.

Each project will be given a namespace within the EIDF GPU service to operate in.

This namespace will normally be the EIDF Project code appended with ’ns’, i.e. `eidf989ns` for a project with code 'eidf989'.

Once access to the EIDF GPU service has been confirmed, Project Leads will be give the ability to add a kubeconfig file to any of the VMs in their EIDF project - information on access to VMs is available [here](../../access/virtualmachines-vdi.md).

All EIDF VMs with the project kubeconfig file downloaded can access the EIDF GPU Service using the kubectl command line tool.

The VM does not require to be GPU-enabled.

A quick check to see if a VM has access to the EIDF GPU service can be completed by typing `kubectl -n <project-namespace> get jobs` in to the command line.

If this is first time you have connected to the GPU service the response should be `No resources found in <project-namespace> namespace`.

!!! important "EIDF GPU Service vs EIDF GPU-Enabled VMs"

    The EIDF GPU Service is a container based service which is accessed from EIDF Virtual Desktop VMs.

    This allows a project to access multiple GPUs of different types.

    An EIDF Virtual Desktop GPU-enabled VM is limited to a small number (1-2) of GPUs of a single type.

    Projects do not have to apply for a GPU-enabled VM to access the GPU Service.

## Project Quotas

A standard project namespace has the following initial quota (subject to ongoing review):

- CPU: 100 Cores
- Memory: 1TiB
- GPU: 12

!!! important "Quota is a maximum on a Shared Resource"

    A project quota is the maximum proportion of the service available for use by that project.

    Any submitted job requests that would exceed the total project quota will be queued.

## Project Queues

EIDF GPU Service has been using the Kueue system since February 2024. The use of this is detailed in the [Kueue](kueue.md).

!!! important "Job Queuing"

    During periods of high demand, jobs will be queued awaiting resource availability on the Service.

    As a general rule, the higher the GPU/CPU/Memory resource request of a single job the longer it will wait in the queue before enough resources are free on a single node for it be allocated.

    GPUs in high demand, such as Nvidia H100s, typically have longer wait times.

    Furthermore, a project may have a quota of up to 12 GPUs but due to demand may only be able to access a smaller number at any given time.

## Additional Service Policy Information

Additional information on service policies can be found [here](policies.md).

## EIDF GPU Service Tutorial

This tutorial teaches users how to submit tasks to the EIDF GPU Service, but it is not a comprehensive overview of Kubernetes.

| Lesson                                                                                                   | Objective                                                                                                      |
|-----------------------------------|-------------------------------------|
| [Getting started with Kubernetes](training/L1_getting_started.md)                             | a. What is Kubernetes?<br>b. How to send a task to a GPU node.<br>c. How to define the GPU resources needed.  |
| [Requesting persistent volumes with Kubernetes](training/L2_requesting_persistent_volumes.md) | a. What is a persistent volume? <br>b. How to request a PV resource.                                          |
| [Running a PyTorch task](training/L3_running_a_pytorch_task.md)                               | a. Accessing a Pytorch container.<br>b. Submitting a PyTorch task to the cluster.<br>c. Inspecting the results. |
| [Template workflow](training/L4_template_workflow.md)                               | a. Loading large data sets asynchronously.<br>b. Manually or automatically building Docker images.<br>c. Iteratively changing and testing code in a job. |

## Further Reading and Help

- The [Nvidia developers blog](https://developer.nvidia.com/blog/search-posts/?q=Kubernetes) provides several examples of how to run ML tasks on a Kubernetes GPU cluster.

- Kubernetes documentation has a useful [kubectl cheat sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/#viewing-and-finding-resources).

- More detailed use cases for the `kubectl` can be found in the [Kubernetes documentation](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#run).
