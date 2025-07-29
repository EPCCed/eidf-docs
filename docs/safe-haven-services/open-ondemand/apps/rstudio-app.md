# Run RStudio Server

Run RStudio Server is a Container Execution Service app that allows you to run an RStudio Server container on a back-end within your safe haven.

The container is run using Podman.

---

## Run RStudio Server container

Complete the following information the app form:

* **Cluster**: A back-end (cluster) within your safe haven on which to run the container. Back-end-specific  short-names are used in the drop-down list, and safe haven-specific back-ends include the text 'tenant', to distinguish them from any TRE-level back-ends to which you might have access (see [Back-end (cluster) names](../jobs.md#back-end-cluster-names) for more information).

    !!! Note

        **National Safe Haven users**: If using a 'desktop' back-end, then you must select the 'desktop' you have been granted access to.

* **Container name**: Name to be given to the container when it is run. If omitted, then the container image name is used e.g., `epcc-ces-rstudio`. Your user name and a timestamp will be added as a prefix to the name when the container is run to the name to prevent name clashes if running multiple containers from the same image e.g., `laurie-060416105069-epcc-ces-rstudio`.
* **RStudio Server password**: RStudio Server running in the container needs to be password-protected. Specify the password to use.
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
    * 'Container name'
    * 'Connection timeout': when the app's job starts running, the app will then wait for RStudio Server service to become available within the container. If this does not occur within this app-specific period, then the app's job will cancel itself.
    * 'Cores'
    * 'Memory in GiB'

When the job starts, the Job status on the job card will update to 'Starting' and 'Time Requested' will switch to 'Time Remaining', the time your job has left to run before it is cancelled by the job scheduler.

When the Job status updates to 'Running', a **Host** link will appear on the job card, which is the back-end on which the job, and so the RStudio Server container, is now running. A **Connect to RStudio Server** button will also appear on the job card. The RStudio Server container is now ready for use.

Click **Connect to RStudio Server**. A new browser tab will open with the RStudio Server service.

!!! Warning

    Open OnDemand will wait 1200 seconds (20 minutes) for your container to start. If it does not start within this time the job will be cancelled.

!!! Warning

    Your job, and so your container. will run for a maximum of 6 hours.

!!! Warning

    Any running jobs, and containers, will be cancelled during the monthly TRE maintenance period.

### Troubleshooting: Proxy Error

If you click **Connect to RStudio Server** and get:

> Proxy Error
>
> The proxy server received an invalid response from an upstream server.
> The proxy server could not handle the request
>
> Reason: Error reading from remote server
>
> Apache/2.4.52 (Ubuntu) Server at host Port 443

then, this can arise as sometimes there is a lag between the container having started and RStudio Server within the container being ready for connections.

Wait 30 seconds, then refresh the web page, or click the **Connect to RStudio Server** button again.

---

## Log in to RStudio Server

A Sign in to RStudio page will appear. Enter:

* **Username**: root
* **Password**: password you selected when completing the app form.

Click **Sign in**.

!!! Note

    You are the 'root' user **only** within the context of the container. You will not have 'root' access to the back-end on which the container is running! Any files you create in the directories mounted into the container will be owned by your own user, and user group, on the back-end.

---

## Sharing files between a back-end and the container

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

* Log out of RStudio Server via the **File** menu, **Sign Out** option.
* Log out of RStudio Server via the **File** menu, **Quit Session...** option.
* Close the browser tab.
* Log out of Open OnDemand.
* Log out of the VM from which you accessed Open OnDemand.

You can re-access your running container via the **Connect to RStudio Server** on your session's [job card](../jobs.md#job-cards) on the [My Interactive Sessions](../jobs.md#my-interactive-sessions-page) page accessed via **My Interactive Sessions** (overlaid squares icon) on the menu bar.

![My Interactive Sessions menu button, an overlaid squares icon](../../../images/open-ondemand/my-interactive-sessions-button.png){: class="border-img center"} ***My Interactive Sessions** menu button*

---

## End your job

You can end your job as follows:

* Cancel or delete the job via Open OnDemand. See [Browse and manage jobs](../jobs.md#browse-and-manage-jobs).
