# Cerebras CS-2

## Introduction

The Cerebras CS-2 Wafer-scale cluster (WSC) uses the Ultra2 system as a host system which provides login services, access to files, the SLURM batch system etc.

## Connecting to the cluster

To gain access to the CS-2 WSC you need to login to the host system, Ultra2. See the [documentation for Ultra2](../ultra2/connect.md#login).

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
python run.py \
       CSX \
       --params params.yaml \
       --num_csx=1 \
       --model_dir model_dir \
       --mode {train,eval,eval_all,train_and_eval} \
       --mount_dirs {paths to modelzoo and to data} \
       --python_paths {paths to modelzoo and other python code if used}
```

See the 'Troubleshooting' section below for known issues.

## Creating an environment

To run a job on the cluster, you must create a Python virtual environment (venv) and install the dependencies. The Cerebras documentation contains generic instructions to do this [Cerebras setup environment docs](https://docs.cerebras.net/en/latest/wsc/getting-started/setup-environment.html) however our host system is slightly different so we recommend the following:

### Create the venv

```bash
python3.8 -m venv venv_cerebras_pt
```

### Install the dependencies

```bash
source venv_cerebras_pt/bin/activate
pip install --upgrade pip
pip install cerebras_pytorch==2.2.1
```

### Validate the setup

```bash
source venv_cerebras_pt/bin/activate
cerebras_install_check
```

### Modify venv files to remove clock sync check on EPCC system

Cerebras are aware of this issue and are working on a fix, however in the mean time follow the below workaround:

### From within your python venv, edit the <venv>/lib/python3.8/site-packages/cerebras_pytorch/saver/storage.py file

```bash
vi <venv>/lib/python3.8/site-packages/cerebras_pytorch/saver/storage.py
```

### Navigate to line 530

```bash
:530
```

The section should look like this:

```python
if modified_time > self._last_modified:
    raise RuntimeError(
        f"Attempting to materialize deferred tensor with key "
        f"\"{self._key}\" from file {self._filepath}, but the file has "
        f"since been modified. The loaded tensor value may be "
        f"different from originally loaded tensor. Please refrain "
        f"from modifying the file while the run is in progress."
    )
```

### Comment out the section `if modified_time > self._last_modified`

```python
 #if modified_time > self._last_modified:
 #    raise RuntimeError(
 #        f"Attempting to materialize deferred tensor with key "
 #       f"\"{self._key}\" from file {self._filepath}, but the file has "
 #        f"since been modified. The loaded tensor value may be "
 #        f"different from originally loaded tensor. Please refrain "
 #        f"from modifying the file while the run is in progress."
        #    )
```

### Navigate to line 774

```bash
:774
```

The section should look like this:

```python
   if stat.st_mtime_ns > self._stat.st_mtime_ns:
        raise RuntimeError(
            f"Attempting to {msg} deferred tensor with key "
            f"\"{self._key}\" from file {self._filepath}, but the file has "
            f"since been modified. The loaded tensor value may be "
            f"different from originally loaded tensor. Please refrain "
            f"from modifying the file while the run is in progress."
       )
```

### Comment out the section `if stat.st_mtime_ns > self._stat.st_mtime_ns`

```python
   #if stat.st_mtime_ns > self._stat.st_mtime_ns:
   #     raise RuntimeError(
   #         f"Attempting to {msg} deferred tensor with key "
   #         f"\"{self._key}\" from file {self._filepath}, but the file has "
   #         f"since been modified. The loaded tensor value may be "
   #         f"different from originally loaded tensor. Please refrain "
   #         f"from modifying the file while the run is in progress."
   #    )
```

### Save the file

### Run jobs as per existing documentation

## Paths, PYTHONPATH and mount_dirs

There can be some confusion over the correct use of the parameters supplied to the run.py script. There is a helpful explanation page from Cerebras which explains these parameters and how they should be used. [Python, paths and mount directories.](https://docs.cerebras.net/en/latest/wsc/getting-started/mount_dir.html?highlight=mount#python-paths-and-mount-directories)
