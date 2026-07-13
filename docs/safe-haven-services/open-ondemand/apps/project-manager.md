# Project Manager

Project Manager is an app that allows you to write a job for a specific job scheduler (for example, Slurm) and submit these jobs to a back-end that supports that job scheduler.

!!! Note

    To use the Project Manager requires you to have some familiarity job scheduling and job submission concepts. It will help if you are familiar with the [Slurm](https://slurm.schedmd.com) open source job scheduler and workload manager and have a familiarity with how to write Slurm job submission files.

!!! Note

    This page is intended to provide a couple of simple examples of using the Project Manager. For more information on the Project Manager, see Open OnDemand's [Tutorials: Project Manager](https://osc.github.io/ood-documentation/latest/tutorials/tutorials-project-manager.html).

!!! Warning

    Your project data files, in a project-specific directory under `/safe_data` are **not** available on back-ends outwith your safe haven (e.g., the Superdome Flex). For these, you will need to stage your data to the back-end following your project- and safe haven-specific processes for the use of such services outwith your safe haven.

!!! Warning

    Any running jobs are cancelled during the monthly Safe Haven Services maintenance period.

---

## Create and run a 'hello world' job

Create a project:

1. Click **Project Manager**.
1. The Project Manager will appear.
1. Click **Create a new project**.
1. Enter:
    * **Name**: Hello World
    * **Directory**: Leave as the default of '$HOME/ondemand/data/sys/dashboard/projects'.
    * **Group**: Leave as the default of your default user group.
1. Select **Icon** e.g., 'smile'.
1. Click **Save**.
1. The Project Manager will reappear with the new Hello World project.
1. Click **Hello World**.
1. The Hello World project dashboard will appear.

When a new project is created, the project files are created in a project directory:

```bash
$HOME/ondemand/data/sys/dashboard/projects/default/PROJECT_ID/
```

where `PROJECT_ID` is a unique job ID created by the app. For example:

```bash
$HOME/ondemand/data/sys/dashboard/projects/default/kp0lvool/
```

Create the job file(s):

1. The Project Directory section shows the project directory on the Open OnDemand host where you can create job files.
1. Within Project Directory, click **Open in files app**.
1. The File Manager will open.
1. Click **New File**.
1. Enter **Filename**: 'hello-world.sh'.
1. Click **OK**.
1. Click **...** drop-down menu by `hello-world.sh`, select **Edit**.
1. A file editor browser tab will open.
1. Add the following bash script:

    ```bash
    #!/usr/bin/env bash

    echo "Hello World to ${USER} from $(hostname)" > hello-world.txt

    echo "Created 'hello-world.txt'"
    ```

1. Click **Save**.
1. Return to the File Manager browser tab.
1. Click the browser back button to return to the Hello World dashboard.
1. Refresh the page to see `hello-world.sh` in the Project Directory.

Create a job launcher:

1. Within Launchers, click **New Launcher**.
1. Enter **Launcher Name**: Hello World Launcher.
1. Click **Save**.
1. The Hello World dashboard will reappear with Hello World Launcher under Launchers.
1. Within Launchers, Hello World, click **Edit**.
1. A page will appear which allows you to edit the launcher configuration.
1. Select a back-end, **Cluster**.

    **National Safe Haven users**: If using a 'desktop' back-end, then you must select the 'desktop' you have been granted access to.

1. Select **Script**: hello-world.sh, leave as-is.
1. Click **Add new option** to add job submission options:
    * For each option, a drop-down menu allows you to select a field, one of Hours, Queues, Account, Job Name, Log Location, Nodes, Environment Variable, Cores.
    * Once selected, click **Add** to add that field to the form.
    * Once added, enter the value for the field.
    * Add the following options and values:
        * **Job Name**: hello-world-job
        * **Log Location** output.log
        * **Nodes**: 1
        * **Cores**: 1
        * **Hours**: 1
1. Click **Save**.

!!! Tip

    For Slurm, launcher options (e.g., Hours, Queues, Account, Job Name, Log Location, Nodes, Environment Variable, Cores) can additionaly or alternatively be provided in the bash script you select as your script (e.g., `hello-world.sh` above). For example

        ```bash
        #SBATCH --job-name=hello-world
        #SBATCH --output=output.log
        #SBATCH --ntasks=1
        #SBATCH --time=01:10:00
        #SBATCH --mem-per-cpu=100
        ```

Launch the job:

1. Within Launchers, Hello World, click **Launch** to run the job.
1. Under Active Jobs, a 'NNN Queued' tag will appear, where 'NNN' is the job ID, e.g., 225', created by the job scheduler e.g., Slurm.
1. 'NNN Queued' will change to 'NNN Running' once the job starts running.
1. 'NNN Running' will change to 'NNN Completed' once the job completes.

!!! Tip

    Click on a status tag to see information about the job.

    Click on the **Stop** button to stop a queued or running job.

    Click on the **Delete** button to delete the status of a stopped or completed job.

!!! Note

    The job status can be one of: 'Not Submitted', 'Queued', 'Running', 'Hold', 'Suspend', 'Completed', 'Undetermined'.

!!! Note

    The job status does **not** display whether a job that is 'Completed' did so with success or failure. Whether a job succeeded or failed can be seen in the job details for the job which can be seen via the [Active Jobs](active-jobs.md) app.

View the output files:

* If you selected a back-end where your home directory is common to both the Open OnDemand VM and the back-end, then click the file links within Project Directory to view the file contents.
* If you selected a back-end where your home directory is not common to both the Open OnDemand VM and the back-end, then:
    1. Within Project Directory, click **Open in files app**.
    1. The File Manager will appear.
    1. Within the File Manager, click the **Open in Terminal** button's **>** side-button and select the back-end on which the job was run. Once logged in, your current directory will be changed to match the project directory.
    1. View the files:

        ```bash
        cat hello-world.txt
        cat output.log
        ```

* Example contents of each file are:

    * `hello-world.txt`:

        ```text
        Hello World to youruser from some-vm.nsh.loc
        ```

    * `output.log`

        ```text
        Created 'hello-world.txt'
        ```

---

## Create and run a job to run a container

This example continues to use the project created above, and demonstrates how to create and submit a Slurm job that runs a bash script that runs the `epcc-ces-hello` container which is the default container offered by the [Run Batch Container](./batch-container-app.md) app.

The example uses the [Safe Haven Container Execution Service - CES](../../shs-container-user-guide/introduction.md) to pull containers onto the back-end, via the `ces-pull` command, and then uses `podman` and `apptainer` in turn to run the container.

### Run container using Podman

Create the job file(s):

1. Within Project Directory, click **Open in files app**.
1. The File Manager opens.
1. Click **New File**.
1. Enter **Filename**: 'run-epcc-ces-hello.sh'.
1. Click **OK**.
1. Click the `run-epcc-ces-hello.sh` **...** side-button, select **Edit**.
1. A new browser tab opens with a file editor.
1. Add the following bash script:

    ```bash
    #!/usr/bin/env bash

    CR_URL=git.ecdf.ed.ac.uk/tre-container-execution-service/containers/epcc-ces-hello:2.1
    CR_USER=anonymous
    CR_TOKEN=... # See below...

    ces-pull podman $CR_USER $CR_TOKEN $CR_URL

    SAFE_DATA=/safe_data/PROJECT # See below...

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

    * For `CR_URL`, there is no need to cite port 5050 in the GitLab container registry URL. The `ces-pull` command adds this when it pulls the container.
    * For `CR_URL`, see [Container registries](./batch-container-app.md#container-registries) for supported container registries.
    * For `CR_TOKEN`, copy in the `epcc-ces-hello` container's 'Container registry access token' from the [Run Batch Container](./batch-container-app.md) app's form.
    * For `SAFE_DATA`, replace `PROJECT` with the name of your 'safe data' project directory in `/safe_data`. When Podman is run, your 'safe data' project directory is mounted into the container at `/safe_data` via Podman's `--mount` option.
    * The script creates a file, `envs.txt`, with an environment variable to be passed to the `epcc-ces-hello` container. The container uses the environment variable `GREETING` to customise the greeting it prints.
    * `-n` (name, here, the current user) and `-d` (doze for 10 seconds) are arguments for the `epcc-ces-hello` container itself.

1. Click **Save**.

Launch the job:

1. Within Launchers, Hello World, click **Show**.
1. Select **Script**: run-epcc-ces-hello.sh.
1. Scroll down to the end of the page.
1. Click **Launch**.

When the `epcc-ces-hello` container is run, it writes a file `YYYYMMDD-HHMMSS-USER-epcc-ces-hello.txt` into `/safe_data` within the container, and so into `/safe_data/PROJECT` on the back-end. This file includes a greeting, your user name, the container name, the date and time and a listing of the contents of `/safe_data` within the container i.e., `/safe_data/PROJECT` on the back-end. For example, a file `20260609-070028-youruser-epcc-ces-hello.txt` could contain:

```text
Greetings!

Greetings to youruser
from
epcc-ces-hello
at
2026-06-09 07:00:28

Your '/safe_data' directory includes the following files:

20260609-070028-youruser-epcc-ces-hello.txt
README
analyse_ae.R
analyse_ae.Rmd
analyse_ae.ipynb
analyse_ae.py
weekly_ae_activity_20260201.csv
```

View the file created by the container. `/safe_data` is not available on the Open OnDemand host so to view this file you will need to:

1. Click **Open Terminal** to log into the back-end on which the job was run. Once logged in, your current directory will be changed to match the job context directory.
1. View the file created by the container:

     ```bash
     ls /safe_data/PROJECT/
     cat /safe_data/PROJECT/YYYYMMDD-HHMMSS-USER-epcc-ces-hello.txt
     ```

     For example:

     ```bash
     ls /safe_data/yourproject
     cat /safe_data/20260609-070028-youruser-epcc-ces-hello.txt
     ```

When the job script runs, an `output.log` file logs the outputs captured by Slurm as the job runs.

View the log file, `output.log`:

* If you selected a back-end where your home directory is common to both the Open OnDemand VM and the back-end, then click the file links within Project Directory to view the file contents.
* If you selected a back-end where your home directory is not common to both the Open OnDemand VM and the back-end, then:
    1. Within Project Directory, click **Open in files app**.
    1. The File Manager will appear.
    1. Within the File Manager, click the **Open in Terminal** button's **>** side-button and select the back-end on which the job was run. Once logged in, your current directory will be changed to match the project directory.
    1. View the file:

        ```bash
        cat output.log
        ```

!!! Note

    For some containers run via Podman, including `epcc-ces-hello`, by default, your user name and user group on the back-end will be automatically mapped to the 'root' user name and user group in the container. This is so that scripts running within the container can read from and write to the mounted 'safe data' directory, and any other mounted directories.

    However, you are 'root' **only** within the container. Any files created in the mounted directories will be owned by 'root' within the container but by your own user, and user group, on the back-end.

    You do **not** have 'root' access on the back-end on which the container is running!

### Run container using Apptainer

Edit the job to use Apptainer instead of Podman:

1. Click the `run-epcc-ces-hello.sh` **...** side-button, select **Edit**.
1. A new browser tab opens with a file editor.
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

1. Click **Save**.
1. Within Launchers, Hello World, click **Show**.
1. Select **Script**: run-epcc-ces-hello.sh.
1. Click **Launch**.

The file created by the container and the `output.log` file can view viewed using the steps described above in the Podman example.

!!! Note

    In contrast to Podman, where your user name and user group on the back-end were automatically mapped to the 'root' user name and user group in the container, for Apptainer your user name and user group are 'yours' i.e., as they are on the back-end.

These files can be viewed using the steps described earlier.

---

## Troubleshooting: 'cd ... No such file or directory'

If you see 'cd ... No such file or directory' error after you have logged into the back-end, then this means that the project directory is not in your home directory in the back-end. This can happen if you selected a back-end where your home directory is not common to both the Open OnDemand VM and the back-end, and you have not yet submitted your job.
