# Getting started with Open OnDemand

Open OnDemand allows you to run compute and data-related tasks on compute resources available within your safe haven. Here, we'll introduce you to the key features of, and information about, using the TRE Open OnDemand service to run containers via the TRE Container Execution Service on compute resources available to your safe haven.

First some Open OnDemand terminology. A compute resource upon which tasks can be run is called a **back-end** or **cluster**. Each run of a task on a back-end is called a **job**. Open OnDemand components that allow you to run jobs, or other useful functions, are called **apps**.

Within the TRE Open OnDemand service, apps are provided to run containers on back-ends. This walkthrough is centred around three apps:

* [Run Container](./apps/container-app.md) allows you to run a batch container on a back-end. By **batch container** we mean those that perform some computational or data-related task without human interaction.
* [Run JupyterLab](./apps/jupyter-app.md) allows you to run a JupyterLab container on a back-end, which creates an interactive JupyterLab service you can use. Please be reassured that no Python knowledge is assumed or required!
* [Active Jobs](./apps/active-jobs.md) allows you to see which of your jobs have been submitted, are running, or have completed.

---

## Your `ondemand` directory

Within your home directory on the Open OnDemand VM, Open OnDemand creates an `ondemand` directory. This is where Open OnDemand stores information about your current session and previous sessions.

Every time a job is created by an app, Open OnDemand creates the job files for the app in a job-specific **job context directory** in an app-specific directory.

### Set up file synchronisation

For most back-ends, your home directory is common to both the Open OnDemand VM and the back-ends so your directories and files on the Open OnDemand VM, and changes to these, are reflected on the back-ends and vice-versa.

However, you may have access to back-ends where your home directory is not common to both the Open OnDemand VM and the back-end i.e., you have unsynched, separate, home directories on each VM. To use such back-ends, you need to do some set up to allow Open OnDemand to automatically copy your `ondemand` directory, and so your job files, to the back-end when you submit a job.

For the back-ends used by this walkthrough this only needs to be done by users of the **DataLoch safe haven** only. Users of **other safe havens** can **skip to the next section**, [Run the 'Run Container' app](#run-the-run-container-app) below.

To use a Data Loch VM to run Open OnDemand apps, please follow the instructions in [Enable copy of `ondemand` directory to a back-end](./jobs.md#enable-automated-copy-of-ondemand-directory-to-a-back-end), then return to this page.

---

## Run the 'Run Container' app

Click the 'Run Container' app on the Open OnDemand portal.

The 'Run Container' app form will open.

TODO-munge-below

Complete the following information the app form:

* **Cluster**: The back-end (cluster) within your safe haven on which to run the container. Back-end short-names are used in the drop-down list and safe haven-specific back-ends include the text 'tenant' (see [Back-end (cluster) names](./jobs.md#back-end-cluster-names) for more information).

    !!! Note

        **National Safe Haven users**: If you want to use a 'desktop' back-end, then you must select the 'desktop' you have been granted access to.

* **Container/image URL in container registry**: For example, `ghcr.io/mikej888/hello-tre:1.0`. See [Container registries](./containers.md#container-registries) for supported container registries.
* **Container registry username**.
* **Container registry password/access token**: An access token with read-only access to the container registry is strongly recommended but a token with read-write access or a password can also be used.
* **Container runner**: Container execution tool with which to run container. The selected tool must be available on the selected back-end. Options are 'podman' or 'apptainer'.
* **Container name:** (Podman only) Name to be given to the container when it is run. If omitted, then the container image name is used. For example, if the container image name is `my-container:1.0` then the container name is `my-container`. Your user name and a timestamp will be added as a suffix to the name to prevent name clashes if running multiple containers from the same image. So, the container name will be `yourusername-timestamp-containername` e.g. `mel-060416105069-hello-tre`.
* **Cores (max 1152)**: Number of cores/CPUs requested for this job. Your selected back-end (cluster) must have the selected number of cores/CPUs available.
* **Memory in GiB (max 17830 GiB)**: Memory requested for this job. Your selected back-end (cluster) must have the selected memory available.
* **Use GPU?**: Request that the container use a GPU. If selected, then the selected back-end must have GPUs available.
* **Command-line options to pass to container runner**: Podman- or Apptainer-specific options to control the container runner's behaviour.
* **Environment variables to pass to container**: Environment variable passed on by the container runner and set within the container when it runs. Each line should define one environment variable and value, each in the form, `ENVIRONMENT_VARIABLE=value`. For example:

    ```text
    HELLO_TRE=Greetings
    ```

    * If a value has spaces then, if using Apptainer, enclose the value in double-quotes. If using Podman, do not enclose the value in double-quotes.

* **Arguments to pass to container**: Container-specific arguments to be passed directly to the container when it is run. For example:

    ````text
    -d 5
    -n container-app-user
    ````

Click **Launch**.

Open OnDemand will submit a job to your chosen back-end to create and run the container.

When the container has started a 'Please wait until your job has completed' message will appear.

See [Sharing files between a back-end and a container](./containers.md#sharing-files-between-a-back-end-and-a-container)

On a job's job card, click the **Session ID** link to open the [File Manager](./files.md), pointing at the job context directory for the job on the Open OnDemand VM.

!!! Info

    When using a back-end where your home directory is not common to both the Open OnDemand VM and the back-end, then, if your job creates files on the back-end, you will have to log into the back-end to view your files - see [Log into back-ends](./ssh.md).

While the job is running, click the **Host** link to log into to back-end on which the job is running.

If the job has completed, see [Log into back-ends](./ssh.md) for ways to log into the back-end.

The app form is prepopulated with a 'hello TRE' image, `ghcr.io/mikej888/hello-tre:1.0`, and its complementary read-only credentials. When run, the image's container logs a greeting and information about folders mounted into the container. The container's behaviour can be configured as follows:

* A `HELLO_TRE` environment variable will cause the container to print the variable's value as a greeting. For example, if `HELLO_TRE=Greetings` is set, then the greeting is `Greetings`. If `HELLO_TRE` is undefined, then the greeting is `Hello`.
* A `-d|--duration INTEGER` argument to the container will cause it to sleep for that number of seconds. For example, if `-d 10` is passed, then the container sleeps for 10 seconds. If `-d` is undefined, then the container does not sleep.
* A `-n|--name STRING` argument to the container will cause it to print a greeting with that name. For example, if `-n container-app-user` is passed, then `container-app-user` is used.  If undefined, then the name `user` is used.

Run the 'hello-tre' example:

1. Select a **Cluster**, back-end.
1. For **Environment variables to pass to container**, enter:

    ```text
    HELLO_TRE=Hello there
    ```

1. For **Arguments to pass to container**, enter:

    ```text
    -d 10
    -n YOUR_FIRST_NAME
    ```

1. Leave all other values as-is.
1. Click **Launch**.
1. The job card for the job should appear.
1. View the log file, `container_app_output-RUNID.log`, for the job (where `RUNID` is a numerical identifier):
    * If you selected a back-end where your home directory is common to both the Open OnDemand VM and the back-end, then:
        1. Click the **Session ID** link in the job card to open the [File Manager](./files.md), pointing at the job context directory for the job on the Open OnDemand VM.
        1. Click on the log file, `container_app_output-RUNID.log`.
    * If you selected a back-end where your home directory is not common to both the Open OnDemand VM and the back-end, then:
        1. Select **Clusters** menu, back-end **Shell Access** option to log into the back-end.
        1. Change into the job context directory for the job on the back-end and show the log file:

        ```bash
        cd ondemand/data/sys/dashboard/batch_connect/sys/container_app/output/SESSION_ID/
        cat container_app_output-RUNID.log
        ```

1. The log file includes:

    * Information about how the container is run:

    ```text
    Fri Jun 13 12:17:44 UTC 2025 before.sh: JOB_FOLDER: $HOME/ondemand/data/sys/dashboard/batch_connect/sys/container_app/output/SESSION_ID
    ...
    Fri Jun 13 12:17:50 UTC 2025 script.sh: Running ces-run podman ...
    Running: /usr/local/bin/ces-pm-run ...
    ```

    * Information from the container itself about your user name within the container and the directories mounted into the container (see [Sharing files between a back-end and a container](./containers.md#sharing-files-between-a-back-end-and-a-container):

    ```
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

    * A message created using the value of the `HELLO_TRE` environment variable and the `-n` container argument and messages indicating that the container is sleeping for the duration specified by the `-d` container argument:

    ```
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
    Cleaning up...
    ```

1. As described in [Sharing files between a back-end and a container](./containers.md#sharing-files-between-a-back-end-and-a-container), an `outputs-NUMBER` directory is created and mounted into the container at `/safe_outputs/`. When the 'hello-tre' container is run it writes two files into this directory:
    * `safe_data.txt`, with information on the directories and files in the `/safe_data/PROJECT_SUBDIRECTORY` directory mounted into the container at `/safe_data/`
    * `safe_outputs.txt`, with a 'This text is in safe_outputs.txt' message.
    * View the `outputs-NUMBER` directory:
        * If you selected a back-end where your home directory is common to both the Open OnDemand VM and the back-end, then:
            1. Click **Home Directory** in the [File Manager](./files.md), to go to your home directory.
            1. Click `outputs-NUMBER` to view the directory and its files.
        * If you selected a back-end where your home directory is not common to both the Open OnDemand VM and the back-end, then change into your home directory:

        ```bash
        cd
        ls outputs-NUMBER
        cat outputs-NUMBER/safe_data.txt
        cat outputs-NUMBER/safe_outputs.txt
        ```

Another thing you can try is to use the File Manager or the command-line to create a `$HOME/safe_data/` directory and then create some files in it. If you rerun the app, this time `outputs-NUMBER/safe_data.txt` will list the files you created. For example, assume `$HOME/safe_data/` was created as follows (with three empty files):

```bash
mkdir $HOME/safe_data/
touch $HOME/safe_data/a.txt
touch $HOME/safe_data/b.txt
touch $HOME/safe_data/c.txt
ls -1 $HOME/safe_data
```

`outputs-NUMBER/safe_data.txt` would have the contents:

```text
/safe_data: root (0) root(0) drwxr-xr-x
/safe_data/a.txt: root (0) root(0) -rw-r--r--
/safe_data/c.txt: root (0) root(0) -rw-r--r--
/safe_data/b.txt: root (0) root(0) -rw-r--r--
```

---

## Run the 'Run JupyterLab' app

Click the 'Run JupyterLab' app on the Open OnDemand portal.

The 'Run JupyterLab' app form will open.

TODO-munge-below

Complete the following information the app form:

* **Cluster**: The back-end (cluster) within your safe haven on which to run the container. Back-end short-names are used in the drop-down list and safe haven-specific back-ends include the text 'tenant' (see [Back-end (cluster) names](./jobs.md#back-end-cluster-names) for more information).

    !!! Note

        **National Safe Haven users**: If you want to use a 'desktop' back-end, then you must select the 'desktop' you have been granted access to.

* **Container name**: Name to be given to the container when it is run.
    * Your user name and a timestamp will be added as a prefix to the name to prevent name clashes if running multiple containers from the same image. For example, `user-052010544547-my-jupyter`.
    * If omitted, then the container image name is used. For example, `user-052010544552-epcc-ces-jupyter`.
* **Cores (max 28)**: Number of cores/CPUs requested for this job. Your selected back-end (cluster) must have the selected number of cores/CPUs available.
* **Memory in GiB (max 58 GiB)**: Memory requested for this job. Your selected back-end (cluster) must have the selected memory available.

Click **Launch**.

Open OnDemand will submit a job to your chosen back-end to create and run the container.

When the container has started a **Connect to JupyterLab** button will appear.

Click **Connect to JupyterLab**.

Unlike the 'Run Container app, this app does not allow you to choose the container runner. The container is run using Podman. Some Open OnDemand apps allow you to choose the container runner to use, others will choose this for you.

### Troubleshooting: Proxy Error

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

JupyterLab running in the container is password-protected. The password is auto-generated. The **Connect to JupyterLab** button is configured to log you into the container using this password automatically.

Within JupyterLab, you are the 'root' user and group.

!!! Note

    You are the 'root' user **only** within the context of the container. You will not have 'root' access to the back-end on which the container is running! Any files you create in the directories mounted into the container will be owned by your own user, and user group, on the back-end.

See [Sharing files between a back-end and a container](./containers.md#sharing-files-between-a-back-end-and-a-container)

On a job's job card, click the **Session ID** link to open the [File Manager](./files.md), pointing at the job context directory for the job on the Open OnDemand VM.

!!! Info

    When using a back-end where your home directory is not common to both the Open OnDemand VM and the back-end, then, if your job creates files on the back-end, you will have to log into the back-end to view your files - see [Log into back-ends](./ssh.md).

While the job is running, click the **Host** link to log into to back-end on which the job is running.

If the job has completed, see [Log into back-ends](./ssh.md) for ways to log into the back-end.

You can end your job by as follows:

* Either, log out of JupyterLab via **File**, **Log Out**.
* Or, cancel or delete the job via Open OnDemand. See [Browse and manage jobs](./jobs.md#browse-and-manage-jobs).

---

## More information

The following pages provide more detailed information about the aspects of Open OnDemand covered in this walkthrough:

* [Run jobs](./jobs.md)
* [Run containers](./containers.md)
* [View and run apps](./apps.md)
* [Browse and manage files](./files.md)
* [Log into back-ends](./ssh.md)
