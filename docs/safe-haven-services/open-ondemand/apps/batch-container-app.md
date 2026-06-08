# Run Batch Container

Run Batch Container is an app that allows you to run a container on a back-end. The app is designed to run batch containers, those that perform some computational or data-related task without human interaction when they are running. The app is **not** designed for containers that spawn interactive services (for example, JupyterLab).

Containers run **must** conform to the [Container requirements](../containers.md#container-requirements) of the Safe Haven Services Container Execution Service.

---

## Run a container

Complete the following information the app form:

* **Cluster**: A back-end (cluster) within your safe haven on which to run the container. Back-end-specific short-names are used in the drop-down list (see [Back-end (cluster) names](../jobs.md#back-end-cluster-names) for more information). If there is only one back-end available to you then this form field won't be shown.

    !!! Note

        **National Safe Haven users**: If using a 'desktop' back-end, then you must select the 'desktop' you have been granted access to.

* **Container/image URL in container registry**: URL specifying both the container to run and the container registry from which it is to be pulled. For example, `git.ecdf.ed.ac.uk/tre-container-execution-service/containers/epcc-ces-hello:1.0`. See [Container registries](#container-registries) below for supported container registries.
* **Container registry username**: A container registry username is required.
* **Container registry access token**: An access token associated with the username is required. Using an access token that grants **read-only** access to the container registry is **strongly recommended**.
* **Container runner**: Container runner - 'podman' or 'apptainer' - with which to run the container.
* **Reuse Apptainer SIF file** (Apptainer only): When Apptainer is used, the container is pulled and an Apptainer SIF file created. The SIF file is created for the container every time. If this option is selected, then, if the SIF file can be found in your home directory, it will be reused, not recreated. SIF files are named after image names. For example, `epcc-ces-hello:1.0.sif`.
* **Container name** (Podman only): Name to be given to the container when it is run. Your job will fail if there is already a running container with that name. If omitted, then the default container name is `CONTAINER_NAME-SESSION_ID`, where `CONTAINER_NAME` is derived from the image name (if the image name is `my-container:1.0` then `CONTAINER_NAME` is `my-container`) and `SESSION_ID` is a unique session identifier for the app's job.
* **CPUs/cores**: CPUs/cores requested for the app's job.
* **Memory (GiB)**: Memory requested for the app's job.
* **Use GPU?**: Request that the container use a GPU. This option is only shown for back-ends that have a GPU.
* **Container runner command-line arguments**: Command-line arguments to pass to the chosen container runner to control its behaviour.
* **Environment variables**: Environment variables to be set within the container when it runs.
    * Each line should define one environment variable and value, each in the form, `ENVIRONMENT_VARIABLE=value`. For example:

        ```text
        GREETINGS=Greetings
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

    Your job will run for a maximum of 6 hours, after which it will be cancelled.

!!! Warning

    Any running jobs are cancelled during the monthly Safe Haven Services maintenance period.

---

## Container registries

The container registries supported by the Safe Haven Services Container Execution Service, and so supported by this app, are as follows:

| Container Registry | URL prefix | Example  |
| ------------------ | ---------- | ------- |
| GitHub    | `ghcr.io` | `ghcr.io/epcc/epcc-ces-hello:1.0` |
| University of Edinburgh ECDF GitLab | `git.ecdf.ed.ac.uk` | `git.ecdf.ed.ac.uk/tre-container-execution-service/containers/epcc-ces-hello:1.0` |

!!! Note

    For ECDF GitLab, do not put the port number, 5050, into the URL. The Safe Haven Services Container Execution Service tools will automatically insert this into ECDF GitLab URLs.

---

## Sharing files between the back-end and the container and persisting state between app runs

When the app runs, your 'safe data' directory will be mounted into the container at the path `/safe_data`. Your 'safe data' directory is inferred as follows:

* Your 'safe data' directory is chosen to be the first `/safe_data/PROJECT_DIRECTORY` subdirectory found where `PROJECT_DIRECTORY` shares its name with one of the your user groups. For example, if you are a member of a user group `1234-5678` and there is a `/safe_data/1234-5678` directory, then that is your 'safe data' directory that is mounted at `/safe_data` within JupyterLab.
* However, if there is a `safe_data` directory in the your home directory (i.e., `$HOME/safe_data`) on the
back-end, then that is chosen in preference to any `/safe_data/PROJECT_DIRECTORY` as your 'safe data' directory that is available at `/safe_data` within JupyterLab.

You can mount additional existing directories or files within the container via the **Container runner command-line arguments** field in the form by using Apptainer or Podman-specific command-line arguments to mount the directories or files. An example, mounting `${HOME}/my_content` into as container at `/mnt/my_content`, is as follows:

* Apptainer,

    ```text
    --bind ${HOME}/my_content:/mnt/my_content
    ```

* Podman,

    ```text
    -v ${HOME}/my_content:/mnt/my_content
    ```

For more information see:

* Apptainer, [apptainer run](https://apptainer.org/docs/user/main/cli/apptainer_run.html) (`-B|--bind` and `--mount` options) and [Bind Paths and Mounts](https://apptainer.org/docs/user/main/bind_paths_and_mounts.html).
* Podman, [podman run](https://docs.podman.io/en/latest/markdown/podman-run.1.html) (`--volume|-v` and `--mount` options).

Any files you create within `/safe_data` or other mounted directories within the container will be available in `/safe_data/PROJECT_DIRECTORY` (or `$HOME/safe_data`) and the other mounted directories on the back-end, and vice-versa.

!!! Warning

    Any files created outside of `/safe_data` or other mounted directories are **deleted** when the app stops.

!!! WArning

    Your project data files, in a project-specific directory under `/safe_data` are **not** available on back-ends outwith your safe haven (e.g., the Superdome Flex). For these, you will need to stage your data to the back-end following your project- and safe haven-specific processes for the use of such services outwith your safe haven.

### Troubleshooting: Errors in inferring or accessing 'safe data'

As described in [Job cards](jobs.md#job-cards), app job cards will only show such jobs as having 'Completed'. Whether a job succeeded or failed can be seen in the job details for the job which can be seen via the [Active Jobs](apps/active-jobs.md) app.

In cases where there are errors in inferring or accessing your 'safe data' directory, then the log file for the app's job, in the job context directory, `ondemand/data/sys/dashboard/batch_connect/sys/batch_container_app/output/SESSION_ID`, will include a message like one of the following:

```text
Mon Jun  8 12:55:44 UTC 2026 before.sh ERROR: Cannot find a project directory corresponding to any of the user's groups
```
```text
Mon Jun  8 12:55:44 UTC 2026 before.sh ERROR: Cannot read from /safe_data/1234-5678
```
```text
Mon Jun  8 12:55:44 UTC 2026 before.sh ERROR: Cannot write to /safe_data/1234-5678
```

If this problem occurs, then please contact your Research Coordinator (or equivalent).

---

## Accessing the web proxy

If your container needs to access the web proxy, then you need to pass your web proxy environment variables into the container. This can be done as follows:

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

Your container will continue to run even if you do the following:

* Close the browser tab.
* Log out of Open OnDemand.
* Log out of the VM from which you accessed Open OnDemand.

---

## App job name

Within the job scheduler, and the [Active Jobs](./active-jobs.md) app, this app's jobs are named using the container/image name cited in the container/image URL e.g., 'epcc-ces-hello:1.0'.

---

## End your job

You can end your job by as follows:

* Cancel or delete the job via Open OnDemand. See [Browse and manage jobs](../jobs.md#browse-and-manage-jobs).
