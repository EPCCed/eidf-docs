# Requesting persistent volumes With Kubernetes

## Requirements

It is recommended that users complete [Getting started with Kubernetes](../L1_getting_started/#requirements) before proceeding with this tutorial.

## Overview

!!! important "BeeGFS - ReadWriteMany Volume Recommendation*"

    As of May 2025, the GPU cluster has migrated to **BeeGFS** The new default, **BeeGFS**, supports `ReadWriteMany`, enabling multiple pods to mount and use the same volume concurrently.

Pods in the K8s TRE GPU Cluster are intentionally ephemeral.

They only last as long as required to complete the task that they were created for.

Keeping pods ephemeral ensures the cluster resources are released for other users to request.

However, this means the default storage volumes within a pod are temporary.

If multiple pods require access to the same large data set or they output large files, then computationally costly file transfers need to be included in every pod instance.

For security reasons, **users cannot create their own Persistent Volume Claims (PVCs)**. Instead, PVCs are pre-created and assigned to projects by the TRE platform team. These assigned PVCs allow data to be shared across multiple pods or retained even if the pods they are mounted to are deleted, updated, or crash.

## Predefined BeeGFS Persistent Volume Claims (PVCs)

The following **predefined PVCs** are available in every project namespace:

| BeeGFS Path                                                  | PVC Name                              | Mount in Container | Use Case                                       |
|--------------------------------------------------------------|----------------------------------------|--------------------|------------------------------------------------|
| `/mnt/beegfs/<safe_heaven>/<project_id>/shared`                            | `pvc-<safe_heaven>-<project_id>-shared`              | `/safe_data`       | Shared project data (read-only or read-write)  |
| `/mnt/beegfs/<safe_heaven>/<project_id>/users/<username>` | `pvc-<safe_heaven>-<project_id>-users-<first part of username>`    | `/safe_outputs`    | User output files (read-write)                |
| `~/scratch`                                         | *(not a PVC; uses emptyDir)*           | `/scratch`         | Temporary scratch space (deleted after job)   |

These PVCs are automatically provisioned and do not require user creation.

## Mounting BeeGFS Volumes to a Pod

To use BeeGFS-based shared and output directories in a container, add `volumeMounts` and `volumes` entries to your pod/job YAML.
You also need to ensure the container runs with the correct user and group IDs matching your TRE user identity. This is critical for BeeGFS storage permissions and volume mounts to work properly.

### Security Context Explained

**runAsUser:** The numeric user ID (UID) inside the container. This should match your TRE user UID.

**runAsGroup:** The **project Group ID (GID)** inside the container. This must match the group ID associated with your project, not your own GID. Using your GID here will cause `permission denied` errors when accessing BeeGFS.

**fsGroup:** The filesystem group ID to give permissions for mounted volumes, enabling proper group access inside the container.

!!! important "Why is this important?"
    BeeGFS uses POSIX file permissions for access control. Setting these IDs ensures the container’s processes can access mounted BeeGFS directories with the correct permissions. Without this, the volumes may fail to mount or be inaccessible.

### How to Find Your UID and GID on the TRE Desktop VM

Open a terminal on the TRE Desktop VM and type:

``` bash
id
```

You will see output like this:

``` bash
uid=0001(<tre_username>) gid=0001(<tre_username>) groups=0001(<tre_username>),0002(<project_id>),…
```

In this example:

- **runAsUser** → `0001` (your UID).
- **runAsGroup** → the GID associated with your `<project_id>` (e.g. `0002`).
- **fsGroup** → should also be set to the same `<project_id>` GID.

### Understanding Persistent Volume Claims (PVCs)

**Shared Data PVC:**
`claimName: "pvc-<safe_heaven>-<project_id>-shared"`
Mounted read-only at /safe_data. Shared by all project members.

**User Output PVC:**
`claimName: "pvc-<safe_heaven>-<project_id>-users-<first part of tre_username before _ >"`
Mounted read-write at /safe_outputs. Dedicated to the individual user identified by their FreeIPA username `<tre_username>`.

!!! note "Example mapping for clarity"
    For this example:

    - `<safe_heaven>` = `nsh`
    - `<project_id>` = `2024-0000`
    - `<tre_username>` = `test_nsh-2024-0000`

    The first part of the username before `_` is `test`, so the resulting PVC names are:

    - Shared data PVC: `pvc-nsh-2024-0000-shared`
    - User output PVC: `pvc-nsh-2024-0000-users-test`

Your FreeIPA username `<tre_username>` corresponds to the user you log in as on the TRE portal and Desktop VM.

### Example pod specification yaml with mounted persistent volume

``` yaml
apiVersion: batch/v1
kind: Job
metadata:
  generateName: <safe_heaven>-<project_id>-job-
  labels:
    kueue.x-k8s.io/queue-name: <project namespace>-user-queue
spec:
  completions: 1
  backoffLimit: 1
  ttlSecondsAfterFinished: 1800
  template:
    metadata:
      name: <safe_heaven>-<project_id>-job-
    spec:
      securityContext:
        runAsUser: <tre_user_id>
        runAsGroup: <tre_usergroup_id>
        fsGroup: <tre_usergroup_id>
      containers:
        - name: cudasample
          image: tre-ghcr-proxy.nsh.loc:5003/<github_user>/cuda-sample:nbody-cuda11.7.1
          command: ["/bin/sh", "-c"]
          args:
            - |
              # Extract job ID from pod name by removing trailing -xxxxx
              JOB_ID=$(echo ${HOSTNAME} | sed 's/-[a-z0-9]\{5\}$//')
              echo "Resolved JOB_ID: $JOB_ID"
              # Make job output directory
              mkdir -p /safe_outputs/${JOB_ID}
              # Run CUDA sample with required arguments
              echo "Starting CUDA sample..."
          resources:
            requests:
              cpu: 2
              memory: "1Gi"
            limits:
              cpu: 2
              memory: "4Gi"
              nvidia.com/gpu: 1
          volumeMounts:
            - mountPath: /safe_data
              name: shared-data
              readOnly: true
            - mountPath: /safe_outputs
              name: user-output
            - mountPath: /scratch
              name: scratch
      restartPolicy: Never
      volumes:
        - name: shared-data
          persistentVolumeClaim:
            claimName: pvc-<safe_heaven>-<project_id>-shared
        - name: user-output
          persistentVolumeClaim:
            claimName: pvc-<safe_heaven>-<project_id>-users-<first part of tre_username before '_' >
        - name: scratch
          emptyDir: {}

```

✅ **You do not need to create** the PVCs `pvc-<safe_heaven>-<project_id>-shared` and `pvc-<safe_heaven>-<project_id>-users-<username>`. These are already available for you in your namespace.
