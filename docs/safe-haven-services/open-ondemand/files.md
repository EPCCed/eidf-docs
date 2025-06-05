# Browse and manage files

---

## Introduction

Open OnDemand allows you to browse and manage files via the File Manager which can be accessed in various ways.

---

## File Manager

Select the **Files** menu, **Home Directory** option to open the File Manager.

You can browse your home directory and there are buttons to create new files and directories, upload or download files, copy or move files or directories and delete files or directories and to change directory.

!!! Note

    The File Manager only allows you to manipulate files on the Open OnDemand host. For most back-ends, your home directory is mounted both on the Open OnDemand host and the back-ends so your directories and files on the Open OnDemand host, and changes to these, are reflected on the back-ends and vice-versa. However, for some back-ends, this will not be the case - see [Distinct home directories](jobs.md#distinct-home-directories).

### **Open in Terminal**

Click **Open in Terminal** to open an SSH session with a specific host:

* The default is the first back-end you have access to in alphabetical order.
* To select a specific back-end, click the **Open in Terminal** button's **>** side-button to open a drop down-menu to allow you to choose a specific host.

Your SSH session will open and change your current directory to match that you selected in the File Manager.

#### Troubleshooting: 'cd ... No such file or directory'

If, when your SSH session begins, you see an error like:

```console
bash: line 1: cd: /home/user/ondemand: No such file or directory
```

then this means that the directory you are currently viewing in the File Manager on the Open OnDemand host is not available on the back-end.

This can arise if you select a back-end where your home directory is not mounted across both the Open OnDemand host and the back-end and you have not yet run a job on that back-end. See [Distinct home directories](jobs.md#distinct-home-directories) for back-ends this relates to.

---

## My Interactive Sessions page job cards and job context directory

Click **My Interactive Sessions** (overlaid squares icon) on the menu bar to open the My Interactive Sessions page.

On a job's job card, click the **Session ID** link to open the File Manager, pointing at the job context directory for the job on the Open OnDemand host.

---

## Active Jobs app and job context directory

Open the [Active Jobs](apps/active-jobs.md) app.

Click the **>** button, by the job of interest, to open the job details.

Click **Open in File Manager** to open the File Manager pointing at the job context directory for the job on the Open OnDemand host.

---

## Job Composer app and job context directory

Open the [Job Composer](apps/job-composer.md) app.

Select a job.

Click **Open Dir** or click **Edit Files** to open the File Manager pointing at the job context directory for the currently selected job.

---

## App **data root directory**

Within an app's form, click the **data root directory** link to open the File Manager pointing at the app directory, `ondemand/data/sys/dashboard/batch_connect/sys/APP_NAME/`, under which the job's files will be created.

### Troubleshooting: 'Error occurred when attempting to access ondemand/data/sys/dashboard/batch_connect/sys/APP_NAME'

If a dialog pops up with error:

'Error occurred when attempting to access /pun/sys/dashboard/files/fs/.../ondemand/data/sys/dashboard/batch_connect/sys/APP_NAME'

and

'Cannot read file /.../ondemand/data/sys/dashboard/batch_connect/sys/APP_NAME'

then click **OK**.

This error can arise if you have not used the app before and, so, its `APP_NAME` subdirectory will not exist under your `ondemand` folder.
