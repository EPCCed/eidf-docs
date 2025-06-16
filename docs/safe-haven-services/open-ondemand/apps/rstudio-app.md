# Run RStudio Server

Run RStudio Server is a Container Execution Service app that allows you to run an RStudio Server container on a back-end within your safe haven.

The container is run using Podman.

---

## Run RStudio Server container

Complete the following information the app form:

* Cluster: The back-end (cluster) within your safe haven on which to run the container. Back-end short-names are used in the drop-down list and safe haven-specific back-ends include the text 'tenant' (see [Back-end (cluster) names](../jobs.md#back-end-cluster-names) for more information).
    * **National Safe Haven users**: If you want to use a 'desktop' back-end, then you must select the 'desktop\' you have been granted access to.
* Container name: Name to be given to the container when it is run.
    * Your user name and a timestamp will be added as a prefix to the name to prevent name clashes if running multiple containers from the same image. For example, `user-052010544547-my-rstudio`.
    * If omitted, then the container image name is used. For example, `user-052010544552-epcc-ces-rstudio`.
* RStudio Server password: RStudio Server running in the container needs to be password-protected. Specify the password to use.
* Cores (max 28): Number of cores/CPUs requested for this job. Your selected back-end (cluster) must have the selected number of cores/CPUs available.
* Memory in GiB (max 58 GiB): Memory requested for this job. Your selected back-end (cluster) must have the selected memory available.

Click **Launch**.

Open OnDemand will submit a job to your chosen back-end to create and run the container.

When the container has started a **Connect to RStudio Server** button will appear.

Click **Connect to RStudio Server**.

!!! Warning

    Open OnDemand will wait 1200 seconds (20 minutes) for your container to start. If it does not start within this time the job will be cancelled.

!!! Warning

    Your job, and so your container. will run for a maximum of 6 hours.

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

## Log in

A Sign in to RStudio page will appears. Enter:

* Username: root
* Password: password you selected when completing the app form.

Click **Sign in**.

!!! Note

    You are the 'root' user **only** within the context of the container. You will not have 'root' access to the back-end on which the container is running! Any files you create in the directories mounted into the container will be owned by your own user, and user group, on the back-end.

---

## Sharing files between a back-end and the container

See [Sharing files between a back-end and a container](../containers.md#sharing-files-between-a-back-end-and-a-container)

---

## View job files

On a job's job card, click the **Session ID** link to open the [File Manager](../files.md), pointing at the job context directory for the job on the Open OnDemand host.

!!! Info

    When using a back-end where your home directory is not common to both the Open OnDemand host and the back-end, then, if your job creates files on the back-end, you will have to log into the back-end to view your files - see [Log into back-ends](../ssh.md).

---

## Log into back-end

While the job is running, click the **Host** link to log into to back-end on which the job is running.

If the job has completed, see [Log into back-ends](../ssh.md) for ways to log into the back-end.

---

## Take a break

Your container job will continue to run even if you do the following:

* Log out of RStudio Server via **File**, **Sign Out**.
* Log out of RStudio Server via **File**, **Quit Session...**.
* Close the browser tab.
* Log out of Open OnDemand.
* Log out of the host from which you accessed Open OnDemand.

You can re-access your running container via the **Connect to RStudio Server** on your session's [job card](../jobs.md#job-cards) on the [My Interactive Sessions](../jobs.md#my-interactive-sessions-page) page accessed via **My Interactive Sessions** (overlaid squares icon) on the menu bar.

---

## End your job

You can end your job as follows:

* Cancel or delete the job via Open OnDemand. See [Browse and manage jobs](../jobs.md#browse-and-manage-jobs).
