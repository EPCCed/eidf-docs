# Run RStudio Server

'Run RStudio Server' is a Container Execution Service app that allows you to run an RStudio Server container on a back-end within your safe haven.

The container is run using Podman.

---

## Run RStudio Server container

Complete the following information the app form:

* Cluster: The back-end (cluster) within your safe haven on which to run the container. Back-end short-names are used in the drop-down list and safe haven-specific back-ends include the text 'tenant' (see [Back-end (cluster) names](../jobs.md#back-end-cluster-names) for more information).
* Container name: Name to be given to the container when it is run.
    - Your user name and a timestamp will be added as a prefix to the name to prevent name clashes if running multiple containers from the same image. For example, `user-052010544547-my-rstudio`.
    - If omitted, then the container image name is used. For example, `user-052010544552-epcc-ces-rstudio`.
* RStudio Server password: RStudio Server running in the container needs to be password-protected. Specify the password to use.
* Cores (max 28): Number of cores/CPUs requested for this job. Your selected back-end (cluster) must have the selected number of cores/CPUs available.
* Memory in GiB (max 58 GiB): Memory requested for this job. Your selected back-end (cluster) must have the selected memory available.

Click 'Launch'.

Open OnDemand will submit a job to your chosen back-end to create and run the container.

When the container has started a 'Connect to RStudio Server' button will appear.

Click 'Connect to RStudio Server'.

!!! Note

   Your job, and so your container. will run for a maximum of 6 hours.

### Troubleshooting: Proxy Error

If you click 'Connect to RStudio Server' and get:

> Proxy Error
>
> The proxy server received an invalid response from an upstream server.
> The proxy server could not handle the request
>
> Reason: Error reading from remote server
>
> Apache/2.4.52 (Ubuntu) Server at eidf147-runner-vm Port 443

Then, refresh the web page, or click the 'Connect to RStudio Server' button again.

---

## Using RStudio Server

### Log in

A 'Sign in to RStudio' page will appears. Enter:

* Username: root
* Password: password you selected when completing the app form.

Click 'Sign in'.

!!! Note

    You are only the `root` user within the context of the container, not on the back-end itself! Any files you create in the mounted directories described below will be owned by your own user on the back-end.

### Access directories on back-end

Within RStudio Server, you will have the following directories available, mounted into the container from the back-end:

* `/safe_data/`: A mount that corresponds to your project's `/safe_data/` subdirectory on the back-end. The subdirectory to mount is inferred from your user group.
* `/safe_outputs/`: A mount that corresponds to an 'outputs' directory created in your home directory on the back-end. The directory name is `outputs-NUMBER`, where `NUMBER` is a randomly-generated number, for example `outputs-3320888`. The directory exists after the job ends.
* `/scratch/`: A mount that corresponds to a 'scratch-NUMBER' directory created in your home directory on the back-end. The directory name is `scratch-NUMBER`, where `NUMBER` is the same as that created for `outputs-NUMBER`, for example `scratch-3320888`. This directory exists for the duration of the job and is then deleted.

### Take a break

Your container job will continue to run even if you do the following:

* Log out of RStudio Server via 'File', 'Sign Out'.
* Log out of RStudio Server via 'File', 'Quit Session...'.
* Close the browser tab.
* Log out of Open OnDemand.
* Log out of the host from which you accessed Open OnDemand.

You can re-access your running container via 'My Interactive Sessions' (overlaid squares icon) on the menu bar, then 'Connect to RStudio Server' on your session's job card.

### End your job

You can end your job as follows:

* Cancel or delete the job via Open OnDemand. See [Browse and manage jobs](../portal.md#browse-and-manage-jobs).
