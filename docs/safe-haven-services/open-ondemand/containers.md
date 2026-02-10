# Run containers

## Introduction

Some Open OnDemand apps allow you to run containers, which package up software, services and their dependencies. Some of the apps provided by Open OnDemand run containers pre-built by EPCC (e.g., JupyterLab and RStudio Server). Other apps allow you to run your own project-specific containers that you have been authorised to run within your safe haven.

Container are typically run using Podman or Apptainer, depending on which of these is available on a back-end. Some Open OnDemand apps will select which to use, others allow you to choose.

[Run jobs](jobs.md) described concepts you need to know about how Open OnDemand runs tasks and apps. The page focuses on concepts related to running containers.

---

## Container requirements

Open OnDemand uses the Safe Haven Services Container Execution Service tools to run containers. Consequently, containers run via Open OnDemand **must** conform to the requirements of the Safe Haven Services Container Execution Service. See the [Container User Guide](../tre-container-user-guide/introduction.md) for details of these requirements.

---

## Container registries

The container registries supported by the Safe Haven Services Container Execution Service, and so supported by Open OnDemand and its apps, are as follows:

| Container Registry | URL prefix | Example  |
| ------------------ | ---------- | ------- |
| GitHub    | `ghcr.io` | `ghcr.io/epcc/epcc-ces-hello:1.0` |
| University of Edinburgh ECDF GitLab | `git.ecdf.ed.ac.uk` | `git.ecdf.ed.ac.uk/tre-container-execution-service/containers/epcc-ces-hello:1.0` |

!!! Note

    For ECDF GitLab, do not put the port number, 5050, into the URL. The Safe Haven Services Container Execution Service tools will automatically insert this into ECDF GitLab URLs.

---

## Sharing files between a back-end and a container

When a container is run via the Safe Haven Services Container Execution Service, three directories on the back-end are always mounted into the container:

| Back-end directory | Container directory | Description |
| ------------------ | ------------------- | ----------- |
| `/safe_data/PROJECT_SUBDIRECTORY` | `/safe_data` | `PROJECT_SUBDIRECTORY` is your project group, inferred from your user groups. If such a  project-specific subdirectory of `/safe_data` is found, then it is mounted into the container (but see below). Any files written into `/safe_data` in the container will be visible to you and and other project members within `/safe_data/PROJECT_SUBDIRECTORY` on the back-end. |
| `$HOME/safe_data` | `/safe_data` | If `$HOME/safe_data` is found, then it is mounted into the container. `$HOME/safe_data` takes precedence over any `/safe_data/PROJECT_SUBDIRECTORY` directory when looking for the directory to mount into the container at `/safe_data`. Any files written into `/safe_data` in the container will be visible to you only within `$HOME/safe_data` on the back-end. |
| `$HOME/safe_outputs/APP_SHORT_NAME/SESSION_ID` | `/safe_outputs` | `APP_SHORT_NAME` is a short-name for an app (e.g., `jupyter` for [Run JupyterLab Container](apps/jupyter-app.md)). `SESSION_ID` is a unique session identifier created when an app is run. This directory is created in your home directory on the back-end when your container runs. The directory persists after the job which created the container ends. |
| `$HOME/scratch/APP_SHORT_NAME/SESSION_ID` | `/scratch` | `APP_SHORT_NAME` and `SESSION_ID` are as above. This directory is also created in your home directory on the back-end when your container runs. This directory exists for the duration of the job which created the container. The `SESSION_ID` sub-directory is **deleted** when the job which created the container ends. It is recommended that this directory be used for temporary files only. |

Together, these mounts (and other app-specific mounts) provide various means by which data, configuration files, scripts and code can be shared between the back-end on which the container is running and the environment within the container itself. Creating or editing a file within any of these directories on the back-end means that the changes will be available within the container, and vice-versa.

!!! Note

    Some apps may mount additional app-specific directories into a container and/or allow you to do so yourself.

You can interact with your project's `/safe_data` subdirectory on the back-end, by logging into the back-end, see [Log into back-ends](ssh.md).

When using a back-end where your home directory is common to both the Open OnDemand VM and the back-end, then you can interact with both `safe_outputs/APP_SHORT_NAME/SESSION_ID` and `scratch/APP_SHORT_NAME/SESSION_ID` (and `$HOME/safe_data`, if applicable) via the [File Manager](files.md) and/or by logging into the back-end, see [Log into back-ends](ssh.md).

When using a back-end where your home directory is **not** common to both the Open OnDemand VM and the back-end, then you can interact with `/safe_data/PROJECT_SUBDIRECTORY` (or `$HOME/safe_data`, if applicable), `safe_outputs/APP_SHORT_NAME/SESSION_ID` and `scratch/APP_SHORT_NAME/SESSION_ID` by logging into the back-end, see [Log into back-ends](ssh.md).

!!! Note

    Your project data files, in a project-specific directory under `/safe_data` are **not** available on the Open OnDemand VM.

!!! Note

    Your project data files, in a project-specific directory under `/safe_data` are **not** available on back-ends outwith your safe haven (e.g., the Superdome Flex). For these, you will need to stage your data to the back-end following your project- and safe haven-specific processes for the use of such services outwith your safe haven.

### Troubleshooting: 'Cannot open project data: /safe_data/cannot_determine_project_from_groups'

If your project cannot be inferred from your user group or there is no subdirectory of `/safe_data` for your project group, and you are not using a `$HOME/safe_data` directory, then the job running the container will fail.

As described in [Job cards](jobs.md#job-cards), app job cards will only show such jobs as having 'Completed'. Whether a job succeeded or failed can be seen in the job details for the job which can be seen via the [Active Jobs](apps/active-jobs.md) app.

In such cases, the log file for the app's job, in the job context directory, `ondemand/data/sys/dashboard/batch_connect/sys/APP_NAME/output/SESSION_ID`, will include a message:

```text
Cannot open project data: /safe_data/cannot_determine_project_from_groups
```

If this problem occurs, then please contact your Research Coordinator (or equivalent).

---

## Containers and 'root' users

For some containers run using Podman that you will find that you the 'root' user within the container but **only** within the container. You do **not** have 'root' access to the back-end on which the container is running!

Any files you create in the directories mounted into the container will be owned by your own user, and user group, on the back-end.

For containers run using Apptainer, you will be your own user within the container.

As a concrete example, consider the `epcc-ces-hello` example container (described in [Getting started](getting-started.md)) which outputs in a log file the permissions of the directories mounted into the a container (as described above).

If `epcc-ces-hello` is run via Podman, then you will be the 'root' user within the container and the directory permissions logged will be:

```text
/safe_data: nobody (65534) root(0) drwxrwx--- nfs
/scratch: root (0) root(0) drwxr-xr-x ext2/ext3
/safe_outputs: root (0) root(0) drwxr-xr-x ext2/ext3
```

`/safe_data` has user `nobody` as typically the user that owns `/safe_data` on the back-end won't be known within the container. If using `$HOME/safe_data` then the permissions logged would be:

```text
/safe_data: root (0) root(0) drwxr-xr-x ext2/ext3
```

as this is in your home directory, and, again, you are `root` but **only** within the container.

The other directories, mounted from directories in your home directory, likewise have user, and group, `root`.

In contrast, if `epcc-ces-hello` is run via Apptainer, then the directory permissions logged are:

```text
/safe_data: nobody (65534) your_project_group(4797) drwxrwx--- nfs
/scratch: you (36177) your_project_group(4797) drwxr-xr-x ext2/ext3
/safe_outputs: you (36177) your_project_group(4797) drwxr-xr-x ext2/ext3
```

Again `/safe_data` has user `nobody` as typically the user that owns `/safe_data` on the back-end won't be known within the container. However, its group will be your user group. If using `$HOME/safe_data` then the permissions logged would be:

```text
/safe_data: you (36177) your_project_group(4797) drwxr-xr-x ext2/ext3
```

as this is in your home directory.

Similarly, the other directories, mounted from directories in your home directory likewise have your user, and user group.
