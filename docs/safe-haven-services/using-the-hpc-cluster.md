# Using the TRE HPC Cluster

## Introduction

The TRE HPC system, also called the SuperDome Flex, is a single node, large memory HPC system. It is provided for compute and data intensive workloads that require more CPU, memory, and better IO performance than can be provided by the project VMs, which have the performance equivalent of small rack mount servers.

## Specifications

The system is an HPE SuperDome Flex configured with 1152 hyper-threaded cores (576 physical cores) and 18TB of memory, of which 17TB is available to users. User home and project data directories are on network mounted storage pods running the BeeGFS parallel filesystem. This storage is built in blocks of 768TB per pod. Multiple pods are available in the TRE for use by the HPC system and the total storage available will vary depending on the project configuration.

The HPC system runs Red Hat Enterprise Linux, which is not the same flavour of Linux as the Ubuntu distribution running on the desktop VMs. However, most jobs in the TRE run Python and R, and there are few issues moving between the two version of Linux. Use of virtual environments is strongly encouraged to ensure there are no differences between the desktop and HPC runtimes.

## Software Management

All system level software installed and configured on the TRE HPC system is managed by the TRE admin team. Software installation requests may be made by the Safe Haven IG controllers, research project co-ordinators, and researchers by submitting change requests through the dedicated service help desk via email.

Minor software changes will be made as soon as admin effort can be allocated. Major changes are likely to be scheduled for the TRE monthly maintenance session on the first Thursday of each month.

## HPC Login

Login to the HPC system is from the project VM using SSH and is not direct from the VDI. The HPC cluster accounts are the same accounts used on the project VMs, with the same username and password. All project data access on the HPC system is private to the project accounts as it is on the VMs, but it is important to understand that the TRE HPC cluster is shared by projects in other TRE Safe Havens.

!!! warning "One-Way SSH Access Only"
    SSH access to shs-sdf01 is strictly one-way from the project VM to the HPC system. Reverse SSH from the HPC system back to the project VM or any other system is not permitted.

To login to the HPC cluster from the project VMs use `ssh shs-sdf01` from an xterm. If you wish to avoid entry of the account password for every SSH session or remote command execution you can use SSH key authentication by following the [SSH key configuration instructions here](https://hpc-wiki.info/hpc/Ssh_keys). SSH key passphrases are not strictly enforced within the Safe Haven but are strongly encouraged.

## Running Jobs

To use the HPC system fully and fairly, all jobs must be run using the SLURM job manager. More information [about SLURM, running batch jobs and running interactive jobs can be found here](https://slurm.schedmd.com/quickstart.html). Please read this carefully before using the cluster if you have not used SLURM before. The SLURM site also has a set of useful tutorials on HPC clusters and job scheduling.

All analysis and processing jobs must be run via SLURM. SLURM manages access to all the cores on the system beyond the first 32. If SLURM is not used and programs are run directly from the command line, then there are only 32 cores available, and these are shared by the other users. Normal code development, short test runs, and debugging can be done from the command line without using SLURM.

!!! warning "There is only one node"
    The HPC system is a single node with all cores sharing all the available memory. SLURM jobs should always specify '#SBATCH --nodes=1' to run correctly.

SLURM email alerts for job status change events are not supported in the TRE.

### Resource Limits

There are no resource constraints imposed on the default SLURM partition at present. There are user limits (see the output of `ulimit -a`). If a project has a requirement for more than 200 cores, more than 4TB of memory, or an elapsed runtime of more than 96 hours, a resource reservation request should be made by the researchers through email to the service help desk.

There are no storage quotas enforced in the HPC cluster storage at present. The project storage requirements are negotiated, and space allocated before the project accounts are released. Storage use is monitored, and guidance will be issued before quotas are imposed on projects.

The HPC system is managed in the spirit of utilising it as fully as possible and as fairly as possible. This approach works best when researchers are aware of their project workload demands and cooperate rather than compete for cluster resources.

### Python Jobs

A basic script to run a Python job in a virtual environment is shown below.

```bash
#!/bin/bash
#
#SBATCH --export=ALL                  # Job inherits all env vars
#SBATCH --job-name=my_job_name        # Job name
#SBATCH --mem=512G                    # Job memory request
#SBATCH --output=job-%j.out           # Standard output file
#SBATCH --error=job-%j.err            # Standard error file
#SBATCH --nodes=1                     # Run on a single node
#SBATCH --ntasks=1                    # Run one task per node
#SBATCH --time=02:00:00               # Time limit hrs:min:sec
#SBATCH --partition standard          # Run on partition (queue)

pwd
hostname
date "+DATE: %d/%m/%Y TIME: %H:%M:%S"
echo "Running job on a single CPU core"

# Create the job’s virtual environment
source ${HOME}/my_venv/bin/activate

# Run the job code
python3 ${HOME}/my_job.py

date "+DATE: %d/%m/%Y TIME: %H:%M:%S"
```

### MPI Jobs

An example script for a multi-process MPI example is shown. The system currently supports MPICH MPI.

```bash
#!/bin/bash
#
#SBATCH --export=ALL
#SBATCH --job-name=mpi_test
#SBATCH --output=job-%j.out
#SBATCH --error=job-%j.err
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=5
#SBATCH --time=05:00
#SBATCH --partition standard

echo "Submitted Open MPI job"
echo "Running on host ${HOSTNAME}"
echo "Using ${SLURM_NTASKS_PER_NODE} tasks per node"
echo "Using ${SLURM_CPUS_PER_TASK} cpus per task"
let mpi_threads=${SLURM_NTASKS_PER_NODE}*${SLURM_CPUS_PER_TASK}
echo "Using ${mpi_threads} MPI threads"

# load Open MPI module
module purge
module load mpi/mpich-x86_64

# run mpi program
mpirun ${HOME}/test_mpi
```

### Managing Files and Data

There are three file systems to manage in the VM and HPC environment.

1. The **desktop VM /home file system**. This can only be used when you login to the VM remote desktop. This file system is local to the VM and is not backed up.
1. The **HPC system /home file system**. This can only be used when you login to the HPC system using SSH from the desktop VM. This file system is local to the HPC cluster and is not backed up.
1. The **project file and data space in the /safe\_data file system**. This file system can only be used when you login to a VM remote desktop session. This file system is backed up.

The /safe\_data file system with the project data cannot be used by the HPC system. The /safe\_data file system has restricted access and a relatively slow IO performance compared to the parallel BeeGFS file system storage on the HPC system.

The process to use the TRE HPC service is to copy and synchronise the project code and data files on the /safe\_data file system with the HPC /home file system before and after login sessions and job runs on the HPC cluster. Assuming all the code and data required for the job is in a directory 'current\_wip' on the project VM, the workflow is as follows:

1. Copy project code and data to the HPC cluster (from the desktop VM) `rsync -avPz -e ssh /safe_data/my_project/current_wip shs-sdf01:`
1. Run jobs/tests/analysis `ssh shs-sdf01`, `cd current_wip`, `sbatch/srun my_job`
1. Copy any changed project code and data back to /safe\_data (from the desktop VM) `rsync -avPz -e ssh shs-sdf01:current_wip /safe_data/my_project`
1. Optionally delete the code and data from the HPC cluster working directory.
