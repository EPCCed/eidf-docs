# Overview

The EIDF Virtual Machine (VM) Service is the underlying infrastructure upon which the EIDF Data Science Cloud (DSC) is built.

The service currently has a mixture of hardware node types which host VMs of various [flavours](flavours.md):

- The mcomp nodes which host general flavour VMs are based upon AMD EPYC 7702 CPUs (128 Cores) with 1TB of DRAM
- The hcomp nodes which host capability flavour VMs are based upon 4x Intel Xeon Platinum 8280L CPUs (224 Threads, 112 cores with HT) with 3TB of DRAM
- The GPU nodes which host GPU flavour VMs are based upon 2x Intel Xeon Platinum 8260 CPUs (96 Cores) with 4x Nvidia Tesla V100S 32GB and 1.5TB of DRAM

The shapes and sizes of the flavours are based on subdivisions of this hardware, noting that CPUs are 4x oversubscribed for mcomp nodes (general VM flavours).

## Service Access

Users should have an EIDF account - [EIDF Accounts](../../access/project.md).

Project Leads will be able to have access to the DSC added to their project during the project application process or through a request to the EIDF helpdesk.

## Additional Service Policy Information

Additional information on service policies can be found [here](policies.md).
