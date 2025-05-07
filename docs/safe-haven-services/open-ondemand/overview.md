# Using Open OnDemand

---

## Introduction

This page documents how to use Open OnDemand. It is not intended to be a complete introduction to every Open OnDemand feature, but rather the essentials that will hopefully help you to get started with Open OnDemand.

* [Access Open OnDemand](#access-open-ondemand)
* [About Open OnDemand and back-ends](#about-open-ondemand-and-back-ends)
    - [Your 'ondemand' directory](#your-ondemand-directory)
    - [Job dump files](#job-dump-files)
* [An overview of the Open OnDemand user interface](#an-overview-of-the-open-ondemand-user-interface)
    - [Menu bar](#menu-bar)
    - ['Jobs' panel](#jobs-panel)
* [File browser](#file-browser)
* [Active Jobs](#active-jobs)
* [Job Composer](#job-composer)
* [Apps](#apps)
    - [App jobs](#app-jobs)
    - [Job cards](#job-cards)
    - [Run Container](#run-container)
    - [Run Jupyter Notebook](#run-jupyter-notebook)
    - [Run RStudio](#run-rstudio)
* [My Interactive Sessions](#my-interactive-sessions)
* [Create passphraseless SSH access to a back-end](#create-passphraseless-ssh-access-to-a-back-end)

---

## Access Open OnDemand

Within a browser within a desktop virtual machine within your safe haven, enter the Open OnDemand URL for your safe haven:

* National Safe Haven, https://nsh-ondemand.nsh.loc
* ODAP, https://odp-ondemand.nsh.loc
* Smart Data Foundry, https://smartdf-ondemand.nsh.loc
* DataLoch, https://dap-ondemand.nsh.loc

Note: for development, EPCCers can also use a browser running within the epcc-staff host.

Ignore any warning about certificates.

The Open OnDemand log in page will appear.

Enter your project username and password. These are the same username and password that you would log into a desktop virtual machine within your safe haven.

Click 'Log in'.

Open OnDemand's user interface will appear.

**Troubleshooting: Bad Request**

If you see page, 'Bad Request' 'Your browser sent a request that this server could not understand.', then revisit the URL and try to log in again. This can arise if there is information in your browser cache from a previous Open OnDemand session.

**Troubleshooting: Cannot access Open OnDemand**

For problems with accessing Open OnDemand, first try the following in a terminal window:
```console
$ curl --insecure OPEN-ONDEMAND-URL
```
The result should be '302 Found' and a redirect to the URL with a `/pun/sys/dasboard` path. If not, then ask MikeJ initially. We can follow up with Systems Team if necessary.

For any problems logging into Open OnDemand, first double-check your username and password, then ask MikeJ.

---

## About Open OnDemand and back-ends

Open OnDemand allows you to log in to, submit jobs to and run containers on the back-ends (or clusters) available within your safe haven.

You will be able to see information about each back-end and to log in, submit jobs to and to request that you run containers on the back-ends.

Users of certain safe havens will also have access to the Superdome Flex HPC cluster, a shared trusted research environment service. If your safe haven provides access to Superdome Flex then you will be able to log into it, and submit jobs to it via the [Job Composer](#job-composer) and [Run Container](#run-container).

**Note (smartdf-ondemand users):** Though Superdome Flex is visible as a cluster from smartdf-ondemand.nsh.loc, and can be logged into, jobs can only be submitted to it once you have set up passphraseless SSH access from smartdf-ondemand.nsh.loc to Superdome Flex to enable your 'ondemand' directory, which includes any job files, to be transferred via 'rsync' (see next section and [Create passphraseless SSH access to a back-end](#create-passphraseless-ssh-access-to-a-back-end)).

**Note (dap-ondemand users):** Though DataLoch backends are visible as clusters from dap-ondemand.nsh.loc and can be logged into, jobs can only be submitted to it once you have set up passphraseless SSH access from dap-ondemand.nsh.loc to a back-end to enable your 'ondemand' directory, which includes any job files, to be transferred via 'rsync' (see next section and [Create passphraseless SSH access to a back-end](#create-passphraseless-ssh-access-to-a-back-end)).

### Your 'ondemand' directory

Within your home directory on the Open OnDemand host, you will have an `ondemand` directory. This is where Open OnDemand puts information about your session and, in app-specific subdirectories, the files it needs to run a specific job on a back-end. 

Each app-specific directory subdirectories holds one subdirectory per job. These are called job context directories. Where they are located is app-dependant. For example:

```
$HOME/ondemand/data/sys/myjobs/projects/default/<JOB_ID>/
$HOME/ondemand/data/sys/dashboard/batch_connect/sys/<app_name>/output/<SESSION_ID>/
```

Your home directory on the Open OnDemand host is synchronised with your home directory on the back-ends, and vice-versa, so Open OnDemand job files are available when jobs are run on the back-end. This is either done via mounting your home directory on both the Open OnDemand host and the back-end or synchronising your 'ondemand' folder with the back-end, via 'rsync', when a job is run (which is used depends on the back-end you are using).

### Job dump files

When you submit a job to a back-end, a dump file is created within an `ondemand-slurm-logs` directory within your home directory on the Open OnDemand host.

Dump files have name `sbatch-<YYYYMMDD-HHMMSS>-<OPEN_ONDEMAND_CLUSTER_NAME>`. For example, `$HOME/ondemand-slurm-logs/sbatch-20240807-082901-nsh_tenant_gpu_desktop01`. Dump files are populated as follows:
```
# Open OnDemand back-end: <OPEN_ONDEMAND_CLUSTER_NAME>`
# Time: <YYYY-MM-DD HH:MM:SS>
# Process: <PROCESS-ID>
# Open OnDemand server environment
...dump of environment variables in current Open OnDemand environment...
# sbatch arguments from Open OnDemand
...arguments passed from Open OnDemand to 'sbatch'...
```

---

## An overview of the Open OnDemand user interface

The Open OnDemand user interface consists of a menu bar and an apps panel ('Jobs').

### Menu bar

'Apps' menu:

* 'Active Jobs' opens [Active Jobs](#active-jobs).
* 'Job Composer' opens [Job Composer](#job-composer).
* Links to apps shown on the ['Jobs' panel](#jobs-panel).
* 'All Apps' opens 'All apps' page which has a list of links to all the above apps above, any other available apps, plus one 'Shell Access' link for each back-end to which you have access (selecting an option optns up an SSH session to the back-end).

'Files' menu:

* 'Home Directory' opens the [File browser](#file-browser) pointing at your home directory on the Open OnDemand host.

'Jobs' menu:

* 'Active Jobs' opens [Active Jobs](#active-jobs).
* 'Job Composer' opens [Job Composer](#job-composer).
* Links to apps shown on the ['Jobs' panel](#jobs-panel).

'Clusters' menu:

* One option for each back-end to which you have access. Selecting an option optns up an SSH session to the back-end.

'My Interactive Sessions (overlaid squares icon)' opens [My Interactive Sessions](#my-interactive-sessions).

'?' menu:

* 'Restart Web Server' does not restart the whole Open OnDemand web server! Rather it restarts your personal session with Open OnDemand. You won't need to log in again.

'Log Out' logs you out of Open OnDemand.

### 'Jobs' panel

The 'Jobs' panel has a selection of pinned apps. All available apps are shown on the 'All Apps' page (available via 'Apps' => 'All Apps').

* [Active Jobs](#active-jobs)
* [Job Composer](#job-composer)
* [Run Container](#run-container)
* [Run Jupyter Notebook](#run-jupyter-notebook)
* [Run RStudio](#run-rstudio)

---

## File browser

A page with a file browser that allows you to explore your home directory on the Open OnDemand host, including the job context directories.

'Open in Terminal' opens up an SSH session to a back-end. The default back-end is the first one in alphabetical order. Click '>' to see one option for each back-end to which you have access.

**Troubleshooting: 'Open in Terminal' 'cd ... No such file or directory'**

If you see 'cd ... No such file or directory' error after you have logged into the back-end, then this means that the directory you are currently viewing in the File browser is not in your home directory in the back-end. This can happen if your Open OnDemand home directory is not mounted onto the back-end (for example if using Superdome Flex) and your 'ondemand' directory is synchronised with the back-end when a job is submitted.

---

## Active Jobs

This page shows a list of active jobs submitted via Open OnDemand.

The view can be altered as follows:

* 'All Jobs' toggles between 'All Jobs' and 'Your Jobs'.
* 'All Clusters' toggles between 'All Clusters' (back-ends) or a specific back-end to which you have access.

For each job:

* 'Open in File Manager' opens the [File browser](#file-browser) pointing at the job context directory on the Open OnDemand host for the job. For example:
```
$HOME/ondemand/data/sys/myjobs/projects/default/<JOB_ID>/
$HOME/ondemand/data/sys/dashboard/batch_connect/sys/<app_name>/output/<SESSION_ID>/
```
* 'Open in File Terminal' opens an SSH session into the job context directory for the job on the back-end.
* 'Delete' cancels the selected job if it is running.

---

## Job Composer

Job Composer allows you to submit Slurm batch jobs to any back-end to which you have access.

A list of existing jobs, if any, are shown.

To create a new job, select 'New Job':

* 'From Default Template' creates a 'hello world' job.
* 'From Template' creates a 'hello world' job. As there is only one template, this offers the same option as 'From Default Template'.
* 'From Specified Path' creates a new job from the contents of an existing directory. This directory should have the job submission script and any other files within it.
* 'From Selected job' creates a new job from the contents of the job context directory for the currently selected job on the page, if any.

When a job is created, the job files are written to the job context directory, `$HOME/ondemand/data/sys/myjobs/projects/default/<JOB_ID>/`.

Clicking on a job shows details about the job on the same page.

Both 'Edit Files' and 'Open Dir' open the [File browser](#file-browser) pointing at the job context directory on the Open OnDemand host for the currently selected job.

'Job Options' opens up a form where you can edit the job name, target back-end, Slurm job submission script, account and other options.

'Open Terminal' opens an SSH session into the job context directory for the job on the back-end.

'Open Editor' opens an editor to allow editing of the Slurm job submission script.

Clicking on a file name under 'Folder Contents' opens an editor to allow editing of the selected file.

'Templates' opens a page that allows you to browse and copy existing job templates. You can then customise these templates and use these templates when creating jobs in future. Job templates are copied into your 'ondemand' directory, under `$HOME/ondemand/data/sys/myjobs/templates`. A template-specific subdirectory name is derived from the job name in the source template, converted to lower snake_case (e.g., job name '(default) Simple Sequential Slurm Job' gives directory name 'default_simple_sequential_slurm_job').

For back-ends which do not mount your home directory onto both the Open OnDemand host and back-end, any files created on as a result of running a job are **not** synchronised with the Open OnDemand host. If you want to browse any files created when running a job you need to SSH into that back-end (either via Open OnDemand which is supported from a number of places within the user interface or by other means).

**Troubleshooting: 'Open in Terminal' 'cd ... No such file or directory'**

If you see 'cd ... No such file or directory' error after you have logged into the back-end, then this means that the directory you are currently viewing in the File browser is not in your home directory in the back-end. This can happen if your Open OnDemand home directory is not mounted onto the back-end (for example if using Superdome Flex) and your 'ondemand' directory is synchronised with the back-end when a job is submitted.

---

## Apps

Open OnDemand offers a number of apps which submit jobs to carry out various tasks.

### App jobs

When a job for an app is created, its job files to run the app are written to the job context directory
```
$HOME/ondemand/data/sys/dashboard/batch_connect/sys/<app_name>/output/<SESSION_ID>/
```

The 'data root directory' link on the app's form opens the [File browser](#file-browser) pointing at the app directory within which the job context directory will be written.

### Job cards

When an app's job is submitted, a job card is created and shown with information about the app's job.

The session ID link opens the [File browser](#file-browser) pointing at the job context directory on the Open OnDemand host for the job.
```
$HOME/ondemand/data/sys/dashboard/batch_connect/sys/<app_name>/output/<SESSION_ID>/
```

When the job finishes, a 'rerun job (circular arrows icon)' allows you to rerun (resubmit) the job. A new session ID will be created.

### Run Container

This app allows you to run a batch job container on a back-end within your safe haven.

For more information, see [OOD container app](https://git.ecdf.ed.ac.uk/tre-container-execution-service/container_app).

### Run Jupyter Notebook

This app allows you to run a Jupyter Notebook container on a back-end within your safe haven.

For more information, see [OOD Jupyter app](https://git.ecdf.ed.ac.uk/tre-container-execution-service/ood_jupyter_app).

### Run RStudio

This app allows you to run an RStudio container on a back-end within your safe haven.

For more information, see [OOD RStudio app](https://git.ecdf.ed.ac.uk/tre-container-execution-service/ood-rstudio-app).

---

## My Interactive Sessions

This page lists [job cards](#job-cards) for jobs created by the following apps:

* [Run Container](#run-container)
* [Run Jupyter Notebook](#run-jupyter-notebook)
* [Run RStudio](#run-rstudio)

---

## Create passphraseless SSH access to a back-end

For certain Open OnDemand features, you need to set up passphraseless SSH access to back-ends to enable your 'ondemand' directory, which includes any job files, to be transferred via 'rsync'.

This applies to

* smartdf-ondemand and Superdome Flex back-end shs-sdf01.nsh.loc.
* dap-ondemand and DataLoch back-ends dap-gpu01.nsh.loc, dap-2021-009.nsh.loc, dap-2022-028.nsh.loc.

Create passphraseless SSH keys for a back-end:

* Select 'Clusters' => 'localhost Shell Access' to log into the Open OnDemand host.
* Create SSH key. When prompted for a passphrase, press enter.
```console
$ ssh-keygen -t rsa
```
* Copy public key to back-end:
```console
$ ssh-copy-id BACK-END-HOSTNAME.nsh.loc
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/home/user/.ssh/id_rsa.pub"
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
(user@BACK-END-HOSTNAME.nsh.loc) Password: ...enter your tenant username and password...

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'BACK-END-HOSTNAME.nsh.loc'"

and check to make sure that only the key(s) you wanted were added.
```
* Check passphraseless access to back-end. You should not be prompted for a passphrase.
```console
$ ssh BACK-END-HOSTNAME.nsh.loc
$ ls -l .ssh
total 1
-rw-------. 1 user user 594 Nov 12 09:06 authorized_keys
$ logout
```
