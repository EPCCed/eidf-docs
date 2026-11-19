# Overview

The Cirrus service provides access to CPU-based high-performance computing resources. As well as being part of the
EIDF, Cirrus is one of the UKRI National Compute Resources (NCRs).

Cirrus is a HPE EX4000 supercomputing system which has a total of 640 compute nodes. Each compute node has 288 cores (dual AMD EPYC 9825 144-core 2.2 GHz processors) giving a total of 184,320 cores. 576 are standard memory compute nodes with 768 GB DDR5 RAM and 64 are high memory compute nodes with 1536 GB DDR5 RAM. Compute nodes are connected together by a HPE Slingshot 11 interconnect.

There are additional User Access Nodes (UAN, also called login nodes), which provide access to the system.

Compute nodes are only accessible via the Slurm job scheduling system.

Storage is provided via two file systems:

- 1 PB Ceph distributed file system for critical data storage. Mounted on all login nodes (not available on compute nodes). Not backed up.
- NAIDIN (EPCCFS) storage provides high-performance and high-capacity data storage. Mounted on all login and compute nodes. Not backed up.

When costing access to Cirrus in the EIDF Portal, you must add CephFS and VAST storage as they are required for you to be able to use Cirrus.

More detailed information is available in the [Hardware section of the Cirrus User Guide](https://docs.cirrus.ac.uk/user-guide/hardware/).

## Cirrus user documentation

The user documentation for the Cirrus service is available on a dedicated documentation site:

- [Cirrus User Documentation](https://docs.cirrus.ac.uk/)

## Cirrus service status

The current Cirrus service status is available on the dedicated Cirrus website:

- [Cirrus service status (on Cirrus website)](https://www.cirrus.ac.uk/support-access/status/)
