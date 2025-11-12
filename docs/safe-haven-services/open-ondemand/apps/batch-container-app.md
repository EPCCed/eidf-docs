# Run Batch Container

Run Batch Container is an app that allows you to run a container on a back-end. The app is designed to run batch containers, those that perform some computational or data-related task without human interaction when they are running. The app is **not** designed for containers that spawn interactive services (for example, JupyterLab).

Containers run **must** conform to the [Container requirements](../containers.md#container-requirements) of the TRE Container Execution Service.

---

## Run a container

Complete the following information the app form:

* **Cluster**: A back-end (cluster) within your safe haven on which to run the container. Back-end-specific short-names are used in the drop-down list (see [Back-end (cluster) names](../jobs.md#back-end-cluster-names) for more information). If there is only one back-end available to you then this form field won't be shown.

    !!! Note

        **National Safe Haven users**: If using a 'desktop' back-end, then you must select the 'desktop' you have been granted access to.

* **Container/image URL in container registry**: URL specifying both the container to run and the container registry from which it is to be pulled. For example, `git.ecdf.ed.ac.uk/tre-container-execution-service/containers/epcc-ces-hello-tre:1.1`. See [Container registries](../containers.md#container-registries) for supported container registries.
* **Container registry username**: A container registry username is required.
* **Container registry access token**: An access token associated with the username is required. Using an access token that grants **read-only** access to the container registry is **strongly recommended**.
* **Container runner**: Container runner - 'podman' or 'apptainer' - with which to run the container. Your selected back-end must have the container runner installed.
* **Reuse Apptainer SIF file** (Apptainer only): When Apptainer is used, the container is pulled and an Apptainer SIF file created. The SIF file is created for the container every time. If this option is selected, then, if the SIF file can be found in your home directory, it will be reused, not recreated. SIF files are named after image names. For example, `epcc-ces-hello-tre:1.1.sif`.
* **Container name** (Podman only): Name to be given to the container when it is run. Your job will fail if there is already a running container with that name. If omitted, then the default container name is `CONTAINER_NAME-SESSION_ID`, where `CONTAINER_NAME` is derived from the image name (if the image name is `my-container:1.0` then `CONTAINER_NAME` is `my-container`) and `SESSION_ID` is a unique session identifier for the app's job.
* **CPUs/cores**: CPUs/cores requested for the app's job. Your chosen back-end must have the requested number of cores/CPUs available.
* **Memory (GiB)**: Memory requested for the app's job. Your chosen back-end must have the requested memory available.
* **Use GPU?**: Request that the container use a GPU. Your chosen back-end must have GPUs available.
* **Container runner command-line arguments**: Command-line arguments to pass to the chosen container runner to control its behaviour.
* **Environment variables**: Environment variables to be set within the container when it runs.
    * Each line should define one environment variable and value, each in the form, `ENVIRONMENT_VARIABLE=value`. For example:

        ```text
        HELLO_TRE=Greetings
        ```

    * If a value has spaces then, if using Apptainer, enclose the value in double-quotes. If using Podman, do not enclose the value in double-quotes.

* **Container-specific command-line arguments**: Container-specific command-line arguments to be passed to the container when it is run. For example:

    ```text
    -d 5
    -n batch-container-app-user
    ```

Click **Launch**.

Open OnDemand will create job files for the app in a job-specific job context directory in an app-specific directory under your `ondemand` directory and then submits the job for the app to the job scheduler.

Open OnDemand will show an app job card with information about the app's job including:

* Job status (on the top right of the job card): initially 'Queued'.
* 'Created at': The time the job was submitted.
* 'Time Requested': The runtime requested for the job.
* 'Session ID': An auto-generated value which is used as the name of the job-specific job context directory.
* App-specific information, which includes values from the app form:
    * 'Container/image URL in container registry': The value you selected on the app form.
    * 'Container runner': The value you selected on the app form.
    * 'CPUs/cores': The value you selected on the app form.
    * 'Memory (GiB)' The value you selected on the app form.

When the job starts, the Job status on the job card will update to 'Starting' and 'Time Requested' will switch to 'Time Remaining', the time your job has left to run before it is cancelled by the job scheduler.

When the Job status updates to 'Running', a **Host** link will appear on the job card. This is the back-end on which the job, and so the container, is now running. A message of form 'Container CONTAINER_NAME is now running. Please wait until the container completes.' will also appear on the job card.

!!! Warning

    Your job, and so your container. will run for a maximum of 6 hours, after which it will be cancelled.

!!! Warning

    Any running jobs, and containers, will be cancelled during the monthly TRE maintenance period.

!!! Note

    Within the job scheduler, and the [Active Jobs](./active-jobs.md) app, this app's jobs are named using the container/image name cited in the container/image URL e.g., 'epcc-ces-hello-tre:1.1'.

---

## Sharing files between the back-end and the container and persisting state between app runs

The app mounts three directories from the back-end into the container at `/safe_data`, `/safe_outputs` and `.scratch`. For information on what these directories can be used for, see [Sharing files between a back-end and a container](../containers.md#sharing-files-between-a-back-end-and-a-container).

If required, you can mount additional directories into your container:

* If using Apptainer, your container already has access to your home directory environment, so there is nothing that need be done. However, if you need to mount these at specific points in the container then this can be done by adding Apptainer-specific parameters into the **Command-line options to pass to container runner** field, one parameter per line. For example:

    ```text
    --bind ${HOME}/my_content:/mnt/my_content
    ```

* If using Podman, then this can be done by adding the Podman-specific syntax to mount the directories into the **Command-line options to pass to container runner** field, one parameter per line. For example:

    ```text
    -v ${HOME}/my_content:/mnt/my_content
    ```

!!! Note

    Any mounted directories must exist on the back-end on which the app runs.

---

## Accessing the TRE web proxy

If your container needs to access the TRE web proxy, then you need to pass your web proxy environment variables into the container. This can be done as follows:

1. Select **Clusters** menu, back-end **Shell Access** option to log into the back-end.
1. See the values of your web proxy variables:

    ```bash
    $ set | grep -in proxy
    CURLHTTPS_PROXY=...
    CURLHTTP_PROXY=...
    FTP_PROXY=...
    HTTPS_PROXY=...
    HTTP_PROXY=...
    https_proxy=...
    http_proxy=...
    NO_PROXY=...
    no_proxy=...
    ```

1. Paste the following variables and their values into the **Environment variables to pass to container**, one variable-value per line. For example:

    ```text
    CURLHTTPS_PROXY=...
    CURLHTTP_PROXY=...
    FTP_PROXY=...
    HTTPS_PROXY=...
    HTTP_PROXY=...
    https_proxy=...
    http_proxy=...
    NO_PROXY=...
    no_proxy=...
    ```

Alternatively:

1. Select **Clusters** menu, back-end **Shell Access** option to log into the back-end.
1. Extract your web proxy variables and values into a bash script and add an `export` to each to give a bash script which defines your variables:

    ```bash
    $ set | grep -i proxy= | sed 's/^/export '/ > set-proxy-env.sh
    $ cat set-proxy-env.sh
    export CURLHTTPS_PROXY=...
    export CURLHTTP_PROXY=...
    export FTP_PROXY=...
    export HTTPS_PROXY=...
    export HTTP_PROXY=...
    export https_proxy=...
    export http_proxy=...
    export NO_PROXY=...
    export no_proxy=...
    ```

1. Add this bash script to a directory that is mounted into your container.
1. `source` this bash script within your container.

---

## View job files

On a job's job card, click the **Session ID** link to open the [File Manager](../files.md), pointing at the job context directory for the job on the Open OnDemand VM.

!!! Note

    When using a back-end where your home directory is not common to both the Open OnDemand VM and the back-end, then, if your job creates files on the back-end, you will have to log into the back-end to view your files - see [Log into back-ends](../ssh.md).

---

## Log into back-end

While the job is running, click the **Host** link to log into to back-end on which the job is running.

If the job has completed, see [Log into back-ends](../ssh.md) for ways to log into the back-end.

---

## Take a break

Your container job will continue to run even if you do the following:

* Close the browser tab.
* Log out of Open OnDemand.
* Log out of the VM from which you accessed Open OnDemand.

---

## End your job

You can end your job by as follows:

* Cancel or delete the job via Open OnDemand. See [Browse and manage jobs](../jobs.md#browse-and-manage-jobs).
