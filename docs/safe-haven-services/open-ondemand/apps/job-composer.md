# Job Composer

Job Composer is an app that allows you to write and submit a Slurm batch job to a back-end.

!!! Note

    To use the Job Composer requires you to have some familiarity with the [Slurm](https://slurm.schedmd.com) open source job scheduler and workload manager. In particular, how to write Slurm job submission files.

---

## Create Slurm job

To create a Slurm job, select the **New Job** menu, then select:

* **From Default Template** option to create a 'hello world' job from a template, with a default job name to be submitted to the default back-end, which is the first back-end you have access to in alphabetical order. If you select this option, the job files are created.
* **From Template** option to creates a 'hello world' job from a template, to be submitted to a back-end that you select. If you select this option, you can:

    1. Enter a **Job Name**.
    1. Select a back-end, **Cluster**.

        !!! Note

            **National Safe Haven users**: If using a 'desktop' back-end, then you must select the 'desktop' you have been granted access to.

    1. Click **Open Dir** to view the template job files.
    1. Click **Create New Job** to create the job files.

* **From Specified Path** option creates a new job from the contents of an existing directory. This directory can have the job submission script and any other files within it. If not, you can create/edit these before submission.
* **From Selected job** option to create a new job from the contents of the job context directory for the currently selected job on the page. If you select this option, the job files are created.

When a new job is created, the job files are created in a directory:

```bash
$HOME/ondemand/data/sys/myjobs/projects/default/JOB_COMPOSER_ID/
```

where `JOB_COMPOSER_ID` is a unique job ID created by the app. For example:

```bash
$HOME/ondemand/data/sys/myjobs/projects/default/1/
```

---

## Edit job files

Click **Open Editor** to open an editor to edit the Slurm job submission script (default name `main_job.sh`).

Click on a file name under **Folder contents** to open an editor to edit that file in the job context directory.

Click **Open Dir** or click **Edit Files** to open the [File Manager](../files.md) pointing at the job context directory.

Click **Open Terminal** (either button) to log into the back-end on which the currently selected job will be run. Once logged in, your current directory will be changed to match the job context directory.

### Troubleshooting: Edit job files 'cd ... No such file or directory'

If you see 'cd ... No such file or directory' error after you have logged into the back-end, then this means that the job context is not in your home directory in the back-end. This can happen if you selected a back-end where your home directory is not common to both the Open OnDemand VM and the back-end, and you have not yet submitted your job.

---

## Submit Slurm job

Click **Submit job** (green play icon) to submit your job.

![Submit Job button, a green play icon](../../../images/open-ondemand/job-composer-play-button.png){: class="border-img center"} ***Submit Job** button*

!!! Warning

    Any running jobs are cancelled during the monthly Safe Haven Services maintenance period.

---

## Browse and manage jobs

### Jobs table

The job name is the name of the job you specified when completing the [Create Slurm job](#create-slurm-job) form.

!!! Note

    The job name shown in the Jobs table is one entered in the **Job Name** when completing the Job Composer's job submission forms. This job name is not the same as the job name shown in the [Active Jobs](./active-jobs.md) app. That job name is an app-specific job scheduler-specific job name. For the Job Composer and Slurm, the Active Jobs job name is the value of the Slurm `--job-name` parameter (set by `#SBATCH --job-name=...` in the job file).

The job ID is a unique job ID created by the Slurm job scheduler, when you submitted the job.

The job status can be one of: 'Not Submitted', 'Queued', 'Running', 'Hold', 'Suspend', 'Completed', 'Undetermined'.

!!! Note

    The job status does **not** display whether a job that is 'Completed' did so with success or failure. Whether a job succeeded or failed can be seen in the job details for the job which can be seen via the [Active Jobs](active-jobs.md) app.

### Open File Manager to job context directory

Click **Open Dir** or click **Edit Files** to open the [File Manager](../files.md) pointing at the job context directory for the currently selected job.

!!! Note

    When using a back-end where your home directory is not common to both the Open OnDemand VM and the back-end, then, if your job creates files on the back-end, you will have to log into the back-end to view your files - see [Log into back-ends](../ssh.md).

### Log into to back-end

Click **Open Terminal** (either button) to log into the back-end on which the currently selected job will be run, is running or was run. Once logged in, your current directory will be changed to match the job context directory.

#### Troubleshooting: Log into back-end 'cd ... No such file or directory'

If you see 'cd ... No such file or directory' error after you have logged into the back-end, then this means that the job context is not in your home directory in the back-end. This can happen if you selected a back-end where your home directory is not common to both the Open OnDemand VM and the back-end, and you have not yet submitted your job.

### Stop a job

Click **Stop Job** (amber stop icon) to stop the currently selected job.

![Stop Job button, an amber stop icon](../../../images/open-ondemand/job-composer-stop-button.png){: class="border-img center"} ***Stop Job** button*

### Delete a job

Click **Delete Job** (red trashcan icon) to stop and delete the currently selected job.

![Delete Job button, a red trashcan icon](../../../images/open-ondemand/job-composer-delete-button.png){: class="border-img center"} ***Delete Job** button*

The job context directory for the job will also be deleted.

---

## Run a 'hello there' example

Create and submit job:

1. Select **New Job** menu, **From Template** option.
1. Enter Job Name: Hello There
1. Select a Cluster, back-end.
1. Click **Create New Job**.
1. Under 'main_job.sh', click **Open Editor**.
1. A new browser tab will appear with an editor.
1. Read the `main_job.sh` script contents.
1. Change the line:

    ```bash
    echo "Hello There" > output_file
    ```

    to:

    ```bash
    echo "Hello There to ${USER} from $(hostname)" > output_file
    ```

1. Click **Save**.
1. Switch to the Job Composer browser tab.
1. Click **Submit job** (green play icon).

    ![Submit Job button, a green play icon](../../../images/open-ondemand/job-composer-play-button.png){: class="border-img center"} ***Submit Job** button*

1. The job 'Status' should go from 'Queued' to 'Completed'.

The script creates two files:

* `res.txt` which has the outputs captured by Slurm as the job runs. For example:

    ```text
    Created output file with 'Hello There'
    ```

* `output_file` which is the file created within the job script. For example:

    ```text
    Hello There to some-user from some-vm.nsh.loc
    ```

View the output files:

* If you selected a back-end where your home directory is common to both the Open OnDemand VM and the back-end, then:
    1. Click `res.txt` under **Folder Contents**.
    1. A new browser tab will appear with the contents of the file.
    1. Switch to the Job Composer browser tab.
    1. Click `output_file` under **Folder Contents**.
    1. A new browser tab will appear with the contents of the file.
* If you selected a back-end where your home directory is not common to both the Open OnDemand VM and the back-end, then:
    1. Click **Open Terminal** to log into the back-end on which the job was run. Once logged in, your current directory will be changed to match the job context directory.
    1. View `res.txt`:

        ```bash
        cat res.txt
        ```

    1. View `output_file`:

        ```bash
        cat output_file
        ```

---

## Run a container example

This example demonstrates how to create and submit a Slurm job that runs a bash script that runs the `epcc-ces-hello` container which is the default container offered by the [Run Batch Container](./batch-container-app.md) app. The container is run using the Safe Haven Services Container Execution Tools' command `ces-pull`, to pull the container, and then `podman` or `apptainer` to run the container.

### Run container using Podman

Create a job to run the container using Podman:

1. Select **New Job** menu, **From Template** option.
1. Enter Job Name: Run Container
1. Select a Cluster, back-end.
1. Click **Create New Job**.
1. Under 'main_job.sh', click **Open Editor**.
1. A new browser tab will appear with an editor.
1. Update the script as follows:

    ```bash
    #!/bin/bash
    #SBATCH --job-name=hello-there
    #SBATCH --output=output.log
    #SBATCH --ntasks=1
    #SBATCH --time=10:00
    #SBATCH --mem-per-cpu=100

    CR_URL=git.ecdf.ed.ac.uk/tre-container-execution-service/containers/epcc-ces-hello:2.1
    CR_USER=anonymous
    CR_TOKEN=... # See below...
    ces-pull podman $CR_USER $CR_TOKEN $CR_URL

    SAFE_DATA=/safe_data/PROJECT_DIRECTORY # See below...

    cat << EOF > envs.txt
    GREETING=Greetings
    EOF

    podman run --name epcc-ces-hello \
        --mount type=bind,source=${SAFE_DATA},destination=/safe_data \
        --pull=never --rm=true --rmi=false \
        --env-file=envs.txt \
        ${CR_URL} \
        -d 5 -n ${USER}
    ```

    * For `CR_TOKEN`, copy in the `epcc-ces-hello` container's 'Container registry access token' from the [Run Batch Container](./batch-container-app.md) app's form.
    * For `SAFE_DATA`, replace `PROJECT_DIRECTORY` with the name of your 'safe data' project directory in `/safe_data`. When Podman is run, your 'safe data' project directory is mounted into the container at `/safe_data` via Podman's `--mount` option.
    * The script creates a file, `envs.txt`, with an environment variable to be passed to the `epcc-ces-hello` container. The container uses the environment variable `GREETING` to customise the greeting it prints.
    * `-n` (name, here, the current user) and `-d` (doze for 10 seconds) are arguments for the `epcc-ces-hello` container itself.

1. Click **Save**.

Submit job:

1. Switch to the Job Composer browser tab.
1. Click **Submit job** (green play icon).

    ![Submit Job button, a green play icon](../../../images/open-ondemand/job-composer-play-button.png){: class="border-img center"} ***Submit Job** button*

1. The job 'Status' should go from 'Queued' to 'Completed'.

When the job script runs, two files are created. One file, `output.log`, has the outputs captured by Slurm as the job runs. For example:

```text
Running: /usr/local/bin/ces-pm-pull anonymous <CR_TOKEN> git.ecdf.ed.ac.uk/tre-container-execution-service/containers/epcc-ces-hello:2.1
Trying pull proxy host tre-ghcr-proxy.nsh.loc
Using CES CR Proxy API: addproxy
Pulling container: tre-ghcr-proxy.nsh.loc:5001/tre-container-execution-service/containers/epcc-ces-hello:2.1
...
Entered epcc-ces-hello container
/safe_data users, groups and permissions:
/safe_data: nobody (65534) root(0) drwxrws--- nfs
Container user ID: 0(root)
Container group ID: 0(root)
Container user groups: 0(root)
Found optional 'GREETING' environment variable: Greetings
Script arguments: -d 5 -n some-user
name: some-user
doze: 5
Writing /safe_data/20260609-070028-some-user-epcc-ces-hello.txt
Dozing for 5 seconds...
1
2
3
4
5
...and awake!
Exiting epcc-ces-hello container
```

!!! Note

    For some containers run via Podman, including `epcc-ces-hello`, by default, your user name and user group on the back-end will be automatically mapped to the 'root' user name and user group in the container. This is so that scripts running within the container can read from and write to the mounted 'safe data' directory, and any other mounted directories.

    However, you are 'root' **only** within the container. Any files created in the mounted directories will be owned by 'root' within the container but by your own user, and user group, on the back-end.

    You do **not** have 'root' access on the back-end on which the container is running!

The other file created when the job script runs is `/safe_data/<PROJECT_DIRECTORY>/<YYYYMMDD-HHMMSS-<USER>-epcc-ces-hello.txt` which is a file created by the container itself. This file includes a greeting, your user name, the container name, the date and time and a listing of the contents of `/safe_data` within the container (i.e., your `/safe_data/<PROJECT_DIRECTORY>`) on the back-end. For example, `/safe_data/some-project/20260609-070028-some-user-epcc-ces-hello.txt`:

```text
Greetings!

Greetings to some-user
from
epcc-ces-hello
at
2026-06-09 07:00:28

Your '/safe_data' directory includes the following files:

20260609-070028-some-user-epcc-ces-hello.txt
README
analyse_ae.R
analyse_ae.Rmd
analyse_ae.ipynb
analyse_ae.py
weekly_ae_activity_20260201.csv
```

View the log file, `output.log`:

* If you selected a back-end where your home directory is common to both the Open OnDemand VM and the back-end, then:
    1. Click `output.log` under **Folder Contents**.
    1. A new browser tab will appear with the contents of the file.
* If you selected a back-end where your home directory is not common to both the Open OnDemand VM and the back-end, then:
    1. Click **Open Terminal** to log into the back-end on which the job was run. Once logged in, your current directory will be changed to match the job context directory.
    1. View `output.log`:

        ```bash
        cat output.log
        ```

View the file created by the container, `/safe_data/<PROJECT_DIRECTORY>/<YYYYMMDD-HHMMSS-<USER>-epcc-ces-hello.txt`. `/safe_data` is not mounted into the Open OnDemand host so to view this file you will need to:

1. Click **Open Terminal** to log into the back-end on which the job was run. Once logged in, your current directory will be changed to match the job context directory.
1. View `$HOME/safe_outputs/epcc-ces-hello.txt`:

     ```bash
     ls /safe_data/<PROJECT_DIRECTORY>/
     cat /safe_data/<PROJECT_DIRECTORY>/<YYYYMMDD-HHMMSS-<USER>-epcc-ces-hello.txt
     ```

     For example:

     ```bash
     ls /safe_data/some-project
     cat /safe_data/20260609-070028-some-user-epcc-ces-hello.txt
     ```

### Run container using Apptainer

Create a new job from the current job to run the container using Apptainer:

1. Switch to the Job Composer browser tab.
1. Select **New Job** menu, **From Selected Job** option.
1. Under 'main_job.sh', click **Open Editor**.
1. Replace use of `podman` with `apptainer` as follows:

    1. Replace the `ces-pull podman` line with the lines:

        ```bash
        cd ${HOME}
        ces-pull apptainer $CR_USER $CR_TOKEN $CR_URL
        SIF_FILE=${HOME}/epcc-ces-hello:2.1.sif
        cd ${SLURM_SUBMIT_DIR}
        ```

        `ces-pull apptainer` creates an Apptainer SIF file in the current directory whose name is derived from the last part of the container URL. We change into `$HOME` so that the SIF file is created in `$HOME` before moving back to the directory with the job files, `$SLURM_SUBMIT_DIR`. This means we will only ever have one copy of this SIF file in our `$HOME` directory, rather than one copy for each run of the job, which would quickly consume space!

    1. Replace the `podman run` line with:

        ```bash
        apptainer run --bind ${SAFE_DATA}:/safe_data \
            --no-https=true \
            --env-file=envs.txt \
            ${HOME}/epcc-ces-hello:2.1.sif \
            -d 5 -n ${USER}
        ```

         When Apptainer is run, your 'safe data' project directory is mounted into the container at `/safe_data` via Apptainer's `--bind` option.

Submit job:

1. Switch to the Job Composer browser tab.
1. Click **Submit job** (green play icon).

    ![Submit Job button, a green play icon](../../../images/open-ondemand/job-composer-play-button.png){: class="border-img center"} ***Submit Job** button*

1. The job 'Status' should go from 'Queued' to 'Completed'.

View the log file, `output.log`, and the file created by the container, `/safe_data/<PROJECT_DIRECTORY>/<YYYYMMDD-HHMMSS-<USER>-epcc-ces-hello.txt`, using the steps described earlier.

An example of `output.log` produced by this example is as follows:

```text
Running: /usr/local/bin/ces-app-pull anonymous <CR_TOKEN> git.ecdf.ed.ac.uk/tre-container-execution-service/containers/epcc-ces-hello:2.1
Trying pull proxy host tre-ghcr-proxy.nsh.loc
Using CES CR Proxy API: addproxy
Pulling container: tre-ghcr-proxy.nsh.loc:5001/tre-container-execution-service/containers/epcc-ces-hello:2.1
...
INFO:Creating SIF file...
INFO:Build complete: epcc-ces-hello:2.1.sif
Entered epcc-ces-hello container
/safe_data users, groups and permissions:
/safe_data: nobody (65534) some-project(4797) drwxrws--- nfs
Container user ID: 36177(some-user)
Container group ID: 4797(some-project)
Container user groups: 4797(some-project),65534(nogroup)
Found optional 'GREETING' environment variable: Greetings
Script arguments: -d 5 -n some-user
name: some-user
doze: 5
Writing /safe_data/20260609-075213-some-user-epcc-ces-hello.txt
Dozing for 5 seconds...
1
2
3
4
5
...and awake!
Exiting epcc-ces-hello container
```

!!! Note

    In constrast to Podman, where your user name and user group on the back-end were automatically mapped to the 'root' user name and user group in the container, for Apptainer your user name and user group are 'yours' i.e., as they are on the back-end.

An example of the file created by the container, here `/safe_data/some-project/20260609-075213-some-user-epcc-ces-hello.txt` is:

```text
Greetings!

Greetings to some-user
from
epcc-ces-hello
at
2026-06-09 07:52:13

Your '/safe_data' directory includes the following files:

20260609-070028-some-user-epcc-ces-hello.txt
20260609-075213-some-user-epcc-ces-hello.txt
README
analyse_ae.R
analyse_ae.Rmd
analyse_ae.ipynb
analyse_ae.py
weekly_ae_activity_20260201.csv
```
