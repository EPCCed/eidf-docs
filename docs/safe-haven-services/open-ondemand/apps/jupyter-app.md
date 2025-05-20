# Run JupyterLab

'Run JupyterLab' is a Container Execution Service app that allows you to run a JupyterLab container on a back-end within your safe haven.

The container is run using Podman.

---

## Run app

Complete the following information the app form:

* Cluster: The back-end (cluster) within your safe haven on which to run the container. Back-end short-names are used in the drop-down list and safe haven-specific back-ends include the text 'tenant' (see [Back-end (cluster) names](../jobs.md#back-end-cluster-names) for more information).
* Container name: Name to be given to the container when it is run.
    - Your user name and a timestamp will be added as a prefix to the name to prevent name clashes if running multiple containers from the same image. For example, `user-052010544547-my-jupyter`.
    - If omitted, then the container image name is used. For example, `user-052010544552-epcc-ces-jupyter`.
* Connection timeout: Time to wait for connection to container (seconds). When the job runs, Open OnDemand will wait for this duration to connect to the container. If the wait times out, then the job will be cancelled.
* Cores (max 28): Number of cores/CPUs requested for this job. Your selected back-end (cluster) must have the selected number of cores/CPUs available.
* Memory in GiB (max 58 GiB): Memory requested for this job. Your selected back-end (cluster) must have the selected memory available.

Click 'Launch'.

Open OnDemand will submit a job to your chosen back-end to create and run the container.

When the container has started a 'Connect to JupyterLab' button will appear.

Click 'Connect to JupyterLab'.

!!! Note

    Your JupyterLab container will be password-protected. The password is auto-generated. The 'Connect to JupyterLab' button is configured to log you into the container using this password automatically.

!!! Note

   Your job will run for a maximum of 6 hours.

---

## Troubleshooting: Proxy Error

If you click 'Connect to Jupyter' and get:

> Proxy Error
>
> The proxy server received an invalid response from an upstream server.
> The proxy server could not handle the request
>
> Reason: Error reading from remote server
>
> Apache/2.4.52 (Ubuntu) Server at eidf147-runner-vm Port 443

Then, refresh the web page.
