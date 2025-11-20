# Run RStudio Server Container

Run RStudio Server Container is an app that runs RStudio Server on a back-end within your safe haven. RStudio Server is run as a container, using Podman.

---

## Run app

Complete the following information the app form:

* **Cluster**: A back-end (cluster) within your safe haven on which to run RStudio Server. Back-end-specific short-names are used in the drop-down list (see [Back-end (cluster) names](../jobs.md#back-end-cluster-names) for more information). If there is only one back-end available to you then this form field won't be shown.

    !!! Note

        **National Safe Haven users**: If using a 'desktop' back-end, then you must select the 'desktop' you have been granted access to.

* **RStudio Server password**: A password is required to secure RStudio Server. Provide a password to use.
* **CPUs/cores**: CPUs/cores requested for the app's job. Your chosen back-end must have the requested number of cores/CPUs available.
* **Memory (GiB)**: Memory requested for the app's job. Your chosen back-end must have the requested memory available.

Click **Launch**.

Open OnDemand will create job files for the app in a job-specific job context directory in an app-specific directory under your `ondemand` directory and then submits the job for the app to the job scheduler.

Open OnDemand will show an app job card with information about the app's job including:

* Job status (on the top right of the job card): initially 'Queued'.
* 'Created at': The time the job was submitted.
* 'Time Requested': The runtime requested for the job.
* 'Session ID': An auto-generated value which is used as the name of the job-specific job context directory.
* App-specific information, which includes values from the app form:
    * 'Connection timeout (s)': when the app's job starts running, the app will then wait for RStudio Server to become available. If this does not occur within this app-specific period, then the app's job will cancel itself.
    * 'CPUs/cores': The value you selected on the app form.
    * 'Memory (GiB)' The value you selected on the app form.

When the job starts, the Job status on the job card will update to 'Starting' and 'Time Requested' will switch to 'Time Remaining', the time your job has left to run before it is cancelled by the job scheduler.

When the Job status updates to 'Running', a **Host** link will appear on the job card, which allows you to log in to the back-end on which the job, and so RStudio Server, is now running.

A **Connect to RStudio Server** button will appear. RStudio Server is now ready for use.

A 'RStudio Server is running in Podman container epcc-ces-rstudio-SESSION_ID' message will also appear.

Click **Connect to RStudio Server**. A new browser tab will open with RStudio Server.

!!! Warning

    Open OnDemand will wait 180 seconds (3 minutes) for RStudio Server to start. If it does not start within this time the job will be cancelled.

!!! Warning

    RStudio Server will run for a maximum of 6 hours, after which it will be cancelled.

!!! Warning

    Any running jobs are cancelled during the monthly TRE maintenance period.

!!! Note

    Within the job scheduler, and the [Active Jobs](./active-jobs.md) app, this app's jobs are named 'rstudio_app'.

---

## Log in to RStudio Server

A Sign in to RStudio page will appear. Enter:

* **Username**: root
* **Password**: password you selected when completing the app form.

Click **Sign in**.

!!! Note

    You are the 'root' user **only** within the context of the RStudio Server container. You will not have 'root' access to the back-end on which the container is running! Any files you create in the directories mounted into the container will be owned by your own user, and user group, on the back-end.

---

## Sharing files between the back-end and RStudio Server and persisting state between app runs

The app mounts three directories from the back-end into RStudio Server at `/safe_data`, `/safe_outputs` and `.scratch` . For information on what these directories can be used for, see [Sharing files between a back-end and a container](../containers.md#sharing-files-between-a-back-end-and-a-container).

The app also creates a `$HOME/.local/share/ondemand/apps/rstudio_app/` in your home directory on the back-end and nounts this into RStudio Server at `/mnt/rstudio_host`. If you install R packages into `/mnt/rstudio_host` when using RStudio Server, then these will be available to you when you run the app in future (each run of the app creates a new container, and this mount allows for state to be persisted between runs).

---

## Installing R packages

RStudio Server is configured with your web proxy environment variables so you can install packages from CRAN when using RStudio Server. It is recommended that you install R packages into `/mnt/rstudio_host` so that you can reuse these the next time you run the app on the same back-end.

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

RStudio Server will continue to run even if you do the following:

* Log out of RStudio Server via the **File** menu, **Sign Out** option.
* Log out of RStudio Server via the **File** menu, **Quit Session...** option.
* Close the browser tab.
* Log out of Open OnDemand.
* Log out of the VM from which you accessed Open OnDemand.

You can re-access your running RStudio Server via the **Connect to RStudio Server** on your session's [job card](../jobs.md#job-cards) on the [My Interactive Sessions](../jobs.md#my-interactive-sessions-page) page accessed via **My Interactive Sessions** (overlaid squares icon) on the menu bar.

![My Interactive Sessions menu button, an overlaid squares icon](../../../images/open-ondemand/my-interactive-sessions-button.png){: class="border-img center"} ***My Interactive Sessions** menu button*

---

## End your job

You can end your job as follows:

* Cancel or delete the job via Open OnDemand. See [Browse and manage jobs](../jobs.md#browse-and-manage-jobs).
