# Run Batch Container

Run Batch Container is a Container Execution Service app that allows you to run a container on a back-end. The app is designed to run batch containers, those that perform some computational or data-related task without human interaction when they are running. The app is **not** designed for containers that spawn interactive services (for example, JupyterLab).

Containers run **must** conform to the [Container requirements](../containers.md#container-requirements) of the TRE Container Execution Service.

---

## Run a container

Complete the following information the app form:

* **Cluster**: A back-end (cluster) within your safe haven on which to run the container. Back-end-specific short-names are used in the drop-down list (see [Back-end (cluster) names](../jobs.md#back-end-cluster-names) for more information). If there is only one back-end available to you then this form field won't be shown.

    !!! Note

        **National Safe Haven users**: If using a 'desktop' back-end, then you must select the 'desktop' you have been granted access to.

* **Container/image URL in container registry**: URL specifying both the container to run and the container registry from which it is to be pulled. For example, `git.ecdf.ed.ac.uk/tre-container-execution-service/containers/epcc-ces-hello-tre:1.1`. See [Container registries](../containers.md#container-registries) for supported container registries.
* **Container registry username**: Username to access the container registry.
* **Container registry access token**: Access token to access to the container registry. An access token granting **read-only** access to the container registry is **strongly recommended**.
* **Container runner**: Container runner - 'podman' or 'apptainer' - with which to run container on the back-end. The selected runner must be available on the selected back-end.
* **Container name** (Podman only): Name to be given to the container when it is run. Your job will fail if there is already a running container with that name. If omitted, then the default is `CONTAINER_NAME-SESSION_ID`, where `CONTAINER_NAME` is derived from the image name (if the image name is `my-container:1.0` then `CONTAINER_NAME` is `my-container`) and `SESSION_ID` is a unique session identifier for the app's job.
* **Cores**: Number of cores/CPUs requested for this job. Your selected back-end must have at least that number of cores/CPUs request.
* **Memory in GiB**: Memory requested for this job. Your selected back-end must have at least that amount of memory available.
* **Use GPU?**: Request that the container use a GPU. If selected, then your selected back-end must have a GPU.
* **Command-line options to pass to container runner** are container runner-specific options to control the container runner's behaviour.
* **Environment variables to pass to container**: Environment variables to be passed on by the container runner and set within the container when it runs. Each line should define one environment variable and value, each in the form, `ENVIRONMENT_VARIABLE=value`. For example:

    ```text
    HELLO_TRE=Greetings
    ```

    * If a value has spaces then, if using Apptainer, enclose the value in double-quotes. If using Podman, do not enclose the value in double-quotes.

* **Arguments to pass to container**: Container-specific arguments to be passed directly to the container when it runs. For example:

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
    * 'Container/image URL in container registry'
    * 'Container runner'
    * 'Cores'
    * 'Memory in GiB'

When the job starts, the Job status on the job card will update to 'Starting' and 'Time Requested' will switch to 'Time Remaining', the time your job has left to run before it is cancelled by the job scheduler.

When the Job status updates to 'Running', a **Host** link will appear on the job card. This is the back-end on which the job, and so the container, is now running. A message of form 'Container CONTAINER_NAME is now running. Please wait until the container completes.' will also appear on the job card.

!!! Warning

    Your job, and so your container. will run for a maximum of 6 hours, after which it will be cancelled.

!!! Warning

    Any running jobs, and containers, will be cancelled during the monthly TRE maintenance period.

---

## Sharing files between the back-end and the container

See [Sharing files between a back-end and a container](../containers.md#sharing-files-between-a-back-end-and-a-container)

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
