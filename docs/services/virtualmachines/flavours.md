# Flavours

These are the current Virtual Machine (VM) flavours (configurations) avaiable on the the Virtual Desktop cloud service. Note that all VMs are built and configured using the [EIDF Portal](https://portal.eidf.ac.uk/) by PIs of projects, except GPU flavours which much be reqested via the [helpdesk](mailto:eidf@epcc.ed.ac.uk).

| Flavour Name            | vCPUs | DRAM in GB | Pinned Cores | GPU |
|-------------------------|------:|-----------:|--------------|-----|
| general.v2.tiny         | 1     | 2          | No           | No  |
| general.v2.small        | 2     | 4          | No           | No  |
| general.v2.medium       | 4     | 8          | No           | No  |
| general.v2.large        | 8     | 16         | No           | No  |
| general.v2.xlarge       | 16    | 32         | No           | No  |
| capability.v2.8cpu      | 8     | 112        | Yes          | No  |
| capability.v2.16cpu     | 16    | 224        | Yes          | No  |
| capability.v2.32cpu     | 32    | 448        | Yes          | No  |
| capability.v2.48cpu     | 48    | 672        | Yes          | No  |
| capability.v2.64cpu     | 64    | 896        | Yes          | No  |
| gpu.v1.8cpu             | 8     | 128        | Yes          | Yes |
| gpu.v1.16cpu            | 16    | 256        | Yes          | Yes |
| gpu.v1.32cpu            | 32    | 512        | Yes          | Yes |
| gpu.v1.48cpu            | 48    | 768        | Yes          | Yes |
