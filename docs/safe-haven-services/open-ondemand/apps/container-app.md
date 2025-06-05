# Run Container

Run Container is a Container Execution Service app that allows you to run a container on a back-end.

The app is designed to run batch containers, those that perform some computational or data-related task. The app is not designed for containers that spawn interactive services (for example, JupyterLab).

The containers **must** conform to the requirements of the Container Execution Service (TODO link). When the container is run (via the Container Execution Service tools (TODO link)), three directories will be mounted into the container:

* `/safe_data/`: A mount that corresponds to your project's `/safe_data/` subdirectory on the back-end. The subdirectory to mount is inferred from your user group.
* `/safe_outputs/`: A mount that corresponds to an 'outputs' directory created in your home directory on the back-end. The directory name is `outputs-NUMBER`, where `NUMBER` is a randomly-generated number, for example `outputs-3320888`. The directory exists after the job ends.
* `/scratch/`: A mount that corresponds to a 'scratch' directory created in your home directory on the back-end. The directory name is `scratch-NUMBER`, where `NUMBER` is the same as that created for `outputs-NUMBER`, for example `scratch-3320888`. This directory exists for the duration of the job and is then deleted.

Batch containers can read/write files to/from any of these directories.

The container can run using Podman or Apptainer, depending on which of these is available on a back-end.

---

## Run a container

Complete the following information the app form:

* Cluster: The back-end (cluster) within your safe haven on which to run the container. Back-end short-names are used in the drop-down list and safe haven-specific back-ends include the text 'tenant' (see [Back-end (cluster) names](../jobs.md#back-end-cluster-names) for more information).
    * **National Safe Haven users**: If you want to use a 'desktop' back-end, then you must select the 'desktop' you have been granted access to.
* Container/image URL in container registry. For example, ghcr.io/mikej888/hello-tre:1.0.
* Container registry username.
* Container registry password/access token. An access token with read-only access to the container registry is strongly recommended but a token with read-write access or a password can also be used.
* Container runner: Container execution tool with which to run container. The selected tool must be available on the selected back-end. Options are 'podman' or 'apptainer'.
* Container name (Podman only). Name to be given to the container when it is run. If omitted, then the container image name is used. For example, if the container image name is `my-container:1.0` then the container name is `my-container`. Your user name and a timestamp will be added as a suffix to the name to prevent name clashes if running multiple containers from the same image. So, the container name will be `yourusername-timestamp-containername` e.g. `mel-060416105069-hello-tre`.
* Cores (max 1152): Number of cores/CPUs requested for this job. Your selected back-end (cluster) must have the selected number of cores/CPUs available.
* Memory in GiB (max 17830 GiB): Memory requested for this job. Your selected back-end (cluster) must have the selected memory available.
* Use GPU?: Request that the container use a GPU. If selected, then the selected back-end must have GPUs available.
* Command-line options to pass to container runner. These are Podman- or Apptainer-specific options to control the container runner's behaviour.
* Environment variables to pass to container. These will be passed on by the container runner and set within the container when it runs. Each line should define one environment variable and value, each in the form, `ENVIRONMENT_VARIABLE=value`. For example:

    ```text
    HELLO_TRE=Greetings
    ```

    * If a value has spaces then, if using Apptainer, enclose the value in double-quotes. If using Podman, do not enclose the value in double-quotes.

* Arguments to pass to container. Container-specific arguments to be passed directly to the container when it is run. For example:

    ````text
    -d 5
    -n container-app-user
    ````

Click **Launch**.

Open OnDemand will submit a job to your chosen back-end to create and run the container.

When the container has started a 'Please wait until your job has completed' message will appear.

!!! Note

    Your job, and so your container. will run for a maximum of 6 hours.

---

## Take a break

Your container job will continue to run even if you do the following:

* Close the browser tab.
* Log out of Open OnDemand.
* Log out of the host from which you accessed Open OnDemand.

---

## End your job

You can end your job by as follows:

* Cancel or delete the job via Open OnDemand. See [Browse and manage jobs](../jobs.md#browse-and-manage-jobs).
