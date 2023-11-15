# Ultra2 High Memory System

## Introduction

The Ultra2 system (also called the SDF-CS1) system, is a single logical CPU system based at EPCC. It is suitable for running jobs which require large volumes of non-distributed memory (as opposed to a cluster).

## Specifications

The system is a HPE SuperDome Flex containing 576 individual cores in a SMT-1 arrangement (1 thread per core). The system has 18TB of memory available to users. Home directories are network mounted from the EIDF e1000 Lustre filesystem, although some local NVMe storage is available for temporary file storage during runs.

## Login

Login is via SSH only via `ssh <username>@sdf-cs1.epcc.ed.ac.uk`. See below for details on the credentials required to access the system.

### Access credentials

To access Ultra2, you need to use two credentials: your SSH key pair protected by a passphrase **and** a Time-based one-time password (TOTP).

### SSH Key Pairs

You will need to generate an SSH key pair protected by a passphrase to access Ultra2.

Using a terminal (the command line), set up a key pair that contains your e-mail address and enter a passphrase you will use to unlock the key:

```bash
    $ ssh-keygen -t rsa -C "your@email.com"
    ...
    -bash-4.1$ ssh-keygen -t rsa -C "your@email.com"
    Generating public/private rsa key pair.
    Enter file in which to save the key (/Home/user/.ssh/id_rsa): [Enter]
    Enter passphrase (empty for no passphrase): [Passphrase]
    Enter same passphrase again: [Passphrase]
    Your identification has been saved in /Home/user/.ssh/id_rsa.
    Your public key has been saved in /Home/user/.ssh/id_rsa.pub.
    The key fingerprint is:
    03:d4:c4:6d:58:0a:e2:4a:f8:73:9a:e8:e3:07:16:c8 your@email.com
    The key's randomart image is:
    +--[ RSA 2048]----+
    |    . ...+o++++. |
    | . . . =o..      |
    |+ . . .......o o |
    |oE .   .         |
    |o =     .   S    |
    |.    +.+     .   |
    |.  oo            |
    |.  .             |
    | ..              |
    +-----------------+
```

(remember to replace "<your@email.com>" with your e-mail address).

### Upload public part of key pair to SAFE

You should now upload the public part of your SSH key pair to the SAFE by following the instructions at:

[Login to SAFE](https://safe.epcc.ed.ac.uk/). Then:

 1. Go to the Menu *Login accounts* and select the Ultra2 account you want to add the SSH key to
 1. On the subsequent Login account details page click the *Add Credential* button
 1. Select *SSH public key* as the Credential Type and click *Next*
 1. Either copy and paste the public part of your SSH key into the *SSH Public key* box or use the button to select the public key file on your computer.
 1. Click *Add* to associate the public SSH key part with your account

Once you have done this, your SSH key will be added to your Ultra2 account.

### Time-based one-time password (TOTP)

Remember, you will need to use both an SSH key and Time-based one-time password to log into Ultra2 so you will also need to [set up your TOTP](https://epcced.github.io/safe-docs/safe-for-users/#how-to-turn-on-mfa-on-your-machine-account) before you can log into Ultra2.

!!! Note

    When you **first** log into Ultra2, you will be prompted to change your initial password. This is a three step process:

    1.  When promoted to enter your *password*: Enter the password  which you [retrieve from SAFE](https://epcced.github.io/safe-docs/safe-for-users/#how-can-i-pick-up-my-password-for-the-service-machine)

    2.  When prompted to enter your new password: type in a new password

    3.  When prompted to re-enter the new password: re-enter the new password

    Your password has now been changed<br>
    You will **not** use your password when logging on to Ultra2 after the initial logon.

### SSH Login

To login to the host system, you will need to use the SSH Key and TOTP token you registered when creating the account [SAFE](https://www.safe.epcc.ed.ac.uk), along with the SSH Key you registered when creating the account. For example, with the appropriate key loaded<br>`ssh <username>@sdf-cs1.epcc.ed.ac.uk` will then prompt you, once per 24 hours, for your TOTP code.

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
