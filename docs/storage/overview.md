# EIDF Storage Overview

The EIDF offers the following storage options:

- [Virtual Machine (VM) local storage](#virtual-machine-vm-local)
- [GPU local storage](#gpu-service-local)
- [Ultra2 local storage](#ultra2-local)
- [S3](#s3)
- [Shared Filesystem (CephFS)](#shared-filesystem-cephfs)
- [Data Publishing Service](#data-publishing-service)

These storage options are backed by the hardware described on this [page](https://edinburgh-international-data-facility.ed.ac.uk/about/hardware)

## Summary of Storage Options and Access

|         Service         | VM Local | GPU Local | Ultra2 Local | S3  | Shared Filesystem (CephFS) | Data Publishing Service |
| :---------------------: | :------: | :-------: | :----------: | :-: | :-------------------: | :---------------------: |
|           VMs           |   Yes    |    No     |      No      | Yes |          Yes          |           Yes           |
|       GPU Service       |    No    |    Yes    |      No      | Yes |          Yes          |           Yes           |
|         Ultra2          |    No    |    No     |     Yes      | Yes |          No           |           Yes           |
|        Cerebras         |    No    |    No     |      No      | No  |          Yes          |           No            |
|        Notebooks        |    No    |    No     |      No      | Yes |          Yes          |           Yes           |

## Persistent Volumes attached to specific services

### Virtual Machine (VM) local

Local storage on VMs is provisioned over [CephRBD](https://docs.ceph.com/en/reef/rbd/).
 This type of storage is only accessible from the VMs.

We recommend using 50 GB of local storage on VMs to ensure sufficient space for the boot partition and software installations. You can request more local storage, but we recommend using either the Shared Filesystem (CephFS) or S3 for storing user data. We will ask you to justify your resource requests for disk space in the multi-terabyte ranges.

See more general details about the [EIDF Virtual Desktop service](../services/virtualmachines/index.md).

### GPU service local

The EIDF GPU service uses persistent volumes provisioned with [CephFS](https://docs.ceph.com/en/reef/cephfs/). This is not the same storage as the Shared Filesystem (CephFS) and hence the GPU service persistent volumes are only accessible from the GPU service. Data stored in these volumes outlive the execution of jobs.

Currently GPU Service persistent volumes are included in the GPU Service costs.

See more details about the [GPU service](../services/gpuservice/index.md).

### Ultra2 local

Ultra2 uses our e1000 Lustre parallel filesystem; this storage is not accessible from anywhere else on the EIDF.

See more general details about [Ultra2](../services/ultra2/access.md).

## Storage available for use on multiple EIDF Services

### S3

The EIDF S3 is directly accessible from the VM, GPU and Ultra2 services.

We are working to make S3 accessible from the Cerebras processing unit.

S3 is accessible from anywhere in the world via S3-compatible workflows. General purpose usage outside of EIDF is documented on [Amazon's S3 documentation](https://docs.aws.amazon.com/AmazonS3/latest/userguide/Welcome.html)

See more details about [S3 at EIDF](../services/s3/index.md).

### Shared Filesystem (CephFS)

Our Shared Filesystem (CephFS) provides a parallel file system accessible across EIDF services. It is directly accessible from the VM service, GPU service, Notebook service, Cirrus and Cerebras.

Cerebras only uses Shared Filesystem (CephFS). PIs can make it available on their VMs; see how on the documentation [mounting CephFS on VMs](../services/virtualmachines/sharedfs.md).

The Shared Filesystem (CephFS) is provisioned through [CephFS](https://docs.ceph.com/en/reef/cephfs/).

See more information about the [EIDF Shared Filesystem (CephFS)](../services/virtualmachines/sharedfs.md).

## ⁠Data Publishing Service

This is accessible from all EIDF services and has public read-only access, implemented through Ceph-based S3.

The Data Publishing Service is visible from all systems with external network access except the EIDF Cerebras processing-nodes.

See more information about the [Data Publishing service](../services/datapublishing/service.md).

## Disaster Recovery

The Ultra2-local storage is replicated onto tape for recovery from disaster. Disaster recovery is triggered by disk hardware failure, not user error. Restoring data due to user actions, such as accidental file deletion, is **not** supported or planned as a service.

There is no user interface for the Disaster Recovery and any action will be taken by the EIDF team in response to issues. If you suspect disk failures on Ultra2, please raise a ticket through the EIDF Portal facility.
The EIDF Disaster Recovery is implemented through the [HPE Data Management Framework](https://www.hpe.com/us/en/collaterals/collateral.a00022795enw.html).
