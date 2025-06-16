# Run containers

## Introduction

The TRE Open OnDemand service is intended to allow you to run jobs that run containers. This includes both your own project-specific containers that you have been authorised to run within your safe haven as well as standard containers with useful services such as JupyterLab and RStudio Server.

Container are typically run using Podman or Apptainer, depending on which of these is available on a back-end. Some Open OnDemand apps will select which to use, others allow you to choose.

---

## Container requirements

Open OnDemand uses the Container Execution Service tools to run containers. Consequently, containers run via Open OnDemand **must** conform to the requirements of the Container Execution Service (TODO link).

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

When using a back-end where your home directory is common to both the Open OnDemand host and the back-end, then you can interact with both `outputs-NUMBER` and `scratch-NUMBER` (and `$HOME/safe_data/`, if applicable) via the [File Manager](./files.md) and/or by logging into the back-end, see [Log into back-ends](./ssh.md).

When using a back-end where your home directory is **not** common to both the Open OnDemand host and the back-end, then you can interact with `/safe_data/PROJECT_SUBDIRECTORY` (or `$HOME/safe_data/`, if applicable), `outputs-NUMBER` and `scratch-NUMBER` by logging into the back-end, see [Log into back-ends](./ssh.md).

!!! Info

    `/safe_data/PROJECT_SUBDIRECTORY` is **not** available on TRE-level back-ends (e.g., the Superdome Flex). For these, you will need to stage your data to the TRE-level back-end following your project- and safe haven-specific processes for the use of TRE-level services.

### Troubleshooting: 'Cannot open project data: /safe_data/cannot_determine_project_from_groups'

If your project cannot be inferred from your user group or there is no subdirectory of `/safe_data/` for your project group, and you are not using a `$HOME/safe_data/` directory, then the job running the container will fail.

As described in [Job cards](./jobs.md#job-cards), app job cards will only show such jobs as having 'Completed'. Whether a job succeeded or failed can be seen in the job details for the job which can be seen via the [Active Jobs](./apps/active-jobs.md) app.

In such cases, the log file for the job, in a `.log` file in the job's `ondemand/data/sys/dashboard/batch_connect/sys/APP_NAME/output/SESSION_ID/` folder will include a message:

```text
Cannot open project data: /safe_data/cannot_determine_project_from_groups
```

---

## Containers and 'root' users

For some containers run using Podman that you will find that you the 'root' user within the container.

For these containers, you are the 'root' user **only** within the context of the container. You will not have 'root' access to the back-end on which the container is running!

Any files you create in the directories mounted into the container will be owned by your own user, and user group, on the back-end.

For containers run using Apptainer, you will be your own user.

As a concrete example, consider the `hello-tre` example container (described in [Run a 'hello-tre' example container](./apps/container-app.md#run-a-hello-tre-example-container)) which outputs in a log file the permissions of the directories mounted into the a container (as described above).

If `hello-tre` is run via Podman, then you will be the 'root' user within the container and the directory permissions logged will be:

```text
/safe_data: nobody (65534) root(0) drwxrwx--- nfs
/scratch: root (0) root(0) drwxr-xr-x ext2/ext3
/safe_outputs: root (0) root(0) drwxr-xr-x ext2/ext3
```

`/safe_data/` has user `nobody` as typically the user that owns `/safe_data/` on the back-end won't be known within the container. If using `$HOME/safe_data/` then the permissions logged would be:

```text
/safe_data: root (0) root(0) drwxr-xr-x ext2/ext3
```

as this is in your home directory, and, again, you are `root` **in the container**.

The other directories, mounted from directories in your home directory, likewise have user, and group, `root`.

In contrast, if `hello-tre` is run via Apptainer, then the directory permissions logged are:

```text
/safe_data: nobody (65534) your_project_group(4797) drwxrwx--- nfs
/scratch: you (36177) your_project_group(4797) drwxr-xr-x ext2/ext3
/safe_outputs: you (36177) your_project_group(4797) drwxr-xr-x ext2/ext3
```

Again `/safe_data/` has user `nobody` as typically the user that owns `/safe_data/` on the back-end won't be known within the container. However, its group will be your user group. If using `$HOME/safe_data/` then the permissions logged would be:

```text
/safe_data: you (36177) your_project_group(4797) drwxr-xr-x ext2/ext3
```

as this is in your home directory.

Similarly, the other directories, mounted from directories in your home directory likewise have your user, and user group.
