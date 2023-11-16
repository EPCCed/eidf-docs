# Cerebras CS-2

## Introduction

The Cerebras CS-2 system is attached to the Ultra2 system which serves as a host, provides access to files, the SLURM batch system etc.

## Connecting to the CS-2

To gain access to the CS-2 you need to login to the host system, Ultra2 (also called SDF-CS1). See the [documentation for Ultra2](../ultra2/run.md#login).

## Running Jobs

All jobs must be run via SLURM to avoid inconveniencing other users of the system. The `csrun_cpu` and `csrun_wse` scripts themselves contain calls to `srun` to work with the SLURM system, so note the omission of `srun` in the below examples.
Users can either copy these files from `/home/y26/shared/bin` to their own home directory should they wish, or use the centrally supplied version. In either case, ensure they are in your `PATH` before execution, eg:

```bash
export PATH=$PATH:/home/y26/shared/bin
```

### Run on the host

Jobs can be run on the host system (eg simulations, test scripts) using the `csrun_cpu` wrapper. Here is the example from the Cerebras documentation on PyTorch. Note that this assumes csrun_cpu is in your path.

```bash
#!/bin/bash
#SBATCH --job-name=Example        # Job name
#SBATCH --cpus-per-task=2         # Request 2 cores
#SBATCH --output=example_%j.log   # Standard output and error log
#SBATCH --time=01:00:00           # Set time limit for this job to 1 hour

csrun_cpu python-pt run.py --mode train --compile_only --params configs/<name-of-the-params-file.yaml>
```

### Run on the CS-2

The following will run the above PyTorch example on the CS-2 - note the `--cs_ip` argument with port number passed in via the command line, and the inclusion of the `--gres` option to request use of the CS-2 via SLURM.

```bash
#!/bin/bash
#SBATCH --job-name=Example        # Job name
#SBATCH --tasks-per-node=8        # There is only one node on SDF-CS1
#SBATCH --cpus-per-task=16        # Each cpu is a core
#SBATCH --gres=cs:1               # Request CS-2 system
#SBATCH --output=example_%j.log   # Standard output and error log
#SBATCH --time=01:00:00           # Set time limit for this job to 1 hour


csrun_wse python-pt run.py --mode train --cs_ip 172.24.102.121:9000 --params configs/<name-of-the-params-file.yaml>
```
