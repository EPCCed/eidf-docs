# Run JupyterLab

Run JupyterLab is an app that runs JupyterLab on a back-end within your safe haven. JupyterLab is run as a container, using Apptainer.

---

## Run app

Complete the following information the app form:

* **Cluster**: A back-end (cluster) within your safe haven on which to run JupyterLab. Back-end-specific short-names are used in the drop-down list (see [Back-end (cluster) names](../jobs.md#back-end-cluster-names) for more information). If there is only one back-end available to you then this form field won't be shown.

    !!! Note

        **National Safe Haven users**: If using a 'desktop' back-end, then you must select the 'desktop' you have been granted access to.

* **CPUs/cores**: CPUs/cores requested for the app's job.
* **Memory (GiB)**: Memory requested for the app's job.

Click **Launch**.

Open OnDemand will create job files for the app in a job-specific job context directory in an app-specific directory under your `ondemand` directory and then submits the job for the app to the job scheduler.

Open OnDemand will show an app job card with information about the app's job including:

* Job status (on the top right of the job card): initially 'Queued'.
* 'Created at': The time the job was submitted.
* 'Time Requested': The runtime requested for the job.
* 'Session ID': An auto-generated value which is used as the name of the job-specific job context directory.
* App-specific information, which includes values from the app form:
    * 'Connection timeout (s)': when the app's job starts running, the app will then wait for JupyterLab to become available. If this does not occur within this app-specific period, then the app's job will cancel itself.
    * 'CPUs/cores': The value you selected on the app form.
    * 'Memory (GiB)' The value you selected on the app form.

When the job starts, the Job status on the job card will update to 'Starting' and 'Time Requested' will switch to 'Time Remaining', the time your job has left to run before it is cancelled by the job scheduler.

When the Job status updates to 'Running', a **Host** link will appear on the job card, which allows you to log in to the back-end on which the job, and so JupyterLab, is now running.

A **Connect to JupyterLab** button will appear. JupyterLab is now ready for use.

Click **Connect to JupyterLab**. A new browser tab will open with JupyterLab.

!!! Warning

    Open OnDemand will wait 180 seconds (3 minutes) for JupyterLab to start. If it does not start within this time the job will be cancelled.

!!! Warning

    JupyterLab will run for a maximum of 6 hours, after which it will be cancelled.

!!! Warning

    Any running jobs are cancelled during the monthly Safe Haven Services maintenance period.

!!! Note

    Within the job scheduler, and the [Active Jobs](./active-jobs.md) app, this app's jobs are named 'jupyter_app'.

---

## Log in to JupyterLab

You will not be prompted for a username and password. JupyterLab is protected with an auto-generated password and the **Connect to JupyterLab** button is configured to log you in automatically using this password.

---

## Sharing files between the back-end and JupyterLab and persisting state between app runs

The app mounts directories from the back-end into JupyterLab at `/safe_data`, `/safe_outputs` and `/scratch` . For more information on these directories, see [Sharing files between a back-end and a container](../containers.md#sharing-files-between-a-back-end-and-a-container).

Your home directory is mounted within JupyterLab at the same path as your home directory on the back-end. Any directories and files you create within your home directory within JupyterLab will be available in your home directory on the back-end, and vice-versa.

You should create any Python scripts, notebooks, configuration files, virtual environments or download any Python packages into directories within your home directory so that they are available the next time you run the app.

!!! Warning

    Any files created outside of these directories will be **deleted** when the app stops.

---

## Installing Python packages

JupyterLab is configured with your web proxy environment variables so you can install packages from PyPI when using JupyterLab. It is recommended that you install Python packages and/or create virtual environments within a directory within your home directory in JupyterLab so that you can reuse these the next time you run the app on the same back-end.

There are many ways you can use such a directory within JupyterLab. Two examples are as follows. Python and JupyterLab resources online will suggest many others.

### Install packages within `.local/lib/pythonM.N/site-packages/`

By default, `pip` will install packages within a `.local/lib/pythonM.N/site-packages/` subdirectory in your home directory, where `M.N` is a Python version, for example `.local/lib/python3.11/site-packages/`.

Install a package within `.local/lib/pythonM.N/site-packages/`:

1. Select **Launcher**, **Terminal**.
1. Install package:

    ```bash
    pip install PACKAGE_NAME
    ```

As the subdirectory is in your home directory, the package will be available the next time that you run the app on the back-end.

### Create a virtual environment

Create a virtual environment and install a package into that virtual environment:

1. Select **Launcher**, **Terminal**.
1. Create a subdirectory for the virtual environment:

    ```bash
    mkdir -p my-venv
    ```

1. Create and activate the virtual environment within this subdirectory:

    ```bash
    python -m venv my-venv
    source my-venv/bin/activate
    ```

1. Install packages into the virtual environment:

    ```bash
    python -m pip install PACKAGE_NAME
    ```

To create a new IPython kernel to provide access to the virtual environment within a JupyterLab Notebook or Console, register the virtual environment with JupyterLab:

1. Within a JupyterLab Terminal, add the 'ipykernel' package to the virtual environment:

    ```bash
    python -m pip install ipykernel
    ```

1. Create a new kernel for your virtual environment:

    ```bash
    python -m ipykernel install --user --name py3-ipykernel-my-venv --display-name 'Python3 (ipykernel my-venv)'
    jupyter kernelspec list
    ```

1. You should see your kernel listed. For example:

    ```text
    Available kernels:
      py3-ipykernel-my-venv    $HOME/.local/share/jupyter/kernels/py3-ipykernel-my-venv
      python3                  $HOME/.local/share/jupyter/kernels/python3
    ```

1. New Console and Notebook buttons for your kernel will shortly appear in the Launcher panel.

As the virtual environment and kernel subdirectories are in your home directory, the package and kernel configuration will be available the next time that you run the app on the back-end.

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

JupyterLab will continue to run even if you do the following:

* Log out of JupyterLab via the **File** menu, **Log Out** option.
* Close the browser tab.
* Log out of Open OnDemand.
* Log out of the VM from which you accessed Open OnDemand.

You can re-access your running JupyterLab via the **Connect to JupyterLab** on your session's [job card](../jobs.md#job-cards) on the [My Interactive Sessions](../jobs.md#my-interactive-sessions-page) page accessed via **My Interactive Sessions** (overlaid squares icon) on the menu bar.

![My Interactive Sessions menu button, an overlaid squares icon](../../../images/open-ondemand/my-interactive-sessions-button.png){: class="border-img center"} ***My Interactive Sessions** menu button*

---

## End your job

You can end your job by as follows:

* Either, shut down JupyterLab via the **File** menu, **Shut Down** option.
* Or, cancel or delete the job via Open OnDemand. See [Browse and manage jobs](../jobs.md#browse-and-manage-jobs).
