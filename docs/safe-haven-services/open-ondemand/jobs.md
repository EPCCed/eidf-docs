# Run jobs

---

## Introduction

Open OnDemand allows you to run tasks on compute resources available within your safe haven.

Certain users of certain safe havens may also have acess to TRE-level compute resources, notably the Superdome Flex high-performance computing cluster.

This page introduces how Open OnDemand runs tasks and information you need to know about when running tasks.

---

## Back-ends, clusters, jobs and apps

A compute resource upon which tasks are run is called a **back-end** or **cluster**

Each run of a task on a back-end is called a **job**.

An **app** is an Open OnDemand component that performs a specific function. Many apps allow you to run jobs on back-ends. However, other apps perform other useful functions, for example, the [Active Jobs](apps/active-jobs.md) app which allows you to see which of your jobs have been submitted, are running, or have completed.

A subset of apps that run jobs on back-ends are called **interactive apps**. Within our Open OnDemand service, this relates to how apps are implemented, rather than used. All our Container Execution Service apps are classed, in Open OnDemand terms, as 'interactive' even those apps that run non-interactive containers!

### Back-end (cluster) names

Within the Open OnDemand portal, back-ends are typically referred to via human-readable names. A selection of back-end names includes:

* DataLoch 2021 009 GPU server
* eDRIS National Safe Haven GPU desktop 01
* ODAP GPU desktop 01
* Smart Data Foundry GPU desktop 01
* Superdome Flex

A convention is adopted whereby safe haven-specific back-ends always cite the safe haven name.

Within some interactive apps, you will see back-ends referred to via 'short-names'. Typically, these short-names are derived from the back-ends' host names. However, a convention is adopted whereby short-names for safe haven-specific back-ends include the text 'tenant'. So, for example, the short-names corresponding to the above back-ends are:

* dap_tenant_2021_009
* nsh_tenant_gpu_desktop01
* odp_tenant_gpu_desktop01
* smartdf_tenant_gpu_desktop01
* shs_sdf01 - as the SuperdomeFlex is a TRE-level, not safe haven-specific, back-end its short-name does not include 'tenant'.

On [job cards](#job-cards) on the [My Interactive Sessions](#my-interactive-sessions-page) page, described below, you will see the host IP addresses upon which the jobs are running.

!!! Note

    The use of 'tenant' in short-names is adopted as a means to exploit Open OnDemand's use of filters to constrain certain apps to only be applicable to certain back-ends.

---

## Slurm job scheduler

[Slurm](https://slurm.schedmd.com) is an open source job scheduler and workload manager which is used by Open OnDemand to schedule and run jobs on back-ends.

!!! Note

    Unless using the [Job Composer](apps/job-composer.md) app, you should not have to worry about the details of how Slurm works. Open OnDemand's user interface and apps are designed to hide its details from users.

---

## Your `ondemand` directory

Within your home directory on the Open OnDemand host, Open OnDemand creates an `ondemand` directory. This is where Open OnDemand stores information about your current session and previous sessions.

Every time a job is created by an app, Open OnDemand creates the job files for the app in a job-specific **job context directory** in an app-specific directory.

[Job Composer](apps/job-composer.md) app job files are created in a directory:
```
ondemand/data/sys/myjobs/projects/default/JOB_ID/
```
where `JOB_ID` is a numerical identifier. For example,
```
ondemand/data/sys/myjobs/projects/default/1/
```

Interactive app job files are created in a directory:
```
ondemand/data/sys/dashboard/batch_connect/sys/APP_NAME/output/SESSION_ID/
```
where `APP_NAME` is the app name and `SESSION_ID` a unique session identifer. For example,
```
ondemand/data/sys/dashboard/batch_connect/sys/container_app/output/e0b9deeb-4b9c-43f8-ad3f-1c85074a1485/
```

!!! Warning

    Open OnDemand caches information within this `ondemand` directory including information on previous jobs and information you last entered within app forms. You can delete its contents - Open OnDemand will recreate it the next time you log in - but your history of previous jobs will be lost. However, you may find it useful to delete it occasionally if it grows too large.

---

## Distinct home directories

For most back-ends, your home directory is mounted both on the Open OnDemand host and the back-ends so your directories and files on the Open OnDemand host, and changes to these, are reflected on the back-ends and vice-versa.

However, you may have access to back-ends where your home directory is not mounted across both the Open OnDemand host and the back-end i.e., you have distinct, separate, home directories on each host.

Currently, the back-ends where home directories are not mounted across both Open OnDemand hosts and the back-ends are as follows:

* Superdome Flex, shs-sdf01.nsh.loc.
* DataLoch hosts, dap-gpu01.nsh.loc, dap-2021-009.nsh.loc, dap-2022-028.nsh.loc.

When using such back-ends, your `ondemand` directory, and so your job files, are automatically copied, to the back-end when you submit a job. How to enable this is described in the following section on [Enable copy of `ondemand` directory to a back-end](#enable-automated-copy-of-ondemand-directory-to-a-back-end).

If your job creates files on the back-end, you will have to log into these back-end to view your files. There is no automatic copy of files from these back-ends back to the Open OnDemand host.

### Enable automated copy of `ondemand` directory to a back-end

To enable Open OnDemand to automatically copy your `ondemand` directory to a back-end where your home directory is not mounted across both the Open OnDemand host and the back-end, you need to set up a passphrase-less SSH key between the Open OnDemand host and the back-end.

!!! Note

    Setting up SSH keys does **not** need to be done for back-ends where your home directory is mounted both on the Open OnDemand host and the back-ends.

Set up a passphrase-less SSH key between the Open OnDemand host and the back-end:

* Select **Clusters** menu, **Open OnDemand host Shell Access** option.
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

When a job is submitted to a back-end, a log file is created within an `ondemand-slurm-logs` directory within your home directory on the Open OnDemand host.

Log files have name `sbatch-YYYYMMDD-HHMMSS_OPEN_ONDEMAND_CLUSTER_NAME`. For example, `sbatch-20240807-082901-nsh_tenant_gpu_desktop01`.

An example of the contents of a log file is as follows:
```
# Open OnDemand back-end: OPEN_ONDEMAND_CLUSTER_NAME`
# Time: YYYY-MM-DD HH:MM:SS
# Process: PROCESS-ID
# Open OnDemand server environment
...values environment variables in current Open OnDemand environment...
# sbatch arguments from Open OnDemand
...arguments passed from Open OnDemand to 'sbatch' command which runs job...
```

!!! Note

    You should not have to concern yourself with the contents of these log files but they might prove useful if you need help with troubleshooting issues with running jobs via Open OnDemand.

!!! Tip

    You can safely delete these log files, if they're taking up too much space.

---

## What happens when a job is submitted

Briefly, when a job is submitted, the following occurs:

* Open OnDemand creates a job context directory under your `ondemand` directory.
    - For [Job Composer](apps/job-composer.md) app:
```
ondemand/data/sys/myjobs/projects/default/JOB_ID/
```
    - For interactive apps:
```
ondemand/data/sys/dashboard/batch_connect/sys/APP_NAME/output/SESSION_ID/
```
* Open OnDemand submits the job to the Slurm job scheduler to run the job on your chosen back-end.
    - A Slurm preprocessing step is used to create a log file in your `ondemand-slurm-logs` directory.
    - For back-ends where your home directory is not mounted across both the Open OnDemand host and the back-end, a Slurm preprocessing step automatically copies your `ondemand` directory to the back-end.
* Slurm queues your job, pending processing and memory resources on the back-end becoming available. The job status will be 'Queued'.
* When resources become available on the back-end, your job runs:
    - For jobs created via the [Job Composer](apps/job-composer.md), the job status will be 'Running'.
    - For jobs created via apps, the job status will be 'Starting' and then 'Running'.
* Your job will complete. The job status will be 'Completed'.

!!! Note

    The job status does not display whether a job that is 'Completed' did so with success or failure. Whether a job succeeded or failed can be seen in the job details for the job which can be seen via the [Active Jobs](apps/active-jobs.md) app.

---

## Browse and manage jobs

You can browse and manage jobs via the [Active Jobs](./apps/active-jobs.md) app.

For interactive app jobs (not those created by the [Job Composer](apps/job-composer) app), you can also use the [My Interactive Sessions](#my-interactive-sessions-page) page, which provides more app-specific information.

---

## My Interactive Sessions page

Click **My Interactive Sessions** (overlaid squares icon) on the menu bar to open the My Interactive Sessions page.

This page shows app-specific jobs that have been submitted, are running, or have completed. Each job has a [job card](#job-cards).

!!! Note

    Only information for jobs arising from what Open OnDemand terms 'interactive apps' is shown. All Container Execution Service apps are classed as 'interactive apps'. Information on jobs submitted by Open OnDemand's [Job Composer](apps/job-composer.md) are shown on that app's own page.

### Job cards

When an interactive app's job is submitted, a job card is created and shown with information about the app's job.

The job status, shown on the top-right of the job card, can be one of: 'Queued', 'Starting', 'Running', 'Held', 'Suspended', 'Completed', 'Undetermined'.

!!! Note

    The job status does not display whether a job that is 'Completed' did so with success or failure. Whether a job succeeded or failed can be seen in the job details for the job which can be seen via the [Active Jobs](apps/active-jobs.md) app.

### Open File Manager to job context directory

Click the **Session ID** link to open the [File Manager](./files.md), pointing at the job context directory for the job on the Open OnDemand host.

!!! Note

    When using a back-end where your home directory is not mounted across both the Open OnDemand host and the back-end, then, if your job creates files on the back-end, you will have to log into the back-end to view your files.

### Open SSH session to back-end on which job is running

For 'Running' jobs, click the **Host** link to open an SSH session with the back-end on which the job is running.

### Cancel a job

Click **Cancel** on a job card to cancel a running job.

### Relaunch a job

Click **Relaunch job** (circling arrows icon) on a job card to relaunch the job. A new session ID, and new set of job files, using the same configuration as for the previous run of the app, will be created.

### Delete a job card

Click **Delete** on a job card to delete the job card.

!!! Note

    Deleting a job card does not delete the associated job context directory from the `ondemand` directory.
