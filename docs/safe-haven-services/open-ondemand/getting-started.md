# Getting started

Open OnDemand allows you to run compute and data-related tasks on compute resources available within your safe haven. Here, we introduce using Open OnDemand to run containers via the TRE Container Execution Service on compute resources available to your safe haven.

First, some Open OnDemand terminology. A compute resource upon which tasks can be run is called a **back-end** (or, in some areas of Open OnDemand, a **cluster**). Each run of a task on a back-end is called a **job**. Open OnDemand components that allow you to run jobs, or other useful functions, are called **apps**.

Within the TRE Open OnDemand service, apps are provided to run containers on back-ends. This walkthrough is centred around three apps:

* [Run Container](apps/container-app.md) allows you to run a batch container on a back-end. By **batch container** we mean those containers that perform some computational or data-related task without human interaction when they are running.
* [Run JupyterLab](apps/jupyter-app.md) allows you to run a JupyterLab container on a back-end, which creates an interactive JupyterLab service that you can use. Please be reassured that no Python knowledge is assumed or required!
* [Active Jobs](apps/active-jobs.md) allows you to see which of your jobs have been submitted, are running, or have completed.

---

## Where Open OnDemand stores your information - your `ondemand` directory

Within your home directory on the Open OnDemand VM, Open OnDemand creates an `ondemand` directory. This is where Open OnDemand stores information about your current session and previous sessions.

Every time a job is created by an app, Open OnDemand creates the job files the app needs for it to run, and log files when it is running, within a job-specific **job context directory** in an app-specific directory.

For most back-ends, your home directory is common to both the Open OnDemand VM and the back-ends so your directories and files on the Open OnDemand VM, and changes to these, are reflected on the back-ends and vice-versa.

However, you may have access to back-ends where your home directory is not common to both the Open OnDemand VM and the back-end i.e., you have unsynchronised, separate, home directories on each VM. To use such back-ends, you need to do some set up to allow Open OnDemand to automatically copy your `ondemand` directory, and so your job files, to the back-end when you submit a job.

For the back-ends used by this walkthrough this **only** needs to be done by users of the **DataLoch safe haven**. Users of **other safe havens** can **skip to the next section**, [Run the 'Run Container' app](#run-the-run-container-app) below.

To use a DataLoch VM to run Open OnDemand apps, please follow the instructions in [Enable copy of `ondemand` directory to a back-end](jobs.md#enable-automated-copy-of-ondemand-directory-to-a-back-end) to enable this for the 'desktop' VM on which you are running the browser in which you are using Open OnDemand, then return to this page.

---

## Run the 'Run Container' app

[Run Container](apps/container-app.md) allows you to run a batch container on a back-end. By **batch container** we mean those containers that perform some computational or data-related task without human interaction when they are running.

Click the 'Run Container' app on the Open OnDemand home page.

The 'Run Container' app form will open.

### Review and complete the 'Run Container' app form

The app form is prepopulated with the configuration to pull and run a 'hello TRE' container, `ghcr.io/mikej888/hello-tre:1.0`. When run, the container logs a greeting and information about folders mounted into the container.

Read the form entries in conjunction with the explanations below and make the suggested changes:

* **Cluster** selects a back-end (cluster) within your safe haven on which to run the container. Back-end-specific short-names are used in the drop-down list and safe haven-specific back-ends include the text 'tenant', to distinguish them from TRE-level back-ends to which you might have access.
    * Select the 'desktop' VM on which you are running the browser in which you are using Open OnDemand.
* **Container/image URL in container registry** cites a URL specifying both the container to run and the container registry from which it is to be pulled.
    * Leave this value as-is to use the `hello-tre` container.
* **Container registry username** is a username to access the container registry.
    * Leave this value as-is.
* **Container registry password/access token** is an access token with read-only access to the container registry.
    * Leave this value as-is, the access token provides read-only access to pull the container.
* **Container runner** is the container runner with which to run container on the back-end.
    * Leave this value as-is i.e., 'podman', as this is available on all back-ends.
* **Container name** is the name to be given to the container when it is run. If omitted, then the container image name is used e.g., `hello-tre`. Your user name and a timestamp will be added as a prefix to the name when the container is run e.g., `laurie-060416105069-hello-tre`.
    * Leave this value as-is.
* **Cores** is the number of cores/CPUs requested for this job. To run jobs via Open OnDemand requires you to select the resources you think your job will need, including the number of cores/CPUs. Your selected back-end (cluster) must have the selected number of cores/CPUs available.
    * Leave this value as-is as the all back-ends can provide the default number of cores, and the `hello-tre` container does not need any more.
* **Memory in GiB** is the memory requested for this job. Your selected back-end (cluster) must have the selected memory available.
    * Leave this value as-is as the all back-ends can provide the default memory, and the `hello-tre` container does not need any more.
* **Use GPU?** requests that the container use a GPU. If selected, then the selected back-end must have GPUs available.
    * Leave this value as-is, as the `hello-tre` container does not require a GPU.
* **Command-line options to pass to container runner** are Podman- or Apptainer-specific options to control the container runner's behaviour.
    * Leave this value as-is, as the container does not require any such options to be set.
* **Environment variables to pass to container** are environment variables to be passed on by the container runner and set within the container when it runs. The `hello-tre` container looks for a `HELLO_TRE` environment variable. If set, then the container will print the variable's value as a greeting. If undefined, then the greeting is `Hello`.
    * Enter:

        ```text
        HELLO_TRE=Hello there
        ```

* **Arguments to pass to container** are container-specific arguments to be passed directly to the container when it runs. The `hello-tre` container supports two container-specific arguments:
    * A `-d|--duration INTEGER` argument which causes the container to sleep (pause) for that number of seconds. If undefined, then the container does not sleep.
    * A `-n|--name STRING` argument which causes the container to print a greeting with that name. If undefined, then the name is `user`.
    * Enter the following to request a sleep of 10 seconds and a greeting with your name:

        ```text
        -d 10
        -n PUT_YOUR_FIRST_NAME_HERE
        ```

### Launch the 'Run Container' app job

Click **Launch**.

Open OnDemand will create job files for the app's job in a job-specific job context directory in an app-specific directory under your `ondemand` directory.

Open OnDemand will show an app **job card** with information about the app's job including:

* Job status (on the top right of the job card): initially 'Queued'.
* **Created at**: The time the job was submitted.
* **Time Requested**: The runtime requested for the job which defaultsa to 6 hours.
* **Session ID**: An auto-generated value which is used as the name of the job-specific job context directory.
* App-specific information, which includes values from the app form:
    * **Container/image URL in container registry**
    * **Container runner**
    * **Container name**
    * **Cores**
    * **Memory in GiB**

Open OnDemand submits the job for the app to a **job scheduler** which schedules the job onto the back-end based upon the resources - the number of CPUs/cores and amount of memory - requested for your job in the app form. Your job is then queued until sufficient resources are available on the selected back-end to run your job. This will depend upon:

* Resources available on your selected back-end.
* Extent to which jobs currently running on the back-end are using the back-end's resources.
* Resources requested by your job.
* Jobs from yourself and others already in the queue for the back-end.

When the job starts, the Job status on the job card will update to 'Starting' and **Time Requested** will switch to **Time Remaining**, the time your job has left to run before it is terminated by the job schedler.

When the Job status updates to 'Running', a **Host** value will appear on the job card. This is the back-end on which the job, and so the `hello-tre` container, is now running. A 'Please wait until your job has completed' message will also appear on the job card.

All going well, the container, and its job, should complete quickly.

The Job status on the job card will update to 'Completed'.

### View the container's output files

Open OnDemand uses TRE Container Execution Service tools to run containers and containers run via Open OnDemand **must** conform to the requirements of the Container Execution Service, and `hello-tre` does. For this walkthrough, the key points are that containers need to support three directories, so that when the container is run, three directories on the back-end can be mounted into the container:

| Back-end directory | Container directory | Description |
| ------------------ | ------------------- | ----------- |
| Project-specific `/safe_data/` subdirectory | `$HOME/safe_data/` OR `/safe_data/PROJECT_SUBDIRECTORY/`| If `$HOME/safe_data/` exists in your home directory on the back-end, then that is mounted. Otherwise, a subdirectory of `/safe_data/` corresponding to your project (and inferred from your user group) is mounted, if such a subdirectory can be found. |
| `$HOME/outputs-NUMBER` | `/safe_outputs/` | `NUMBER` is a randomly-generated number, for example `outputs-3320888`. This directory is created in your home directory on the back-end when your container runs. The directory persists after the job which created the container ends. |
| `$HOME/scratch-NUMBER` | `/scratch/` | `NUMBER` is the same as that created for `outputs-NUMBER`, for example `scratch-3320888`. This directory is also created in your home directory on the back-end when your container runs. This directory exists for the duration of the job which created the container and is then **deleted** when the job which created the container ends. |

Together, these mounts provides a means for data, configuration files, scripts and code to be shared between the back-end on which the container is running and the environment within the container itself. Creating or editing a file within any of these directories on the back-end means that the changes will be available within the container, and vice-versa.

When the `hello-tre` container is run, it writes two files into `/safe_outputs/` within the container, and so into a `$HOME/outputs-NUMBER` on your home directory on the back-end:

* `safe_data.txt`, which lists a selection of directories and files in the `/safe_data/PROJECT_SUBDIRECTORY` directory that was mounted into the container at `/safe_data/`.
* `safe_outputs.txt` which has a `This text is in safe_outputs.txt` message.

As mentioned earlier, for most back-ends, your home directory is common to both the Open OnDemand VM and the back-ends so any files created within your home directory on a back-end will also be available on the Open OnDemand VM. Open OnDemand provides a File Manager which allows you to browse files in your home directory on the Open OnDemand VM. This includes the contents of the `outputs-NUMBER` and `scratch-NUMBER` directories. However, your project data files, in a project-specific directory under `/safe_data/` are **not** available on the Open OnDemand VM.

For DataLoch users, your home directory is not common to both the Open OnDemand VM and the back-end, so you cannot use the File Manager to browse files created by the container. However, another way of viewing these files will be described shortly.

View the `outputs-NUMBER` directory via the Open OnDemand File Manager:

1. Select the **Files** menu, **Home Directory** option to open the File Manager.
1. Click **Home Directory**, to go to your home directory.
1. Click `outputs-NUMBER` view the directory
1. Click on `safe_data.txt` and `safe_outputs.txt` to view their contents.

An alternative to the File Manager is to log in to the back-end and view the files there, which can be done for any back-end.

View the `outputs-NUMBER` directory within the back-end:

1. Select **Clusters** menu, back-end **Shell Access** option, to log into the back-end.
1. Change into your home directory and view the directory and its files and their contents.

    ```bash
    cd
    ls outputs-NUMBER
    cat outputs-NUMBER/safe_data.txt
    cat outputs-NUMBER/safe_outputs.txt
    ```

As you have accessed Open OnDemand from your 'desktop' VM, you could access the files directly on your 'desktop' VM, however, we use the **Shell Access** approach to introduce this feature of Open OnDemand.

### View the app log file within the job context directory

When an app job runs, a log file is created within the job-specific job context directory in an app-specific directory under your `ondemand` directory. This log file includes information from the app itself plus logs captured from the container as it runs. For the `hello-tre` container, the logs includes information about the mounts and also a greeting and sleep (pause) information based on the environment variable and container arguments you defined in the app's form.

The log file has name, `container_app_output-RUNID.log`, where `RUNID` is a numerical identifier.

As for the output files, you can use either the File Manager (non-DataLoch safe haven users only) or log into the back-end (all users) to view the log file.

View the log file via the Open OnDemand File Manager:

1. Click the **Session ID** link in the job card to open the File Manager, pointing at the job context directory for the job on the Open OnDemand VM.
1. Click on the log file, `container_app_output-RUNID.log`.

View the log file within the back-end:

1. Select **Clusters** menu, back-end **Shell Access** option to log into the back-end.
1. Change into the job context directory for the job on the back-end and show the log file where `SESSION_ID` can be seen on the **Session ID** link on the job card:

    ```bash
    cd ondemand/data/sys/dashboard/batch_connect/sys/container_app/output/SESSION_ID/
    cat container_app_output-RUNID.log
    ```

For the `hello-tre` container, the log file includes four types of log information. There is information from the app itself and it sets itself up to run the container:

```text
Fri Jun 13 12:17:44 UTC 2025 before.sh: JOB_FOLDER: $HOME/ondemand/data/sys/dashboard/batch_connect/sys/container_app/output/SESSION_ID
...
Fri Jun 13 12:17:50 UTC 2025 script.sh: Running ces-run podman ...
Running: /usr/local/bin/ces-pm-run ...
```

This is followed by information from the container itself about your user name within the container and the directories mounted into the container:

```text
Hello TRE!

Your container is now running.

Your user 'id' within the container is: uid=0(root) gid=0(root) groups=0(root).

Check mounted directories, ownership, permissions, file system type:
/safe_data: nobody (65534) root(0) drwxrwx--- nfs
/scratch: root (0) root(0) drwxr-xr-x ext2/ext3
/safe_outputs: root (0) root(0) drwxr-xr-x ext2/ext3

Check read/write access to mounted directories

List /safe_data contents and write to /safe_outputs/safe_data_files.out
Check write to /safe_outputs
Contents of /safe_outputs/safe_outputs.txt:
This text is in safe_outputs.txt
Check write to /scratch
Contents of /scratch/scratch.txt:
This text is in scratch.txt

Look for optional 'HELLO_TRE' environment variable
Found optional 'HELLO_TRE' environment variable with value: Hello there

Parse command-line arguments
Number of arguments: 5
Arguments (one per line):
-d
30
-n
YOUR_FIRST_NAME
```

For some containers run via Podman, including `hello-tre`, you are the 'root' user within the container but **only** within the container. This is why the files in the mounts belong to a 'root' or 'nobody' user and 'root' group when accessed from **within** the container. Any files you create in the mounted directories will be owned by your own user, and user group, on the back-end. You can check this yourself by inspecting the file ownership of the files within `outputs-NUMBER` on the back-end.

Returning to the log file, there is information from the container itself about your user name within the container and the directories mounted into the container, including a message created using the value of the `HELLO_TRE` environment variable and the `-n` container argument and messages indicating that the container is sleeping for the duration specified by the `-d` container argument:

```text
Hello there YOUR_FIRST_NAME!

Sleeping for 30 seconds...
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
Goodbye YOUR_FIRST_NAME!
```

Finally, the log file includes information from the app itself as it completes:

```text
Cleaning up...
```

---

## Run the 'Active Jobs' app

[Active Jobs](apps/active-jobs.md) allows you to see which of your jobs have been submitted, are running, or have completed.

Click the 'Active Jobs' app on the Open OnDemand home page.

The 'Active Jobs' app will open to show a table of running and recently completed jobs.

You will see a 'container_app' entry for your app's job.

Your job will have a status of 'Completed'.

Each job has a unique **job ID** created by the job scheduler when you submitted the job.

Unfortunately, the job ID is not the same as the session ID created by Open OnDemand for an app. Ratther, the job ID is created by the job scheduler.

To see more details about the job, click the **>** button, by the job.

If any app does not run promptly, but is in a 'Queued' state then the 'Active Jobs' app can provide you with information on other jobs that are running and for which you may have to wait until one or more have completed before your app's job runs.

---

## Run the 'Run JupyterLab' app

[Run JupyterLab](apps/jupyter-app.md) allows you to run a JupyterLab container on a back-end, which creates an interactive JupyterLab service you can use. Please be reassured that no Python knowledge is assumed or required!

Click the 'Run JupyterLab' app on the Open OnDemand home page.

The 'Run JupyterLab' app form will open.

This app's form has far less settings since it is designed to run, using Podman, a JupyterLab container created for use with the TRE Container Execution Service.

For **Cluster**, select the 'desktop' VM on which you are running the browser in which you are using Open OnDemand.

Leave the other settings as-is.

### Launch the 'Run JupyterLab' app job

Click **Launch**.

Again, Open OnDemand will create job files for the app in a job-specific job context directory in an app-specific directory under your `ondemand` directory.

Again, Open OnDemand will show an app **job card** with information about the app's job including:

* Job status (on the top right of the job card): initially 'Queued'.
* Created at: The time the job was submitted.
* Time Requested: The runtime requested for the job which defaultsa to 6 hours.
* Session ID: An auto-generated value which is used as the name of the job-specific job context directory.
* App-specific information, which includes values from the app form:
    * Container name:
    * Connection timeout: when the app's job starts running, the app's job will wait for this duration (1200 seconds i.e., 20 minutes) for the JupyterLab server to become available. If this does not occur, then the app will terminate itself.
    * Cores
    * Memory in GiB

Again, the app's job is sumbitted to the job scheduler  and, when the job starts, the Job status on the job card will update to 'Starting' and **Time Requested** will switch to **Time Remaining**, the time your job has left to run before it is terminated by the job schedler.

When the Job status updates to 'Running', the **Host** will appear on the job card, the back-end on which the job, and so the JupyterLab container, is now running. A **Connect to JupyterLab** button will also appear on the job card. The JupyterLab container is now ready for use!

Click **Connect to JupyterLab**. A new browser tab will open with the JupyterLab service.

You may wonder why you were not prompted for a username and password. The JupyterLab service running in the container runs as a 'root' user. Again, the 'root' user is within the context of the container only. The service is protected with an auto-generated password. The button is configured to automatically log you into the container using this password.

#### Troubleshooting: Proxy Error

If you click **Connect to JupyterLab** and get:

> Proxy Error
>
> The proxy server received an invalid response from an upstream server.
> The proxy server could not handle the request
>
> Reason: Error reading from remote server
>
> Apache/2.4.52 (Ubuntu) Server at host Port 443

then, this can arise as sometimes there is a lag between the container having started and JupyterLab within the container being ready for connections.

Wait 30 seconds, then refresh the web page, or click the **Connect to JupyterLab** button again.

### Use JupyterLab

TODO

'Terminal'

On a job's job card, click the **Session ID** link to open the [File Manager](files.md), pointing at the job context directory for the job on the Open OnDemand VM.

When using a back-end where your home directory is not common to both the Open OnDemand VM and the back-end, then, if your job creates files on the back-end, you will have to log into the back-end to view your files - see [Log into back-ends](ssh.md).

While the job is running, click the **Host** link to log into to back-end on which the job is running.

TODO Edit safe_outputs/scratch files via Terminal within JupyterLab, see effect via File Manager/SSH.

TODO Edit safe_outputs/scratch files via File Manager/SSH, see effect via Terminal within JupyterLab

If you have a number of `outputs-NUMBER` or `scratch-NUMBER` directories, then use 'Modified at' values in the [File Manager](files.md) or `ls -l` on the back-end to identify those corresponding to your most recent job.

### Revisit the 'Active Jobs' app

Click the 'Active Jobs' app on the Open OnDemand home page.

You will see a 'ood_jupyter_app' entry for your app's job.

TODO-double-check

Your job will have a status of 'Running'.

TODO-double-check

To see more details about the job, click the **>** button, by the job.

TODO-double-check

### Finish your 'Run JupyterLab' app job

You can end your job by as follows:

* Either, log out of JupyterLab via **File**, **Log Out**.
* Or, click **Cancel** on a job card.

The Job status on the job card will update to 'Completed'.

Click the 'Active Jobs' app on the Open OnDemand home page.

Your job will now have a status of 'Completed'.

TODO-double-check

---

## Use `$HOME/safe_data/`

As mentioned, if `$HOME/safe_data/` exists in your home directory on the back-end, then that is mounted into a container. Otherwise, a subdirectory of `/safe_data/` corresponding to your project (and inferred from your user group) is mounted, if such a subdirectory can be found. |

Using the File Manager, or via a session on the back-end accessed from within Open OnDemand, or on the 'desktop' VM from which you accessed Open OnDemand, create a `$HOME/safe_data/` directory and then create some files in it. For example:

```bash
mkdir $HOME/safe_data/
touch $HOME/safe_data/a.txt
touch $HOME/safe_data/b.txt
touch $HOME/safe_data/c.txt
ls -1 $HOME/safe_data
```

Rerun the 'Run Container' app. This time `outputs-NUMBER/safe_data.txt` should list the files you created:

```text
/safe_data: root (0) root(0) drwxr-xr-x
/safe_data/a.txt: root (0) root(0) -rw-r--r--
/safe_data/c.txt: root (0) root(0) -rw-r--r--
/safe_data/b.txt: root (0) root(0) -rw-r--r--
```

You could also use the 'Run JupyterLab' app and explore accessing files you create within `$HOME/safe_data/` from within `/safe_data/` within the JupyterLab container and vice versa.

Remember to delete `$HOME/safe_data/` when you are done.

---

## More information

The following pages provide detailed information about all aspects of Open OnDemand introduced in this walkthrough:

* [Run jobs](jobs.md)
* [Run containers](containers.md)
* [View and run apps](apps.md)
* [Browse and manage files](files.md)
* [Log into back-ends](ssh.md)
