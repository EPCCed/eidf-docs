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

    Any running jobs will be cancelled during the monthly TRE maintenance period.

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

## Run a 'hello world' example

Create and submit job:

1. Select **New Job** menu, **From Template** option.
1. Enter Job Name: Hello World
1. Select a Cluster, back-end.
1. Click **Create New Job**.
1. View the `main_job.sh` script contents.
1. Under 'main_job.sh', click **Open Editor**.
1. A new browser tab will appear with an editor.
1. Change the line:

    ```bash
    echo "Hello World" > output_file
    ```

    to:

    ```bash
    echo "Hello World to $USER from $(hostname)" > output_file
    ```

1. Click **Save**.
1. Switch to the Job Composer browser tab.
1. Click **Submit job** (green play icon).

    ![Submit Job button, a green play icon](../../../images/open-ondemand/job-composer-play-button.png){: class="border-img center"} ***Submit Job** button*

1. The job 'Status' should go from 'Queued' to 'Completed'.

If you selected a back-end where your home directory is common to both the Open OnDemand VM and the back-end, then:

1. Click `res.txt` under **Folder Contents**.
1. A new browser tab will appear with the contents of the file:

    ```text
    Created output file with 'Hello World'
    ```

1. Close the tab.
1. Switch to the Job Composer browser tab.
1. Click `output_file` under **Folder Contents**.
1. A new browser tab will appear with the contents of the file. For example:

    ```text
    Hello World to someuser from some-vm.nsh.loc
    ```

* Close the tab.

If you selected a back-end where your home directory is not common to both the Open OnDemand VM and the back-end, then:

1. Click **Open Terminal** to log into the back-end on which the job was run. Once logged in, your current directory will be changed to match the job context directory.
1. View the job context directory and its contents:

    ```bash
    pwd
    ls -1
    ```

    ```
    /home/someuser/ondemand/data/sys/myjobs/projects/default/1
    main_job.sh
    output_file
    res.txt
    ```

1. View `res.txt`:

    ```bash
    cat res.txt
    ```

    ```
    Created output file with 'Hello World'
    ```

1. View `output_file`:

    ```bash
    cat output_file
    ```

    ```
    Hello World to someuser from some-vm.nsh.loc
    ```

---

## Run a container example

This example demonstrates how to create and submit a Slurm job that runs a bash script that runs the 'hello TRE' container which is used within the [Getting started](../getting-started.md) and the [Run Batch Container](./batch-container-app.md) app. The container is run using the TRE Container Execution Tools' commands `ces-pull`, to pull the container, and `ces-run` to run the container.

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
    #SBATCH --job-name=hello-tre
    #SBATCH --output=output.txt
    #SBATCH --ntasks=1
    #SBATCH --time=10:00
    #SBATCH --mem-per-cpu=100

    CR_URL=git.ecdf.ed.ac.uk/tre-container-execution-service/containers/epcc-ces-hello-tre:1.1
    CR_USER=anonymous
    CR_TOKEN=...see below...
    ces-pull podman $CR_USER $CR_TOKEN $CR_URL

    export CES_SCRATCH=$HOME/scratch/hello-tre
    export CES_SAFE_OUTPUTS=$HOME/safe_outputs/hello-tre
    mkdir -p $CES_SCRATCH
    mkdir -p $CES_SAFE_OUTPUTS

    cat << EOF > env_file.txt
    HELLO_TRE=Greetings
    EOF

    cat << EOF > arg_file.txt
    -d 10
    -n $USER
    EOF

    ces-run podman -n hello-tre --env-file env_file.txt --arg-file arg_file.txt $CR_URL
    ```

    * For `CR_TOKEN`, copy in the 'hello TRE' container's 'Container registry access token' from the [Run Batch Container](./batch-container-app.md) app's form.
    * By default, `ces-run` creates directories with random names - `scratch-NNNN` and `outputs-NNNN` - and mounts these into a container at `/scratch` and `/safe_outputs`. However, `ces-run` supports `CES_SCRATCH` and `CES_SAFE_OUTPUTS` environment variables, which allow for existing directories to be used. In the script above, we create subdirectories of `$HOME` and define `CES_SCRATCH` and `CES_SAFE_OUTPUTS` to tell `ces-run` to mount these directories.
    * The script creates a file, `env_file.txt`, with an environment variable to be passed to the 'hello TRE' container. The container uses the environment variable `HELLO_TRE` to customise the greeting it prints.
    * The script also creates a file, `arg_file.txt`, with container-specific arguments to be passed directly to the container when it is run. The 'hello TRE' container will pause for `-d` seconds issue a greeting to the name cited in `-n` (here, the current user).

1. Click **Save**.

Submit job:

1. Switch to the Job Composer browser tab.
1. Click **Submit job** (green play icon).

    ![Submit Job button, a green play icon](../../../images/open-ondemand/job-composer-play-button.png){: class="border-img center"} ***Submit Job** button*

1. The job 'Status' should go from 'Queued' to 'Completed'.

If you selected a back-end where your home directory is common to both the Open OnDemand VM and the back-end, then:

1. Click `output.txt` under **Folder Contents**.
1. A new browser tab will appear with the contents of the file:

    ```text
    ...
    Hello TRE!
    ...
    Greetings USER!

    Sleeping for 10 seconds...
    1
    2
    3
    4
    5
    6
    7
    8
    9
    10
    ...and awake!

    For more container examples and ideas, visit:
      https://github.com/EPCCed/tre-container-samples
    Goodbye USER!
    ```

1. Close the tab.

If you selected a back-end where your home directory is not common to both the Open OnDemand VM and the back-end, then:

1. Click **Open Terminal** to log into the back-end on which the job was run. Once logged in, your current directory will be changed to match the job context directory.
1. View the job context directory's contents:

    ```bash
    ls -1
    ```

    ```text
    arg_file.txt
    env_file.txt
    main_job.sh
    output.txt
    ```

1. View `output.txt`:

    ```bash
    cat output.txt
    ```

    ```text
    ...
    Hello TRE!
    ...
    Greetings USER!

    Sleeping for 10 seconds...
    1
    2
    3
    4
    5
    6
    7
    8
    9
    10
    ...and awake!

    For more container examples and ideas, visit:
      https://github.com/EPCCed/tre-container-samples
    Goodbye USER!
    ```

Create a new job from the current job to run the container using Apptainer:

1. Switch to the Job Composer browser tab.
1. Select **New Job** menu, **From Selected Job** option.
1. Under 'main_job.sh', click **Open Editor**.
1. Replace use of `podman` with `apptainer` as follows:

    1. Replace the `ces-pull podman` line with:

        ```bash
        cd $HOME
        ces-pull apptainer $CR_USER $CR_TOKEN $CR_URL
        SIF_FILE=$HOME/epcc-ces-hello-tre:1.1.sif
        cd $SLURM_SUBMIT_DIR
        ```

        * `ces-pull apptainer` creates a SIF file in the current directory whose name is derived from the last part of the container URL. We change into `$HOME` so that the SIF file is created in `$HOME` before moving back to the directory with the job files, `$SLURM_SUBMIT_DIR`. This means we'll only ever have one copy of this SIF file in our `$HOME` directory, rather than one copy for each run of the job, which would quickly consume space!

    1. Replace the `ces-run podman` line with:

        ```bash
        ces-run apptainer -n hello-tre --env-file env_file.txt --arg-file arg_file.txt $SIF_FILE
        ```

Submit job:

1. Switch to the Job Composer browser tab.
1. Click **Submit job** (green play icon).

    ![Submit Job button, a green play icon](../../../images/open-ondemand/job-composer-play-button.png){: class="border-img center"} ***Submit Job** button*

1. The job 'Status' should go from 'Queued' to 'Completed'.

View `output.txt` as described previously.
