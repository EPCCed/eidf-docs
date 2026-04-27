# Run RStudio Server

Run RStudio Server is an app that runs RStudio Server on a back-end within your safe haven. RStudio Server is run as a container, using Apptainer.

---

## Run app

Complete the following information the app form:

* **Cluster**: A back-end (cluster) within your safe haven on which to run RStudio Server. Back-end-specific short-names are used in the drop-down list (see [Back-end (cluster) names](../jobs.md#back-end-cluster-names) for more information). If there is only one back-end available to you then this form field won't be shown.

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
    * 'Connection timeout (s)': when the app's job starts running, the app will then wait for RStudio Server to become available. If this does not occur within this app-specific period, then the app's job will cancel itself.
    * 'CPUs/cores': The value you selected on the app form.
    * 'Memory (GiB)' The value you selected on the app form.

When the job starts, the Job status on the job card will update to 'Starting' and 'Time Requested' will switch to 'Time Remaining', the time your job has left to run before it is cancelled by the job scheduler.

When the Job status updates to 'Running', a **Host** link will appear on the job card, which allows you to log in to the back-end on which the job, and so RStudio Server, is now running.

A **Connect to RStudio Server** button will appear. RStudio Server is now ready for use.

Click **Connect to RStudio Server**. A new browser tab will open with RStudio Server.

!!! Warning

    Open OnDemand will wait 180 seconds (3 minutes) for RStudio Server to start. If it does not start within this time the job will be cancelled.

!!! Warning

    RStudio Server will run for a maximum of 6 hours, after which it will be cancelled.

!!! Warning

    Any running jobs are cancelled during the monthly Safe Haven Services maintenance period.

!!! Note

    Within the job scheduler, and the [Active Jobs](./active-jobs.md) app, this app's jobs are named 'rstudio_app'.

---

## Log in to RStudio Server

You will not be prompted for a username and password. RStudio Server is protected with an auto-generated password and the **Connect to RStudio Server** button is configured to log you in automatically using this password.

---

## Sharing files between the back-end and RStudio Server and persisting state between app runs

The app mounts directories from the back-end into RStudio Server at `/safe_data`, `/safe_outputs` and `/scratch` . For more information on these directories, see [Sharing files between a back-end and a container](../containers.md#sharing-files-between-a-back-end-and-a-container).

Your home directory is mounted within RStudio Server at the same path as your home directory on the back-end. Any directories and files you create within your home directory within RStudio Server will be available in your home directory on the back-end, and vice-versa.

You should create any R scripts and configuration files, or download any R packages into directories within your home directory so that they are available the next time you run the app.

!!! Warning

    Any files created outside of these directories will be **deleted** when the app stops.

---

## Accessing files outside the scope of your home directory

A feature of RStudio Server is that it constrains your ability to browse directories and files above your home directory within some menu commands and panels. This includes the `/safe_data`, `/safe_outputs`, and `/scratch` directories.

You can access these directories as follows:

* `/safe_outputs` and `/scratch` can be accessed via your home directory in `safe_outputs` and `scratch/rstudio/SESSION_ID` respectively i.e., the directories mounted onto `/safe_outputs` and `/scratch`.
* **File** menu, **Open File** menu option:
    * Enter the directory or file path into the **Open File** dialog, **File name** field.
    * Click **Open**.
* **Files** panel:
    * Click the '**...**' (ellipsis)  button.
    * Enter the directory into the **Go To Folder** dialog box.
    * Click **OK**.
* **Session** menu, **Set Working Directory**, **Choose Directory** menu option:
    * Run, within an RStudio Server Console:

        ```R
        setwd('/')
        ```

    * The directories will now be available for the menu option.

* **Tools** menu, **Global Options** tab, 'RSessions' **Default working directory** option:
    * Click **Browse...**.
    * `/safe_outputs` can be accessed via your home directory in `safe_outputs` i.e., the directory mounted onto `/safe_outputs`.
    * `/scratch` is deleted when the app completes so should not be selected for use as a default working directory.
    * `/safe_data` cannot be selected for use as a default working directory.

---

## Installing R packages

RStudio Server is configured with your web proxy environment variables so you can install packages from CRAN when using RStudio Server. It is recommended that you install R packages within a directory within your home directory in RStudio Server so that you can reuse these the next time you run the app on the same back-end.

There are many ways you can use such a directory within RStudio Server. Two examples are as follows. R and RStudio Server resources online will suggest many others.

### Install packages within `R/x86_64-pc-linux-gnu-library/M.N`

By default, R will install packages within a `R/x86_64-pc-linux-gnu-library/M.N` subdirectory of your home directory where `M.N` is an R version, for example `R/x86_64-pc-linux-gnu-library/4.4`.

Install a package within `R/x86_64-pc-linux-gnu-library/M.N`:

1. Install package:

    ```R
    > install.packages('PACKAGE_NAME')
    ```

As the subdirectory is in your home directory, the package will be available the next time that you run the app on the back-end.

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
