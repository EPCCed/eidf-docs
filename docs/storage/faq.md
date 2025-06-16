# Storage FAQs

## I have deleted my important file, what can I do?

The EIDF does not offer a backup service and only replicates Ultra2-local storage.

Whilst EIDF Ultra2 storage is replicated to tape in case of system failure or data loss related to the running of the service, we do **not** offer or plan to offer the ability to restore files from this medium in the case of user error.

Users are responsible for backing up their data against user error.

## I want to access storage from across all EIDF services

The Shared Filesystem (CephFS) is available throughout EIDF services.

We are actively working to improve cross-service accessibility of S3. Currently the only remaining issue is that S3 is not accessible from the Cerebras processing unit.

## I want to make my data available outside EIDF, what storage should I use?

The Data Publishing Service provides public read access for data to be shared outside of the EIDF infrastructure.

S3 storage is sharable outside EIDF infrastructure. The EIDF S3 service is accessible from anywhere in the world via S3-compatible workflows. General purpose usage outside of EIDF is documented on [Amazon's S3 documentation](https://docs.aws.amazon.com/AmazonS3/latest/userguide/Welcome.html).

## I want to process multi-terabyte data on multiple VMs and potentially other EIDF services, what storage should I use?

You should use the Shared Filesystem (CephFS) or S3. We do not recommend using large, specific attached storage for VMs. This type of storage is not sharable between machines in the EIDF and relies on the same underlying system.

PIs can request access to Shared Filesystem (CephFS) and can configure it to be available on their VMs by following the documentation in the [Virtual Machines section](https://docs.eidf.ac.uk/services/virtualmachines/sharedfs/).

## I want to use the GPU Service, what storage do I need?

The GPU Service has persistent storage attached, requested computationally by the user. Instructions on the format of this request can be found on the [GPU Service Tutorials page](../services/gpuservice/training/L2_requesting_persistent_volumes.md#overview)

S3 storage can be used from the GPU Service. This is useful when data is to be shared across EIDF Services and beyond.

The GPU Service is also able to use the EIDF Shared Filesystem (CephFS), which can share data across EIDF services, but not beyond. For more information on this please refer to [Shared Filesystem (CephFS) PVCs](../services/gpuservice/shared-cephfs.md)

## I want to use Cerebras, what storage do I need?

Cerebras only uses Shared Filesystem (CephFS). PIs can request access to Shared Filesystem (CephFS) and can configure it to be available on their VMs by following the documentation in the [Virtual Machines section](https://docs.eidf.ac.uk/services/virtualmachines/sharedfs/).

## I want to use more storage?

If you need more storage than what is available by default, you can request additional storage through the [EIDF Helpdesk](https://portal.eidf.ac.uk/queries/submit). Please provide details about your requirements and the intended use of the storage. Within the form above please select the category 'EIDF Project extension: duration and quota'.

## I want to use Notebooks and a VM, what storage do I need?

Both the Notebook Service and VM Service have their own local storage, but these local storage areas are not directly accessible between services. If you need to share data between Notebooks, VMs, and other EIDF services, you should use either the Shared Filesystem (CephFS) or S3 storage. These are the only storage options that allow seamless data sharing across different EIDF services.

See more details about the [Notebook Service](../services/jhub/index.md).

## I have an additional question not covered, what do I do?

If you are an existing user of EIDF or other EPCC systems, please submit your queries via our [EIDF Helpdesk](https://portal.eidf.ac.uk/queries/submit). Alternatively, you may send your query via email to [eidf@epcc.ed.ac.uk](mailto:eidf@epcc.ed.ac.uk).
