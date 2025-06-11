# Open OnDemand and containers

## Introduction

The TRE Open OnDemand service is intended to all you to run containers. This includes both your own project-specific containers that you have been authorised to run within your safe haven as well as standard containers with useful services such as JupyterLab and RStudio Server.

Container are typically run using Podman or Apptainer, depending on which of these is available on a back-end. Some Open OnDemand apps will select which to use, others allow you to choose.

---

## Container requirements

Open OnDemand uses the Container Execution Service tools (TODO link) to run containers. Consequently, containers run via Open OnDemand **must** conform to the requirements of the Container Execution Service (TODO link).

---

## Container registries

As the TRE Open OnDemand service uses the Container Execution Service tools (TODO link), the registries supported by those tools are those supported by the Container Execution Service tools:

| Container Registry | URL prefix | Example  |
| ------------------ | ---------- | ------- |
| DockerHub | `ghcr.io/` | `ghcr.io/mikej888/hello-tre:1.0` |

---

## Sharing files between a back-end and a container

When the container is run, three directories on the back-end are mounted into the container:

| Back-end directory | Container directory | Description |
| ------------------ | ------------------- | ----------- |
| Project-specific `/safe_data/` subdirectory | `$HOME/safe_data/` OR `/safe_data/PROJECT_SUBDIRECTORY/`| If `$HOME/safe_data/` exists in your home directory on the back-end, then that is mounted. Otherwise, a subdirectory of `/safe_data/` corresponding to your project (and inferred from your user group) is mounted, if such a subdirectory can be found. |
| `$HOME/outputs-NUMBER` | `/safe_outputs/` | `NUMBER` is a randomly-generated number, for example `outputs-3320888`. This directory is created in your home directory on the back-end. The directory persists after the job which created the container ends. |
| `$HOME/scratch-NUMBER` | `/scratch/` | `NUMBER` is the same as that created for `outputs-NUMBER`, for example `scratch-3320888`. This directory is also created in your home directory on the back-end. This directory exists for the duration of the job which created the container and is then **deleted** when the job which created the container ends. |

Together, these mounts provides a means for data, configuration files and protoype scripts and code to be shared between the back-end on which the container is running and the environment within the container itself. Creating or editing a file within any of these directories on the back-end means that the changes will be available within the container, and vice-versa.

You can interact with your project's `/safe_data/` subdirectory on the back-end, by logging into the back-end, see [Log into back-ends](./ssh.md).

When using a back-end where your home directory is common to both the Open OnDemand host and the back-end, then you can interact with both `outputs-NUMBER` and `scratch-NUMBER` via the [File Manager](./files.md) and/or by logging into the back-end, see [Log into back-ends](./ssh.md).

When using a back-end where your home directory is **not** common to both the Open OnDemand host and the back-end, then you can interact with both `outputs-NUMBER` and `scratch-NUMBER` by logging into the back-end, see [Log into back-ends](./ssh.md).
