# Getting started with Kubernetes

## Requirements

In order to follow this tutorial on the TRE GPU Cluster you will need to have:

- An active TRE Project with access to the TRE GPU Service.

- The TRE GPU Cluster kubernetes namespace associated with the project, e.g. nsh-2024-0000-ns.

- The TRE GPU Cluster queue name associated with the project, e.g. nsh-2024-0000-ns-user-queue.

- The TRE user is configured to use the TRE GPU Cluster from Project VM along with the kubectl command line tool to interact with the K8s API.

## Introduction

Kubernetes (K8s) is a container orchestration system, originally developed by Google, for the deployment, scaling, and management of containerised applications.

Nvidia GPUs are supported through K8s native Nvidia GPU Operators.

The use of K8s to manage the TRE GPU Cluster provides two key advantages:

- support for containers enabling reproducible analysis whilst minimising demand on system admin.
- automated resource allocation management for GPUs and storage volumes that are shared across multiple users.

## Interacting with a K8s cluster

An overview of the key components of a K8s container can be seen on the [Kubernetes docs website](https://kubernetes.io/docs/concepts/overview/components/).

The primary component of a K8s cluster is a pod.

A pod is a set of one or more docker containers (and their storage volumes) that share resources.

It is the TRE GPU Cluster policy that all pods should be wrapped within a K8s [job](https://kubernetes.io/docs/concepts/workloads/controllers/job/).

This allows GPU/CPU/Memory resource requests to be managed by the cluster queue management system, kueue.

Pods which attempt to bypass the queue mechanism will affect the experience of other project users.

Any pods not associated with a job (or other K8s object) are at risk of being deleted without notice.

K8s jobs also provide additional functionality such as parallelism (described later in this tutorial).

Users define the resource requirements of a pod (i.e. number/type of GPU) and the containers/code to be ran in the pod by defining a template within a job manifest file written in yaml.

The job yaml file is sent to the cluster using the K8s API and is assigned to an appropriate node to be ran.

A node is a part of the cluster such as a physical or virtual host which exposes CPU, Memory and GPUs.

Users interact with the K8s API using the `kubectl` (short for kubernetes control) commands.

Some of the kubectl commands are restricted on the TRE cluster in order to ensure project details are not shared across namespaces.

!!! important "Ensure kubectl is interacting with your project namespace."

    You will need to pass the name of your project namespace to `kubectl` in order for it to have permission to interact with the cluster.

    `kubectl` will attempt to interact with the `default` namespace which will return a permissions error if it is not told otherwise.

    `kubectl -n <project-namespace> <command>` will tell kubectl to pass the commands to the correct namespace.

Useful commands are:

- `kubectl -n <project-namespace> create -f <job definition yaml>`: Create a new job with requested resources. Returns an error if a job with the same name already exists.
- `kubectl -n <project-namespace> apply -f <job definition yaml>`: Create a new job with requested resources. If a job with the same name already exists it updates that job with the new resource/container requirements outlined in the yaml.
- `kubectl -n <project-namespace> delete pod <pod name>`: Delete a pod from the cluster.
- `kubectl -n <project-namespace> get pods`: Summarise all pods the namespace has active (or pending).
- `kubectl -n <project-namespace> describe pods`: Verbose description of all pods the namespace has active (or pending).
- `kubectl -n <project-namespace> describe pod <pod name>`: Verbose summary of the specified pod.
- `kubectl -n <project-namespace> logs <pod name>`: Retrieve the log files associated with a running pod.
- `kubectl -n <project-namespace> get jobs`:  List all jobs the namespace has active (or pending).
- `kubectl -n <project-namespace> describe job <job name>`: Verbose summary of the specified job.
- `kubectl -n <project-namespace> delete job <job name>`: Delete a job from the cluster.
