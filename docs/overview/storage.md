# EIDF Storage Overview

The EIDF offers the following storage options:

- [VM local storage](#vm-local)
- [GPU local storage](#gpu-local)
- [Ultra2 local storage](#ultra2-local)
- [S3](#s3)
- [Shared storage](#shared-storage)
- [Data Publishing Service](#data-publishing-service)

These storage options are backed by the hardware described on this [page](https://edinburgh-international-data-facility.ed.ac.uk/about/hardware)

## Storage Access

!!! Note
    As of May 2025, no single storage solution is directly accessible from all EIDF services. We are actively working to improve cross-service accessibility.

### VM local

Local storage directly attached to VMs is only accessible by the VM it is attached to. It is provisioned over CephRBD.

VMs come with a default disk size of up to 50GB, but you can request more. We will ask you to justify your resource requests for disk space in the multi-terabyte ranges, but allocations up to several hundred TB fall within the standard service access model.
<!--  (sourced from EIDF sharepoint Catalogue 'Virtual Desktop.docx') -->

See more details about the VM service [here](../services/virtualmachines/index.md).

### GPU local

The GPU Service Persistent Volumes, provisioned over CephFS, are only accessible from the GPU Service.

See more details about the GPU service [here](../services/gpuservice/index.md).

### Ultra2 local

Ultra2 uses our e1000 Lustre parallel filesystem; this storage is not accessible from anywhere else on the EIDF.

See more about Ultra2 [here](../services/ultra2/access.md).

### S3

The EIDF S3, provisioned over Ceph, is directly accessible from the VMs, the GPU Service and Ultra2 (but not yet from the Cerebras processing units).
We are working to make S3 accessible from the Cerebras processing unit; S3 may be the first EIDF writeable storage service to be accessible across our computing infrastructure, likely early summer 2025.

See more about S3 [here](../services/s3/index.md).

### Shared storage

The EIDF shared storage, provisioned through CephFS, is directly accessible from the VMs, Ultra2 and the Cerebras (but not yet from the GPUs).
We are working to make shared storage accessible from the EIDF GPU Service; this will make it accessible across our computing infrastructure, likely early summer 2025.

Cerebras only uses CephFS shared storage, and PIs can make it available on their VMs (and with the above development, it will also be available from the GPU Service).

See more about the EIDF shared storage [here](../services/virtualmachines/sharedfs.md).

### ⁠Data Publishing Service

This is openly accessible from all of the EIDF and any other service in the world. It is read-only, implemented through Ceph-based S3.
The Data Publishing Service is only accessible from the EIDF Cerebras user-nodes.

See more about the data pulishing service [here](../services/datapublishing/service.md).

## Disaster recovery and Back-up

The Ultra2-local storage is replicated onto tape for disaster recovery. Disaster recovery is triggered by disk hardware failure, not end-user error.

There is no other disaster recovery on the EIDF. We are looking into options to improve this (earliest mid-2026).

There is no plan for a EIDF back-up
