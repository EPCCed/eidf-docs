# Overview

The TRE GPU Service (Trusted Research Environment GPU Service) provides access to full Nvidia A100 40GB GPUs. There are no MIG (Multi-instance GPU) configurations available. The TRE GPU Service is built upon [Kubernetes](https://kubernetes.io).

## Current Configuration

The full specification of the TRE GPU Service as of May 2025:

- 672 CPU Cores (AMD EPYC and Intel Xeon)
- 2.54 TiB Memory
- BeeGFS Persistent Volumes using BeeGFS CSI – up to 100TiB
- 24 Nvidia A100 40GB (Full GPU, no MIG)

!!! important "Quotas"

    This is the full configuration of the cluster.

    Each project will have access to a quota across this shared configuration.

    Changes to the default quota must be discussed and agreed with the TRE Services team.

> **NOTE**
>
> If you request a GPU on the TRE GPU Service you will be assigned one at random unless you specify a GPU type.
> Please see [Getting started with Kubernetes](training/L1_getting_started.md) to learn about specifying GPU resources.

## Service Access

Users should have an [TRE Account](../safe-haven-access.md) as the TRE GPU Service is only accessible through TRE Virtual Machines.

Existing projects can request access to the TRE GPU Service through a service request to the [TRE helpdesk](https://portal.eidf.ac.uk/queries/submit) or emailing [eidf@epcc.ed.ac.uk](mailto:eidf@epcc.ed.ac.uk).

New projects wanting to use the GPU Service should include this in their TRE Project Application.

Each project will be given a namespace within the TRE GPU service to operate in.

This project namespace will normally be the TRE Safe Heaven and Project code appended with ’ns’, i.e. `nsh-2024-0000-ns` for a safe-heaven `nsh` and project with code `2024-0000`.

Once access to the TRE GPU service has been confirmed, TRE Project VMs will be configured to use the TRE GPU cluster. - information on access to VMs is available [here](../virtual-desktop-connections.md).

Since FreeIPA is integrated with the GPU cluster, project users can authenticate using their FreeIPA credentials. When you run a kubectl command for the first time (e.g., `kubectl get pods`), you will be prompted to enter your FreeIPA username and password. After successful authentication, your token is cached locally and remains valid until it expires or is deleted. Upon expiration, kubectl will again prompt you for login credentials.

!!! important "First Time Login"
    ```text
    You will first be asked to select the authentication provider — choose **freeIpaProvider**
    Auth providers:
    0 - localProvider
    1 - freeIpaProvider
    Select auth provider:
    ```

All TRE VMs with the project kubeconfig file downloaded can access the TRE GPU Service using the kubectl command line tool.

The VM does not require to be GPU-enabled.

A quick check to see if a VM has access to the TRE GPU service can be completed by typing `kubectl -n <project-namespace> get jobs` into the command line.

If this is the first time you have connected to the GPU service the response should be `No resources found in <project-namespace> namespace`.

!!! important "TRE GPU Service vs TRE GPU-Enabled VMs"

    The TRE GPU Service is a container-based service which is accessed from TRE Virtual Desktop VMs.

    This allows a project to access multiple GPUs of different types.

    An TRE Virtual Desktop GPU-enabled VM is limited to a small number (1–2) of GPUs of a single type.

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

TRE GPU Service has been using the Kueue system since May 2025. The use of this is detailed in the [Kueue](kueue.md).

!!! important "Job Queuing"

    During periods of high demand, jobs will be queued awaiting resource availability on the Service.

    As a general rule, the higher the GPU/CPU/Memory resource request of a single job the longer it will wait in the queue before enough resources are free on a single node for it to be allocated.

    Furthermore, a project may have a quota of up to 12 GPUs but due to demand may only be able to access a smaller number at any given time.

## Additional Service Policy Information

Additional information on service policies can be found [here](policies.md).

## TRE GPU Service Tutorial

This tutorial teaches users how to submit tasks to the TRE GPU Service, but it is not a comprehensive overview of Kubernetes.

| Lesson                                                                                                   | Objective                                                                                                      |
|-----------------------------------|-------------------------------------|
| [Getting started with Kubernetes](training/L1_getting_started.md)                             | a. What is Kubernetes?<br>b. How to send a task to a GPU node.<br>c. How to define the GPU resources needed.  |
| [Requesting persistent volumes with Kubernetes](training/L4_requesting_persistent_volumes.md) | a. What is a persistent volume? <br>b. How to request a PV resource.                                          |
| [Running a PyTorch task](training/L5_running_a_pytorch_task.md)                               | a. Accessing a Pytorch container.<br>b. Submitting a PyTorch task to the cluster.<br>c. Inspecting the results. |
| [Template workflow](training/L6_template_workflow.md)                               | a. Loading large data sets asynchronously.<br>b. Manually or automatically building Docker images.<br>c. Iteratively changing and testing code in a job. |

## Further Reading and Help

- The [Nvidia developers blog](https://developer.nvidia.com/blog/search-posts/?q=Kubernetes) provides several examples of how to run ML tasks on a Kubernetes GPU cluster.

- Kubernetes documentation has a useful [kubectl cheat sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/#viewing-and-finding-resources).

- More detailed use cases for the `kubectl` can be found in the [Kubernetes documentation](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#run).
