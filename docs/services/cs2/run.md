# Cerebras CS-2

## Introduction

The Cerebras CS-2 Wafer-scale cluster (WSC) uses the Ultra2 system which serves as a host, provides access to files, the SLURM batch system etc.

## Connecting to the cluster

To gain access to the CS-2 WSC you need to login to the host system, Ultra2 (also called SDF-CS1). See the [documentation for Ultra2](../ultra2/run.md#login).

## Running Jobs

All jobs must be run via SLURM to avoid inconveniencing other users of the system. An example job is shown below.

### SLURM example

This is based on the sample job from the Cerebras documentation [Cerebras documentation - Execute your job](https://docs.cerebras.net/en/latest/wsc/getting-started/cs-appliance.html#execute-your-job)

```bash
#!/bin/bash
#SBATCH --job-name=Example        # Job name
#SBATCH --cpus-per-task=2         # Request 2 cores
#SBATCH --output=example_%j.log   # Standard output and error log
#SBATCH --time=01:00:00           # Set time limit for this job to 1 hour
#SBATCH --gres=cs:1               # Request CS-2 system

source venv_cerebras_pt/bin/activate
srun python run.py \
     CSX \
     --params params.yaml \
     --num_csx=1 \
     --model_dir model_dir \
     --mode {train,eval,eval_all,train_and_eval} \
     --mount_dirs {paths to modelzoo and to data} \
     --python_paths {paths to modelzoo and other python code if used}
```

## Creating an environment

To run a job on the cluster, you must create a Python virtual environment (venv) and install the dependencies. The Cerebras documentation contains generic instructions to do this [Cerebras setup environment docs](https://docs.cerebras.net/en/latest/wsc/getting-started/setup-environment.html) however our host system is slightly different so we recommend the following:

1. Create the venv

```bash
/opt/python3.8/bin/python3.8 -m venv venv_cerebras_pt
```

1. Install the dependencies

```bash
source venv_cerebras_pt/bin/activate
pip install --upgrade pip
pip install cerebras_pytorch==2.0.2
```

1. Validate the setup

```bash
source venv_cerebras_pt/bin/activate
cerebras_install_check
```
