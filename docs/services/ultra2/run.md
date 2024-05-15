# Running jobs

## Software

### OneAPI

The primary HPC software provided is Intel's OneAPI suite containing mpi compilers and runtimes, debuggers and the vTune performance analyser. Standard GNU compilers are also available.
The OneAPI suite can be loaded by sourcing the shell script:

```bash
source  /opt/intel/oneapi/setvars.sh
```

## Queue system

All jobs must be run via SLURM to avoid inconveniencing other users of the system. Users should not run jobs directly. Note that the system has one logical processor with a large number of threads and thus appears to SLURM as a single node. This is intentional.

### Queue limits

We kindly request that users limit their maximum total running job size to 288 cores and 4TB of memory, whether that be a divided into a single job, or a number of jobs.
This may be enforced via SLURM in the future.

### Example MPI job

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
