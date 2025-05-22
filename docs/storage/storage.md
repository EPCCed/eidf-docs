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

### VM local

VMs have a limit of 32GB on the size of their boot disk. You can request more disks to be attached. We will ask you to justify your resource requests for disk space in the multi-terabyte ranges.

Any storage local to the VM storage is only accessible on the VM. it is provisioned over [CephRBD](https://docs.ceph.com/en/reef/rbd/)

See more general details about the VM service [here](../services/virtualmachines/index.md).

### GPU local

The GPU Service persistent volumes are only accessible from the GPU Service.

Work is in progress for these to be provisioned by the Shared Storage (CephFS).

See more general details about the GPU service [here](../services/gpuservice/index.md).

### Notebook service

### Ultra2 local

Ultra2 uses our e1000 Lustre parallel filesystem; this storage is not accessible from anywhere else on the EIDF.

See more general details about Ultra2 [here](../services/ultra2/access.md).

### S3

The EIDF S3, provisioned over CephFS, is directly accessible from the VMs, the GPU Service and Ultra2 (but not yet from the Cerebras processing units).

We are working to make S3 accessible from the Cerebras processing unit. S3 **may** be the first EIDF writeable storage service to be accessible across our computing infrastructure.

S3 is *not* a posix file system but visible from anywhere in the world.

See more about S3 at EIDF [here](../services/s3/index.md).

For general purpose S3 documentation see [Amazon's S3 documentation](https://docs.aws.amazon.com/AmazonS3/latest/userguide/Welcome.html)

### Shared Storage (CephFS)

The EIDF Shared Storage, provisioned through CephFS, is directly accessible from the VMs, Ultra2 and the Cerebras. It is not yet usable from the GPUs.

CephFS is a posix, parallel file system that is only accessible from within EIDF and EPCC.

!!! Note
    We are working to make shared storage accessible from the EIDF GPU Service; this will make it accessible across our computing infrastructure.

Cerebras only uses CephFS shared storage, and PIs can make it available on their VMs (and with the above development, it will also be available from the GPU Service).

See more general information about the EIDF shared storage [here](../services/virtualmachines/sharedfs.md).

### ⁠Data Publishing Service

This is openly accessible from all of the EIDF and any other service in the world. It is read-only, implemented through Ceph-based S3.

The Data Publishing Service is visible from all systems with external network access except the EIDF Cerebras processing-nodes.

See more general information about the data publishing service [here](../services/datapublishing/service.md).

## Disaster Recovery and User Back-up

The Ultra2-local storage is replicated onto tape for recovery from disaster. Disaster recovery is triggered by disk hardware failure, not user error.

Restoring of data in the case of a user, for example accidentally deleting a file, is **not** possible or a planned service.

Presently there is no other disaster recovery on the EIDF.
