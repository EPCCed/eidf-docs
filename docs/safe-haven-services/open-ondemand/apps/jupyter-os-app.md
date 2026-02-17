# Run JupyterLab

Run JupyterLab is an app that runs JupyterLab on a back-end within your safe haven. JupyterLab is assumed to have been installed onto the back-end.

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

You will not be prompted for a username and password. JupyterLab is protected with an auto-generated password and **Connect to JupyterLab** button is configured to log you in automatically using this password.

---

## Accessing files outside the scope of your home directory

A feature of JupyterLab is that it constrains your ability to browse files to your home directory and subdirectories. This means that you **cannot** access your project's `/safe_data` subdirectory via:

* File browser panel.
* **File** menu, **Open from Path...** menu option.

However, you **can** access these directories and files via:

* Python code.
* JupyterLab Terminal.
* **File** menu, **Save Notebook As...** menu option.

!!! Tip

    A workaround to make this directory visible via JupyterLab file browsers is to create symbolic links from your home directory to this directory. This can be done within a JupyterLab Terminal as follows:

    ```bash
    ln -s /safe_data/PROJECT_SUBDIRECTORY safe_data
    ```

---

## Installing Python packages

JupyterLab is configured with your web proxy environment variables so you can install packages from PyPI when using JupyterLab.

If installing packages you may need to install these within your home directory. Two examples are as follows. Python and JupyterLab resources online may suggest others.

### Install packages within your home directory

Install packages within a subdirectory of your home directory. For example:

1. Select **Launcher**, **Terminal**.
1. Create directory for packages:

    ```bash
    mkdir -t mypips
    ```

1. Install package:

    ```bash
    pip install -t mypips PACKAGE_NAME
    ```

Any Python code that needs the packages needs to include the path to the subdirectory. For example:

```python
import os
import sys
sys.path.append(os.path.join(os.path.expanduser('~'), 'mypips'))
import PACKAGE_NAME
```

### Create a virtual environment within your home directory

Create a virtual environment within your home directory and install packages into that virtual environment. For example:

1. Select **Launcher**, **Terminal**.
1. Create and activate a Python virtual environment:

    ```bash
    python3 -m venv my-venv
    source my-venv/bin/activate
    ```

1. Install package into virtual environment:

    ```bash
    python -m pip install PACKAGE_NAME
    ```

1. Register the virtual environment with JupyterLab, to create new IPython kernels to provide access to the virtual environment within JupyterLab Notebook and Console sessions:

    ```bash
    python -m pip install ipykernel
    python -m ipykernel install --user --name py3-ipykernel-my-venv --display-name 'Python3 (ipykernel my-venv)'
    ```

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
