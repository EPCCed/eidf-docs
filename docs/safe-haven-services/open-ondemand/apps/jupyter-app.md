# Run JupyterLab Container

Run JupyterLab Container is an app that runs a JupyterLab container on a back-end within your safe haven. The JupyterLab container was built for the TRE Open OnDemand service. The container is run using Podman.

---

## Run app

Complete the following information the app form:

* **Cluster**: A back-end (cluster) within your safe haven on which to run the container. Back-end-specific short-names are used in the drop-down list (see [Back-end (cluster) names](../jobs.md#back-end-cluster-names) for more information). If there is only one back-end available to you then this form field won't be shown.

    !!! Note

        **National Safe Haven users**: If using a 'desktop' back-end, then you must select the 'desktop' you have been granted access to.

* **Container name**: Name to be given to the container when it is run. Your job will fail if there is already a running container with that name. If omitted, then the default is `epcc-ces-jupyter-SESSION_ID`, where `SESSION_ID` is a unique session identifier for the app's job.
* **Cores**: Number of cores/CPUs requested for this job. Your selected back-end must have at least that number of cores/CPUs request.
* **Memory in GiB**: Memory requested for this job. Your selected back-end must have at least that amount of memory available.

Click **Launch**.

Open OnDemand will create job files for the app in a job-specific job context directory in an app-specific directory under your `ondemand` directory and then submits the job for the app to the job scheduler.

Open OnDemand will show an app job card with information about the app's job including:

* Job status (on the top right of the job card): initially 'Queued'.
* 'Created at': The time the job was submitted.
* 'Time Requested': The runtime requested for the job.
* 'Session ID': An auto-generated value which is used as the name of the job-specific job context directory.
* App-specific information, which includes values from the app form:
    * 'Connection timeout': when the app's job starts running, the app will then wait for JupyterLab to become available within the container. If this does not occur within this app-specific period, then the app's job will cancel itself.
    * 'Cores'
    * 'Memory in GiB'

When the job starts, the Job status on the job card will update to 'Starting' and 'Time Requested' will switch to 'Time Remaining', the time your job has left to run before it is cancelled by the job scheduler.

When the Job status updates to 'Running', a **Host** link will appear on the job card, which allows you to log in to the back-end on which the job, and so the JupyterLab container, is now running. A 'JupyterLab is running in Podman container CONTAINER_NAME' message will appear along with a **Connect to JupyterLab** button. The JupyterLab container is now ready for use.

Click **Connect to JupyterLab**. A new browser tab will open with JupyterLab.

!!! Warning

    Open OnDemand will wait 180 seconds (3 minutes) for your container to start. If it does not start within this time the job will be cancelled.

!!! Warning

    Your job, and so your container. will run for a maximum of 6 hours.

!!! Warning

    Any running jobs, and containers, will be cancelled during the monthly TRE maintenance period.

---

## Log in to JupyterLab

You will not be prompted for a username and password. JupyterLab running in the container runs as a 'root' user. JupyterLab is protected with an auto-generated password. The **Connect to JupyterLab** button is configured to log you into the container using this password automatically.

!!! Note

    You are the 'root' user **only** within the context of the container. You will not have 'root' access to the back-end on which the container is running! Any files you create in the directories mounted into the container will be owned by your own user, and user group, on the back-end.

---

## Sharing files between the back-end and the container and persisting state between app runs

The app mounts three directories from the back-end into the container at `/safe_data`, `/safe_outputs` and `.scratch` . For information on what these directories can be used for, see [Sharing files between a back-end and a container](../containers.md#sharing-files-between-a-back-end-and-a-container).

The app also creates a `$HOME/.local/share/ondemand/apps/jupyter_app/` in your home directory on the back-end and nounts this into the container at `/mnt/jupyter_host`. If you create virtual environments and/or install Python packages into `/mnt/jupyter_host` when using JupyterLab, then these will be available to you when you run the app in future (each run of the app creates a new container, and this mount allows for state to be persisted between runs).

---

## Installing Python packages

The container is configured with your web proxy environment variables so you can install packages from PyPI when using JupyterLab. It is recommended that you create virtual environments and/or install Python packages into `/mnt/jupyter_host` so that you can reuse these the next time you run your container.

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

* Log out of JupyterLab via the **File** menu, **Log Out** option.
* Close the browser tab.
* Log out of Open OnDemand.
* Log out of the VM from which you accessed Open OnDemand.

You can re-access your running container via the **Connect to JupyterLab** on your session's [job card](../jobs.md#job-cards) on the [My Interactive Sessions](../jobs.md#my-interactive-sessions-page) page accessed via **My Interactive Sessions** (overlaid squares icon) on the menu bar.

![My Interactive Sessions menu button, an overlaid squares icon](../../../images/open-ondemand/my-interactive-sessions-button.png){: class="border-img center"} ***My Interactive Sessions** menu button*

---

## End your job

You can end your job by as follows:

* Either, shut down JupyterLab via the **File** menu, **Shut Down** option.
* Or, cancel or delete the job via Open OnDemand. See [Browse and manage jobs](../jobs.md#browse-and-manage-jobs).
