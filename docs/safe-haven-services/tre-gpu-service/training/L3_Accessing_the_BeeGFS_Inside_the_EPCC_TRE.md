# Accessing the Storage (BeeGFS) inside the TRE GPU Cluster

## What is the BeeGFS?

[BeeGFS (the BeeGFS Parallel File System)](https://www.beegfs.io/) is a high-performance, distributed file system designed for environments requiring fast and scalable I/O operations—ideal for GPU-accelerated workloads in HPC settings. Within the Trusted Research Environment (TRE) at EPCC, BeeGFS is mounted using the [BeeGFS CSI Driver](https://github.com/NetApp/beegfs-csi-driver), which enables dynamic provisioning and access to BeeGFS volumes inside containerized GPU jobs running on Kubernetes.

This approach ensures secure, performant, and flexible access to shared datasets across all GPU compute nodes.

### Key Point

`BeeGFS is deployed within the Trusted Research Environment (TRE). Therefore, the same restrictions apply: BeeGFS storage is fully isolated from the internet. You cannot download data directly from public sources (e.g., GitHub, external APIs), and copying, recording, or extracting any files from BeeGFS outside of the TRE is strictly prohibited unless explicitly approved through the appropriate data governance processes.`

## Managing Files and Data in the TRE GPU Environment

The BeeGFS client is installed on the `shs-sdf01` VM, where the file system is mounted at `/mnt/clstr-beegfs`. This VM (`shs-sdf01`) is used to synchronize data between the desktop VM environment and the BeeGFS file system

This setup allows users to prepare and transfer code and datasets between the project space and BeeGFS, making them accessible to GPU jobs through Kubernetes Persistent Volumes (PVs), which are directly provisioned via the BeeGFS CSI driver.

### Storage Overview

There are three main file storage environments:

1. **Desktop VM `/home` File System**
   Accessible only when logged in via the remote desktop. Local to the VM and **not backed up**.

1. **TRE GPU Cluster BeeGFS**
   Mounted directly on GPU compute nodes using the BeeGFS CSI driver. Provides high-performance, parallel file access for compute jobs. BeeGFS data can be synchronized from the desktop VM via the `shs-sdf01` node, where the BeeGFS client is installed. Declared in Kubernetes job definitions using Persistent Volume Claims (PVCs).

1. **Project Data in `/safe_data`**
   Accessible only from the desktop VM. Backed up and used for long-term data storage. Not accessible from GPU compute nodes.
   Slower I/O performance compared to BeeGFS.

!!! warning "Important Note"
    The `/safe_data` file system cannot be used directly within GPU jobs. Instead, synchronize necessary data to BeeGFS volumes for compute workloads and transfer results back to `/safe_data` if long-term storage or backup is required.

### Accessing the BeeGFS in the TRE GPU Environment

#### Logging into the GPU File System

Users can access the BeeGFS shared file system by SSH-ing into the **`shs-sdf01`** node from their VM desktop terminal. This is used to prepare or synchronize data for GPU workloads.

#### Hello World Example

**On the VM desktop terminal:**

```bash
ssh shs-sdf01
<Enter your VM password>

echo "Hello BeeGFS World"

exit

```

#### BeeGFS vs VM file systems

The BeeGFS storage is mounted on GPU compute nodes and is **separate** from:

- The VM file system (e.g. your desktop environment),
- The project data space (`/safe_data`),
- Any local `/home` directories.

To make files available for GPU analysis jobs, they must be **explicitly transferred** between these environments.

#### Example showing separate BeeGFS and VM file systems

```bash
cd ~
touch test.txt
ls
# test.txt is visible on the desktop VM

ssh shs-sdf01
<Enter your VM password>

ls
# test.txt is NOT here (VM and BeeGFS file systems are separate)
exit

# Use scp to copy from desktop VM to BeeGFS-accessible path
scp test.txt shs-sdf01:/mnt/clstr-beegfs/<safe-heaven>/<project-id>/users/<username>/

ssh shs-sdf01
<Enter your VM password>

ls /mnt//clstr-beegfs/<safe-heaven>/<project-id>/users/<username>/
# test.txt is now here in BeeGFS

```

#### Example copying data between project data space and SDF

Transferring and synchronising data sets between the project data space and the BeeGFS is easier with the rsync command (rather than manually checking and copying files/folders with scp). rsync only transfers files that are different between the two targets, more details in its manual.

```bash
# BeeGFS Sync Workflow

## Syncing Project Data with BeeGFS

**On the VM desktop terminal:**

man rsync # check instructions for using rsync

# Sync project folder to BeeGFS mount point on shs-gpucl-fs01
rsync -avP /safe_data/my_project/ shs-sdf01:/mnt/clstr-beegfs/<safe-heaven>/<project-id>/shared

# Conduct analysis on GPU cluster using Kubernetes jobs accessing /mnt/clstr-beegfs/<safe-heaven>/<project-id>/

# After analysis, sync results back to /safe_data (if needed)
rsync -avP shs-sdf01:/mnt/clstr-beegfs/<safe-heaven>/<project-id>/users/<username>/ /safe_data/<my_project>/results/
```

*Optionally remove the project folder from BeeGFS if no longer needed.*
