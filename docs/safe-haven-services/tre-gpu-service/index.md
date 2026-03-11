# Overview

The EPCC SHS GPU Cluster provides access to full Nvidia A100 40GB GPUs. The SHS GPU Cluster is built upon [Kubernetes](https://kubernetes.io) and only accepts containerised workloads.

## Current Configuration

The full specification of the SHS GPU Cluster as of October 2025 is as follows:

- 672 CPU Cores (AMD EPYC)
- 2.54 TiB Memory
- BeeGFS Storage upto 1.3 PiB
- 24 Nvidia A100 40GB (Full GPU, no MIG)

!!! important "Quotas"

    This is the full configuration of the Cluster.

    Each project will have access to a quota across this shared configuration.

    Changes to the default quota must be discussed and agreed between the Safe Haven Information Governance function and the EPCC Service Manager for the Safe Haven in question and may incur an additional cost.

## SHS GPU Cluster Access

!!! Important "Early Adopters"

    The EPCC SHS GPU Cluster is currently open to early adopters. Please contact the Research Coordinator team of your Safe Haven to discuss.

Users should have a [SHS Account](../safe-haven-access.md) as the SHS GPU Cluster is only accessible through Safe Haven Virtual Machines.

Research co-ordinators can request that specific user-accounts have access to the SHS GPU Cluster through a service request to the their dedicated helpdesk.

When submitting a request, the Research Co-ordinator must provide:

- **Project/Study name**
- **VM name** from which access to the cluster will be granted
- **Username**
- **Number of GPUs required** (by default, *4 GPUs are assigned*)

Each project will be given a namespace within the SHS GPU Cluster to operate in.

This project namespace will normally be formatted as the SHS Safe Heaven and Project code appended with "ns", e.g. `nsh-2024-0000-ns` for the `nsh` Safe Haven project with code `2024-0000`.

Once access to the SHS GPU Cluster has been confirmed, SHS project VMs will be configured to use the SHS GPU cluster. How to access VMs is described in [Safe Haven Services Access](../safe-haven-access.md).

Project users can access the GPU Cluster using their FreeIPA credentials. When executing a kubectl command, if no valid token is cached locally, you will be prompted to enter your FreeIPA username and password. Upon successful authentication, a token is generated and cached locally, remaining valid for 90 days or until it is deleted. Once the token expires, kubectl will prompt you again for your FreeIPA credentials in the same format.

!!! important "Authentication Prompt"

    ```text
    You will first be asked to select the authentication provider — choose **freeIpaProvider**
    Auth providers:
    0 - localProvider
    1 - freeIpaProvider
    Select auth provider:
    ```

All user accounts with the project kubeconfig file downloaded can access the SHS GPU Cluster using the kubectl command line tool.

A quick check to see if a user has access to the SHS GPU Cluster can be completed by typing `kubectl -n <project-namespace> get jobs` into the command line.

If this is the first time you have connected to the GPU Cluster the response should be `No resources found in <project-namespace> namespace`.

!!! important "SHS GPU Cluster vs SHS GPU-Enabled VMs"

    The SHS GPU Cluster is a container-based service which is accessed from SHS VMs.

    This allows a project to access multiple GPUs on the GPU Cluster, unlike a GPU-enabled VM, which is limited to a small number (1–2) of GPUs of a single type.

    VMs enabled for the SHS GPU Cluster need not have attached GPUs.

## Project Quotas

A standard project namespace has the following initial quota (subject to ongoing review):

- CPU: 100 Cores
- Memory: 500 GiB
- GPU: 4

!!! important "Quota is a maximum on a Shared Resource"

    A project quota is the maximum proportion of the GPU Cluster available for use by that project.

    Any submitted job requests that would exceed the total project quota will be queued.

## Project Queues

The SHS GPU Cluster has been using the Kueue system since May 2025. The use of this is detailed in our [Kueue](kueue.md) documentation.

!!! important "Job Queuing"

    During periods of high demand, jobs will be queued awaiting resource availability on the GPU Cluster.

    As a general rule, the higher the GPU/CPU/Memory resource request of a single job, the longer the job will queue before enough resources are free on a single node for it to be allocated.

    Furthermore, a project may have a quota of up to 12 GPUs but due to demand may only be able to access a smaller number at any given time.

## Additional Service Policy Information

Additional information on service policies can be found in our [policies documentation](policies.md).

## SHS GPU Cluster Tutorial

This tutorial teaches users how to submit tasks to the SHS GPU Cluster. It assumes knowledge of Kubernetes (see below for further reading).

| Lesson                                                                                                   | Objective                                                                                                      |
|-----------------------------------|-------------------------------------|
| [Getting started with Kubernetes](training/L1_getting_started.md)                             | a. What is Kubernetes?<br>b. How to send a task to a GPU node.<br>c. How to define the GPU resources needed.  |
| [Requesting persistent volumes with Kubernetes](training/L4_requesting_persistent_volumes.md) | a. What is a persistent volume? <br>b. How to request a PV resource.                                          |
| [Running a PyTorch task](training/L5_running_a_pytorch_task.md)                               | a. Accessing a Pytorch container.<br>b. Submitting a PyTorch task to the GPU Cluster.<br>c. Inspecting the results. |
| [Template workflow](training/L6_template_workflow.md)                               | a. Loading large data sets asynchronously.<br>b. Manually or automatically building Docker images.<br>c. Iteratively changing and testing code in a job. |

## Further Reading and Help

- The [Nvidia developers blog](https://developer.nvidia.com/blog/search-posts/?q=Kubernetes) provides several examples of how to run ML tasks on a Kubernetes GPU cluster.

- Kubernetes documentation has a useful [kubectl cheat sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/#viewing-and-finding-resources).

- More detailed use cases for the `kubectl` can be found in the [Kubernetes documentation](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#run).
