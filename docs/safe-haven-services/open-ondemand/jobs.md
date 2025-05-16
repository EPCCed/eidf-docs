# Running jobs via Open OnDemand

## Introduction

Open OnDemand allows you to run tasks on compute resources available within your safe haven.

Certain users of certain safe havens may also have acess to TRE-level compute resources, notably the Superdome Flex high-performance computing cluster.

This page introduces how Open OnDemand runs tasks and information you need to know when running tasks.

---

## Back-ends, clusters, jobs and apps

A compute resource upon which tasks are run is called a **back-end** or **cluster**

Each run of a task on a back-end is called a **job**.

An **app** is an Open OnDemand component that performs a specific function. May apps allow you to run jobs on back-ends. However, other apps perform other useful functions, for example, the [Active Jobs](apps/active-jobs.md) app which allows you to see which of your jobs have been submitted, are running, or have completed

A subset of apps that run jobs on back-ends are called **interactive apps**. Within our Open OnDemand service, this relates to how apps are implemented, rather than used. All our container execution service apps are classed, in Open OnDemand terms, as 'interactive' even those apps that run non-interactive containers!

---

## Your `ondemand` directory

Within your home directory on the Open OnDemand host, Open OnDemand creates an `ondemand` directory. This is where Open OnDemand stores information about your current session and previous sessions.

Every time a job is created by an app, Open OnDemand creates the job files for the app in a job-specific **job context directory** in an app-specific directory.

The [Job Composer](apps/job-composer.md) app's job files are created in a directory:
```
ondemand/data/sys/myjobs/projects/default/<job_id>/
```
where `<job_id>` is a numerical identifier. For example,
```
ondemand/data/sys/myjobs/projects/default/1/
```

Interactive app job files are created in a directory:
```
$HOME/ondemand/data/sys/dashboard/batch_connect/sys/<app_name>/output/<session_id>/
```
where `<app_name>` is the app name and `<session_id>` a unique session identifer. For example,
```
ondemand/data/sys/dashboard/batch_connect/sys/container_app/output/e0b9deeb-4b9c-43f8-ad3f-1c85074a1485/
```

---

## Distinct home directories

For most back-ends, your home directory is mounted both on the Open OnDemand host and the back-ends so any job files are immediately available on the back-end, and any files created on the back-end available on the Open OnDemand host and viewable via the [File Browser](portal.md#file-browser-page).

However, you may have access to back-ends where your home directory is not mounted across both the Open OnDemand host and the back-end i.e., you have distinct, separate, home directories on each host.

Currently, the back-ends where home directories are not mounted across both Open OnDemand hosts and the back-ends are as follows:

* Superdome Flex, shs-sdf01.nsh.loc.
* DataLoch hosts, dap-gpu01.nsh.loc, dap-2021-009.nsh.loc, dap-2022-028.nsh.loc.

When using such back-ends, your `ondemand` directory, and so your job files, are automatically copied, to the back-end. How to enable this is described in the following section on [Enable copy of `ondemand` directory to a back-end](#enable-copy-of-ondemand-directory-to-a-back-end).

If your job creates files on the back-end, you will have to log into the back-end to view your files.

### Enable copy of `ondemand` directory to a back-end

To enable Open OnDemand to automatically copy your `ondemand` directory to a back-end where your home directory is not mounted across both the Open OnDemand host and the back-end, you need to set up a passphrase-less SSH key between the Open OnDemand host and the back-end.

!!! Note

    Setting up SSH keys does **not** need to be done for back-ends where your home directory is mounted both on the Open OnDemand host and the back-ends.

Set up a passphrase-less SSH key between the Open OnDemand host and the back-end:

* Select 'Clusters' => 'Open OnDemand host Shell Access'.
* A new browser tab with an SSH session to the back-end on which the job is running will appear.
* When prompted, enter your project username and password.
* Create a passphrase-less SSH key:
```console
$ ssh-keygen -t rsa -b 4096 -C "open-ondemand" -N ""
```
* Copy public key to back-end:
```console
$ ssh-copy-id BACK-END-HOSTNAME.nsh.loc
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/home/user/.ssh/id_rsa.pub"
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
(user@BACK-END-HOSTNAME.nsh.loc) Password: 
```
* When prompted, enter your project username and password. The key will then be added to the back-end:
```
Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'BACK-END-HOSTNAME.nsh.loc'"

and check to make sure that only the key(s) you wanted were added.
```
* Check passphrase-less access to back-end:
```console
$ ssh BACK-END-HOSTNAME.nsh.loc hostname
BACK-END-HOSTNAME.nsh.loc hostname
```
* You should not be prompted for a passphrase or password.

---

## Job log files

When a job is submitted to a back-end, a log is created within an `ondemand-slurm-logs` directory within your home directory on the Open OnDemand host.

Log files have name `sbatch-<YYYYMMDD-HHMMSS>-<OPEN_ONDEMAND_CLUSTER_NAME>`. For example, `sbatch-20240807-082901-nsh_tenant_gpu_desktop01`.

An example of the contents of a log file is as follows:
```
# Open OnDemand back-end: <OPEN_ONDEMAND_CLUSTER_NAME>`
# Time: <YYYY-MM-DD HH:MM:SS>
# Process: <PROCESS-ID>
# Open OnDemand server environment
...values environment variables in current Open OnDemand environment...
# sbatch arguments from Open OnDemand
...arguments passed from Open OnDemand to 'sbatch' command which runs job...
```

---

## What happens when a job is submitted

TODO

Expand/rewrite

* Creates 'ondemand' subdirectory as above.
* Creates log file as above.
* 'Pushes' job files, for back-ends where your home directory is not mounted across both the Open OnDemand host and the back-end.
* Job is 'Queued' pending resources.
* Job is' Starting'
* Job is 'Running'
* Job is 'Completed'

---

## Interactive app job cards

When an interactive app's job is submitted, a job card is created and shown with information about the app's job.

!!! Note

    Job cards are not created for jobs submitted via the [Job Composer](apps/job-composer.md) app. See that app's page for how apps are submitted and managed.

The job status, shown on the top-right of the job card, can be one of: 'Queued', 'Starting', 'Running', 'Held', 'Suspended', 'Completed', 'Undetermined'.

!!! Note

    The job status does not display whether a job that is 'Completed' did so with success or failure. That can be seen in the job details for the job which can be seen via the [Active Jobs](apps/active-jobs.md) app.

Click the 'Session ID' link to open the [File Browser](portal.md#file-browser-page) pointing at the job context directory for the job on the Open OnDemand host.

!!! Note

    When using a back-end where your home directory is not mounted across both the Open OnDemand host and the back-end, then, if your job creates files on the back-end, you will have to log into the back-end to view your files.

Click the 'Host' link to open a new browser tab with an SSH session to the back-end on which the job is running.

When prompted, enter your project username and password. These are the same username and password that you used when logging into your safe haven host.

Click 'Cancel' to cancel a running job.

Click 'Relaunch job' (circling arrows icon) to relaunches the job, a new session ID will be created.

Click 'Delete' to delete the job card.

