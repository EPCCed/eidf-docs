# EIDF Storage Overview

The EIDF offers the following storage options:

- [VM local storage](#vm-local)
- [GPU local storage](#gpu-local)
- [Ultra2 local storage](#ultra2-local)
- [S3](#s3)
- [Shared storage (CephFS)](#shared-storage-cephfs)
- [Data Publishing Service](#data-publishing-service)

These storage options are backed by the hardware described on this [page](https://edinburgh-international-data-facility.ed.ac.uk/about/hardware)

## Storage Access

<!-- !!! Note
    Presently, no single storage solution is directly accessible from all EIDF services. We are actively working to improve cross-service accessibility. -->

### VM local

Local storage directly attached to VMs is only accessible by the VM it is attached to. It is provisioned over CephRBD.

VMs come with a default disk size of up to 50GB, but you can request more. We will ask you to justify your resource requests for disk space in the multi-terabyte ranges, but allocations up to several hundred TB fall within the standard service access model.
<!--  (sourced from EIDF sharepoint Catalogue 'Virtual Desktop.docx') -->

There is a technical limit on VMs of up 32GB for boot disks, after this other disks will need to be used

See more details about the VM service [here](../services/virtualmachines/index.md).

### GPU local

The GPU Service Persistent Volumes, are only accessible from the GPU Service.

Work is in progress for these to be provisioned by CephFS

See more details about the GPU service [here](../services/gpuservice/index.md).

### Ultra2 local

Ultra2 uses our e1000 Lustre parallel filesystem; this storage is not accessible from anywhere else on the EIDF.

See more about Ultra2 [here](../services/ultra2/access.md).

### S3

The EIDF S3, provisioned over CephFS, is directly accessible from the VMs, the GPU Service and Ultra2 (but not yet from the Cerebras processing units).

We are working to make S3 accessible from the Cerebras processing unit. S3 **may** be the first EIDF writeable storage service to be accessible across our computing infrastructure.

S3 is *not* a posix file system but visible from anywhere in the world.

See more about S3 [here](../services/s3/index.md).

### Shared storage (CephFS)

The EIDF shared storage, provisioned through CephFS, is directly accessible from the VMs, Ultra2 and the Cerebras (but not yet from the GPUs).

CephFS is a posix, parallel file system that is only accessible from within EIDF and EPCC.

!!! Note
    We are working to make shared storage accessible from the EIDF GPU Service; this will make it accessible across our computing infrastructure.

Cerebras only uses CephFS shared storage, and PIs can make it available on their VMs (and with the above development, it will also be available from the GPU Service).

See more about the EIDF shared storage [here](../services/virtualmachines/sharedfs.md).

### ⁠Data Publishing Service

This is openly accessible from all of the EIDF and any other service in the world. It is read-only, implemented through Ceph-based S3.

The Data Publishing Service is visible from all systems with external network access except the EIDF Cerebras processing-nodes.

See more about the data publishing service [here](../services/datapublishing/service.md).

## Disaster recovery and Back-up

The Ultra2-local storage is replicated onto tape for recovery from disaster. Disaster recovery is triggered by disk hardware failure, not end-user error. Restoring of data in the case of a user accidentally deleting a file is **not** possible.

Presently there is no other disaster recovery on the EIDF.

There is no plan for a EIDF back-up
