# Job Composer

Job Composer is an Open OnDemand app that allows you to submit a Slurm batch job to a back-end.

!!! Info

    To use the Job Composer app requires you to have some familiarity with the [Slurm](https://slurm.schedmd.com) open source job scheduler and workload manager. In particular, how to write Slurm job submission files.

---

## Create Slurm job

To create a Slurm job, select the **New Job** menu, then select:

* **From Default Template** option to create a 'hello world' job from a template, with a default job name to be submitted to the default back-end, which is the first back-end you have access to in alphabetical order. If you select this option, the job files are created.
* **From Template** option to creates a 'hello world' job from a template, to be submitted to a back-end that you select. If you select this option, you can:
    * Enter a 'Job Name'.
    * Select a back-end, 'Cluster'.
        * **National Safe Haven users**: If you want to use a 'desktop' back-end, then you must select the 'desktop' you have been granted access to.
    * Click **Open Dir** to view the template job files.
    * Click **Create New Job** to create the job files.
* **From Specified Path** option creates a new job from the contents of an existing directory. This directory can have the job submission script and any other files within it. If not, you can create/edit these before submission.
* **From Selected job** option to create a new job from the contents of the job context directory for the currently selected job on the page. If you select this option, the job files are created.

---

## Edit job files

Click **Open Editor** to open an editor to edit the Slurm job submission script (default name `main_job.sh`).

Click on a file name under 'Folder contents' to open an editor to edit that file in the job context directory.

Click **Open Dir** or click **Edit Files** to open the [File Manager](../files.md) pointing at the job context directory.

Click **Open Terminal** (either button) to log into the back-end on which the currently selected job will be run. Once logged in, your current directory will be changed to match the job context directory.

### Troubleshooting: Edit job files 'cd ... No such file or directory'

If you see 'cd ... No such file or directory' error after you have logged into the back-end, then this means that the job context is not in your home directory in the back-end. This can happen if you selected a back-end where your home directory is not common to both the Open OnDemand host and the back-end, and you have not yet submitted your job.

---

## Submit Slurm job

Click **Submit job** (green play icon) to submit your job.

![Submit Job button, a green play icon](../../../images/open-ondemand/job-composer-play-button.png){: class="border-img center"} ***Submit Job** button*

---

## Browse and manage jobs

### Jobs table

The job ID is a unique job ID created by the Slurm job scheduler, when you submitted the job.

The job status can be one of: 'Not Submitted', 'Queued', 'Running', 'Hold', 'Suspend', 'Completed', 'Undetermined'.

!!! Note

    The job status does not display whether a job that is 'Completed' did so with success or failure. Whether a job
succeeded or failed can be seen in the job details for the job which can be seen via the [Active Jobs](./active-jobs.md) app.

### Open File Manager to job context directory

Click **Open Dir** or click **Edit Files** to open the [File Manager](../files.md) pointing at the job context directory for the currently selected job.

!!! Info

    When using a back-end where your home directory is not common to both the Open OnDemand host and the back-end, then, if your job creates files on the back-end, you will have to log into the back-end to view your files - see [Log into back-ends](./ssh.md).

### Log into to back-end

Click **Open Terminal** (either button) to log into the back-end on which the currently selected job will be run, is running or was run. Once logged in, your current directory will be changed to match the job context directory.

#### Troubleshooting: Log into back-end 'cd ... No such file or directory'

If you see 'cd ... No such file or directory' error after you have logged into the back-end, then this means that the job context is not in your home directory in the back-end. This can happen if you selected a back-end where your home directory is not common to both the Open OnDemand host and the back-end, and you have not yet submitted your job.

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

If you selected a back-end where your home directory is common to both the Open OnDemand host and the back-end, then:

1. Click `res.txt` under 'Folder Contents:`
1. A new browser tab will appear with the contents of the file:

    ```text
    Created output file with 'Hello World'
    ```

1. Close the tab.
1. Switch to the Job Composer browser tab.
1. Click `output_file` under 'Folder Contents:`
1. A new browser tab will appear with the contents of the file. For example:

    ```text
    Hello World to someuser from some-host.nsh.loc
    ```

* Close the tab.

If you selected a back-end where your home directory is not common to both the Open OnDemand host and the back-end, then:

1. Click **Open Terminal** to log into the back-end on which the job was run. Once logged in, your current directory will be changed to match the job context directory.
1. View the job context directory:

    ```bash
    $ pwd
    /home/someuser/ondemand/data/sys/myjobs/projects/default/1
    $ ls -1
    main_job.sh
    output_file
    res.txt
    ```

1. View `res.txt`:

    ```bash
    $ cat res.txt
    Created output file with 'Hello World'
    ```

1. View `output_file`:

    ```bash
    $ cat output_file
    Hello World to someuser from some-host.nsh.loc
    ```
