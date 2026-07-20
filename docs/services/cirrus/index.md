# Overview

The Cirrus service provides access to CPU-based high-performance computing resources. As well as being part of the 
EIDF, Cirrus is one of the 

Cirrus is a HPE EX4000 supercomputing system which has a total of 256 compute nodes. Each compute node has 288 cores (dual AMD EPYC 9825 144-core 2.2 GHz processors) giving a total of 73,228 cores. 192 are standard memory compute nodes with 768 GB DDR5 RAM and 64 are high memory compute nodes with 1536 GB DDR5 RAM. Compute nodes are connected together by a HPE Slingshot 11 interconnect.

There are additional User Access Nodes (UAN, also called login nodes), which provide access to the system.

Compute nodes are only accessible via the Slurm job scheduling system.

There are two storage types: home and work. Home is available on login nodes. Work is available on login and compute nodes.

- The home file system is provided by Ceph with a capacity of 1 PB.
- The work file system consists of an HPE ClusterStor E1000 Lustre storage system with a capacity of 1 PB.

## Cirrus user documentation

The user documentation for the Cirrus service is available on a dedicated documentation site:

- [Cirrus User Documentation](https://docs.cirrus.ac.uk/)

## Cirrus service status

The current Cirrus service status is available on the dedicated Cirrus website:

- [Cirrus service status (on Cirrus website)](https://www.cirrus.ac.uk/support-access/status/)
