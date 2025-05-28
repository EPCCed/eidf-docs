# EIDF Storage Overview

The EIDF offers the following storage options:

- [Virtual Machine (VM) local storage](#virtual-machine-vm-local)
- [GPU local storage](#gpu-local)
- [Ultra2 local storage](#ultra2-local)
- [S3](#s3)
- [CephFS Shared Storage](#cephfs-shared-storage)
- [Data Publishing Service](#data-publishing-service)

These storage options are backed by the hardware described on this [page](https://edinburgh-international-data-facility.ed.ac.uk/about/hardware)

## Persistent Volumes attached to specific services

### Virtual Machine (VM) local

VMs have a limit of 32TB on the size of a VM's boot disk. We recommend using a 50GB default size of boot disk for software installations. Whilst you can request more disks to be attached we recommend user data use CephFS or S3. We will ask you to justify your resource requests for disk space in the multi-terabyte ranges.

Storage local to the VM is provisioned over [CephRBD](https://docs.ceph.com/en/reef/rbd/). It is only accessible on the VM.

See more general details about the [VM service](../services/virtualmachines/index.md).

### GPU local

The GPU Service persistent volumes are only accessible from the GPU Service. We are working on provisioning these with the CephFS Shared Storage.

CephFS Shared Storage will be available as a shared file storage per project. CephFS will count towards the persistent storage costs whereas the GPU Service persistent volumes are included in the GPU Service costs.

See more details about the [GPU service](../services/gpuservice/index.md).

### Ultra2 local

Ultra2 uses our e1000 Lustre parallel filesystem; this storage is not accessible from anywhere else on the EIDF.

See more general details about [Ultra2](../services/ultra2/access.md).

## Storage available for use on multiple EIDF Services

### S3

The EIDF S3, provisioned over CephFS, is directly accessible from the VM, GPU and Ultra2 services.

We are working to make S3 accessible from the Cerebras processing unit. S3 **may** be the first EIDF writeable storage service accessible across our computing infrastructure.

S3 is accessible from anywhere in the world via S3-compatible workflows. General purpose usage outside of EIDF is documented on [Amazon's S3 documentation](https://docs.aws.amazon.com/AmazonS3/latest/userguide/Welcome.html)

See more about [S3 at EIDF](../services/s3/index.md).

### CephFS Shared Storage

CephFS provides a parallel file system accessible across EIDF services. It is directly accessible from the VMs, Ultra2 and the Cerebras.

!!! Note
    **CephFS is not yet usable from the GPU service.**

We are working to make shared storage accessible from the EIDF GPU Service; Once available this will make it accessible across our entire computing infrastructure.

Cerebras only uses CephFS Shared Storage. PIs can make it available on their VMs; see how on the documentation [mounting CephFS on VMs](../services/virtualmachines/sharedfs.md).

See more information about the [EIDF Shared Storage](../services/virtualmachines/sharedfs.md).

## ⁠Data Publishing Service

This is accessible from all EIDF services and has public read access. It is read-only, implemented through Ceph-based S3.

The Data Publishing Service is visible from all systems with external network access except the EIDF Cerebras processing-nodes.

See more information about the [Data Publishing service](../services/datapublishing/service.md).

## Disaster Recovery and User Back-up

The Ultra2-local storage is replicated onto tape for recovery from disaster. Disaster recovery is triggered by disk hardware failure, not user error.

Restoring data due to user actions, such as accidental file deletion, is **not** supported or planned as a service.

Presently there is no other disaster recovery on the EIDF.

## Summary of Storage Options and Access

|         Service         | VM Local | GPU Local | Ultra2 Local | S3  | CephFS Shared Storage | Data Publishing Service |
| :---------------------: | :------: | :-------: | :----------: | :-: | :-------------------: | :---------------------: |
|           VMs           |   Yes    |    No     |      No      | Yes |          Yes          |           Yes           |
|       GPU Service       |    No    |    Yes    |      No      | Yes |          No           |           Yes           |
|         Ultra2          |    No    |    No     |     Yes      | Yes |          Yes          |           Yes           |
|        Cerebras         |    No    |    No     |      No      | No  |          Yes          |           No            |
|        Notebooks        |    No    |    No     |      No      | Yes |          Yes          |           Yes            |
