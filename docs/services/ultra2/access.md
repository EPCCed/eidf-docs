# Overview

Ultra2 is a single logical CPU system based at EPCC. It is suitable for running jobs which require large volumes of non-distributed memory (as opposed to a cluster).

## Specifications

The system is a HPE SuperDome Flex containing 576 individual cores in a SMT-1 arrangement (1 thread per core). The system has 18TB of memory available to users. Home directories are network mounted from the EIDF e1000 Lustre filesystem, although some local NVMe storage is available for temporary file storage during runs.

The `/home` file system, and local NVMe storage, are not backed up.  We strongly advise that you keep copies of any critical data on on an alternative system that is fully backed up.

## Getting Access

Access to Ultra2 is currently by arrangement with EIDF. Please apply for a project on the [EIDF Portal](https://portal.eidf.ac.uk/).
