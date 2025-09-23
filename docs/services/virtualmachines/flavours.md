# Flavours

These are the current Virtual Machine (VM) flavours (configurations) available on the the Virtual Desktop cloud service. Note that all VMs are built and configured using the [EIDF Portal](https://portal.eidf.ac.uk/) by PIs/Cloud Admins of projects, except GPU flavours which must be requested via the [helpdesk](mailto:eidf@epcc.ed.ac.uk) or the [support request form](https://portal.eidf.ac.uk/queries/submit).

| Flavour Name            | vCPUs | DRAM in GB | Pinned Cores | GPU |
|-------------------------|------:|-----------:|--------------|-----|
| general.v2.medium       | 4     | 8          | No           | No  |
| general.v2.large        | 8     | 16         | No           | No  |
| capability.v2.8cpu      | 8     | 112        | Yes          | No  |
| capability.v2.16cpu     | 16    | 224        | Yes          | No  |
| capability.v2.32cpu     | 32    | 448        | Yes          | No  |
| capability.v2.64cpu     | 64    | 896        | Yes          | No  |
| gpu.v1.16cpu            | 16    | 256        | Yes          | NVIDIA A100-80GB |
