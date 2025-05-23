# Storage FAQs

## I have deleted my important file, what can I do?

Whilst EIDF Ultra2 storage is backed up to tape for the scenario of systems failure or data loss related to the running of the service, we do not offer or plan to offer the ability to restore files from this medium in the case of user error. Users are responsible for backing up their data; otherwise, it will be permanently lost.

## I want to access storage from across all EIDF services?

Presently, no single storage solution is directly accessible from all EIDF services. We are actively working to improve cross-service accessibility.

We are working to make CephFS Shared Storage accessible from the EIDF GPU Service; this will make it accessible across our computing infrastructure.

We are working to make S3 accessible from the Cerebras processing unit. S3 **may** be the first EIDF writeable storage service to be accessible across our computing infrastructure.

In general CephFS Shared Storage or S3 are, except for the above, sharable across EIDF. S3 is additionally sharable outside EIDF infrastructure.

## I want to use the X service, which needs lots (TBs) of data

You should use the CephFS Shared Storage. We do not recommend using large, specific attached storage for VMs. This type of storage is not sharable between machines in the EIDF and relies on the same underlying system.

## I want to use the GPU service, what storage do I need?

The GPU service has its own persistent storage that should be requested via the [EIDF Helpdesk](https://portal.eidf.ac.uk/queries/submit)

The GPU service is being upgraded to use CephFS Shared Storage, when this is available it should be used as it can be shared across EIDF.

Instructions on requesting a persistent volume can be found in the [GPU service Tutorials page](https://docs.eidf.ac.uk/services/gpuservice/training/L2_requesting_persistent_volumes/#:~:text=Please%20consider%20migrating%20your%20data%20onto%20CephFS,to%20use%20the%20new%20storage%20class%20afterwards.)

## I want to use Cerebras

Cerebras only uses CephFS Shared Storage. PIs can request access to CephFS Shared Storage and configure it to be available on their VMs by contacting the [EIDF Helpdesk](https://portal.eidf.ac.uk/queries/submit) for guidance.

## I want to use Notebooks and a VM

S3 and CephFS Shared Storage can be used within the Notebook service. Notebooks and VMs are not directly shareable.
If you want to use both, you should use the CephFS Shared Storage or S3.
These are the only storage that can be shared between the two services.

See more general details about the Notebook service [here](../services/jhub/index.md).

## I have an additional question not covered, what do I do?

If you are an existing user of EIDF or other EPCC systems then please submit your queries via our [EIDF Helpdesk](https://portal.eidf.ac.uk/queries/submit). Alternatively, you may send your query via email to [eidf@epcc.ed.ac.uk](mailto:eidf@epcc.ed.ac.uk).
