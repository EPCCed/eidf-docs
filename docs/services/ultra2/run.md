# Ultra2 High Memory System

## Introduction
The Ultra2 system (also called the SDF-CS1) system, is a single logical CPU system based at EPCC. It is suitable for running jobs which require large volumes of non-distributed memory (as opposed to a cluster).

## Specifications
The system is a HPE SuperDome Flex containing 576 individual cores in a SMT-1 arrangement (1 thread per core). The system has 18TB of memory available to users. Home direcories are network mounted from the EIDF e1000 Lustre filesystem, although some local NVMe storage is available for temporary file storage during runs.

## Login
To login to the host system, use the username and password you obtain from [SAFE](https://www.safe.epcc.ed.ac.uk), along with the SSH Key you registered when creating the account.
You can then login directly to the host via: `ssh <username>@sdf-cs1.epcc.ed.ac.uk`

## Software
The primary software provided is Intel's OneAPI suite containing mpi compilers and runtimes, debuggers and the vTune performance analyser. Standard GNU compilers are also available.
The OneAPI suite can be loaded by sourcing the shell script:
```bash
source  /opt/intel/oneapi/setvars.sh
```


## Running Jobs
All jobs must be run via SLURM to avoid inconveniencing other users of the system. Users should not run jobs directly. Note that the system has one logical processor with a large number of threads and thus appears to SLURM as a single node. This is intentional.

## Queue limits
We kindly request that users limit their maximum total running job size to 288 cores and 4TB of memory, whether that be a divided into a single job, or a number of jobs.
This may be enforced via SLURM in the future.


### MPI jobs
An example script to run a multi-process MPI "Hello world" example is shown. 

```bash
#!/usr/bin/env bash
#SBATCH -J HelloWorld
#SBATCH --nodes=1
#SBATCH --tasks-per-node=4
#SBATCH --nodelist=sdf-cs1
#SBATCH --partition=standard
##SBATCH --exclusive


echo "Running on host ${HOSTNAME}"
echo "Using ${SLURM_NTASKS_PER_NODE} tasks per node"
echo "Using ${SLURM_CPUS_PER_TASK} cpus per task"
let mpi_threads=${SLURM_NTASKS_PER_NODE}*${SLURM_CPUS_PER_TASK}
echo "Using ${mpi_threads} MPI threads"

# Source oneAPI to ensure mpirun available
if [[ -z "${SETVARS_COMPLETED}" ]]; then
source /opt/intel/oneapi/setvars.sh
fi

# mpirun invocation for Intel suite.
mpirun -n ${mpi_threads} ./helloworld.exe
```

