# FAQs

## I have deleted my important file, what can I do?

Whilst EIDF Ultra2 storage is backed up to tape for the scenario of systems failure or data loss related to the running of the service, we do not offer or plan to offer the ability to restore files from this medium in the case of user error. As such user data requires user backup otherwise they are unfortunately lost.

## I want to access storage from across all EIDF services?

Presently, no single storage solution is directly accessible from all EIDF services. We are actively working to improve cross-service accessibility.

We are working to make shared storage (CephFS) accessible from the EIDF GPU Service; this will make it accessible across our computing infrastructure.

Shared Storage (CephFS) or S3 are sharable across EIDF. S3 is additionally sharable across the world.

## I want to use the X service, which needs lots (TBs) of data

You should use the Shared Storage of CephFS as it is sharable. We do not recommend having a huge specific attached storage for VMs as this is not sharable between machines in the EIDF and the same underlying system

## I want to use the GPU service, what storage do I need?

    The GPU service has its own persistent storage that should be requested via....

    The GPU service is being upgraded to use CephFS Shared Storage, when this is available it should be used as it can be shared across EIDF. 

### I want to use Cerebras

Cerebras only uses CephFS shared storage. PIs can make it available on their VMs
<!-- Replicated from overview/storage page -->
### I want to use Notebooks and a VM
