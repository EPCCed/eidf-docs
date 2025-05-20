# Open OnDemand portal

Here, we describe what you can do using Open OnDemand.

---

## View apps

The following apps are available on OpenOnDemand.

| App | Type | Description |
| --- | ---- | ----------- |
| [Active Jobs](apps/active-jobs.md) | System Installed App | Open OnDemand app that allows you to browse and manage jobs created via both apps and the 'Job Composer' app |
| [Job Composer](apps/job-composer.md) | System Installed App | Open OnDemand app that allows you to submit a Slurm batch job to a back-end |
| [Run Jupyter Notebook](apps/jupyter-app.md) | Tenant Service | Container Execution Service app that allows you to run a Jupyter Notebook container on a back-end |
| [Run RStudio](apps/rstudio-app.md) | Tenant Service | Container Execution Service app that allows you to run an RStudio container on a back-end |
| [Run Container](apps/container-app.md) | Tenant and HPC Service | Container Execution Service app that allows you to run a container on a back-end |

The app types are:

* 'System Installed App': apps provided with Open OnDemand.
* 'Tenant Service': apps to run jobs on back-ends within your safe haven.
* 'Tenant and HPC Service': apps to run jobs on back-ends within both your safe haven and on TRE-level resources.

Open OnDemand supports a number of ways by which you can see the apps available to you and select an app to run.

In each case, selecting an app will open an app-specific page.

### 'Jobs' panel

The 'Jobs' panel on the Open OnDemand front page has a selection of the apps available to you.

Click on a app button to access that app.

### 'Apps' menu

The 'Apps' menu provides access to all the apps available to you.

Select an app-specific menu option to access that app. The app-specific menu options correspond to the apps available via the 'Jobs' panel.

To see all apps available to you, select the 'All Apps' option to go to the All Apps page.

### 'Jobs' menu

The 'Jobs' menu shows all apps available to you.

Select an app-specific menu option to access that app.

!!! Note

    If you are wondering why the 'Apps' menu and 'Jobs' menu overlap, this is because each app has a 'category' label. This is used by Open OnDemand both to group app buttons on the front page and to create menus with apps belonging to a specific category. All our apps are within a 'Jobs' category, hence the overlap.

### All Apps page

The All Apps page shows all the apps available to you.

Select the 'Apps' menu, 'All Apps' option to go to the All Apps page.

Click an app-specific link to access that app.

### My Interactive Sessions page apps list

Click 'My Interactive Sessions' (overlaid squares icon) on the menu bar to opens the My Interactive Sessions page.

The My Interactive Sessions page has a selection of the apps available to you on the left-hand-side.

Click an app-specific button to access that app.

---

## Browse and manage jobs

### My Interactive Sessions page

Click 'My Interactive Sessions' (overlaid squares icon) on the menu bar to open the My Interactive Sessions page.

This page shows app-specific jobs that have been submitted, are running, or have completed. Each job has a [job card](#job-card).

!!! Note

    Only information for jobs arising from what Open OnDemand terms 'interactive apps' is shown. All Container Execution Service apps are classed as 'interactive apps'. Information on jobs submitted by Open OnDemand's [Job Composer](apps/job-composer.md) are shown on that app's own page.

#### Job card

When an interactive app's job is submitted, a job card is created and shown with information about the app's job.

The job status, shown on the top-right of the job card, can be one of: 'Queued', 'Starting', 'Running', 'Held', 'Suspended', 'Completed', 'Undetermined'.

!!! Note

    The job status does not display whether a job that is 'Completed' did so with success or failure. Whether a job succeeded or failed can be seen in the job details for the job which can be seen via the [Active Jobs](apps/active-jobs.md) app.

#### Open File Manager to job context directory

Click the 'Session ID' link to open the File Manager, pointing at the job context directory for the job on the Open OnDemand host.

!!! Note

    When using a back-end where your home directory is not mounted across both the Open OnDemand host and the back-end, then, if your job creates files on the back-end, you will have to log into the back-end to view your files.

#### Open SSH session to host on which job is running

For 'Running' jobs, click the 'Host' link to open an SSH session with the host on which the job is running.

#### Cancel a job

Click 'Cancel' on a job card to cancel a running job.

#### Relaunch a job

Click 'Relaunch job' (circling arrows icon) on a job card to relaunch the job. A new session ID, and new set of job files, will be created.

#### Delete a job card

Click 'Delete' on a job card to delete the job card.

### Active Jobs app

The 'Active Jobs' app allows you to browse and manage jobs created via both apps and the [Job Composer](apps/job-composer.md) app.

---

## Browse and manage files

Open OnDemand allows you to browse and manage files via the File Manager.

### File Manager

Select the 'Files' menu, 'Home Directory' option to open the File Manager.

You can browse your home directory and there are buttons to create new files and directories, upload or download files, copy or move files or directories and delete files or directories and to change directory.

!!! Note

    The File Manager only allows you to manipulate files on the Open OnDemand host. For most back-ends, your home directory is mounted both on the Open OnDemand host and the back-ends so your directories and files on the Open OnDemand host, and changes to these, are reflected on the back-ends and vice-versa. However, for some back-ends, this will not be the case - see [Distinct home directories](jobs.md#distinct-home-directories).

#### 'Open in Terminal'

Click 'Open in Terminal' to open an SSH session with a specific host:

* The default is the first back-end you have access to in alphabetical order.
* To select a specific back-end, click the 'Open in Terminal' button's '>' side-button to open a drop down-menu to allow you to choose a specific host.

Your SSH session will open and change your current directory to match that you selected in the File Manager.

#### Troubleshooting: 'Open in Terminal' 'cd ... No such file or directory'

If, when your SSH session begins, you see an error like:
```
bash: line 1: cd: /home/user/ondemand: No such file or directory
```
then this means that the directory you are currently viewing in the File Manager on the Open OnDemand host is not available on the back-end.

This can arise if you select a back-end where your home directory is not mounted across both the Open OnDemand host and the back-end and you have not yet run a job on that back-end. See [Distinct home directories](jobs.md#distinct-home-directories) for back-ends this relates to.

### My Interactive Sessions page job cards and job context directory

Click 'My Interactive Sessions' (overlaid squares icon) on the menu bar to open the My Interactive Sessions page.

On a job's job card, click the 'Session ID' link to open the File Manager, pointing at the job context directory for the job on the Open OnDemand host.

### 'Active Jobs' app and job context directory

Open the [Active Jobs](apps/active-jobs.md) app.

Click the '>' button, by the job of interest, to open the job details.

Click 'Open in File Manager' to open the File Manager pointing at the job context directory for the job on the Open OnDemand host.

### App 'data root directory'

Within an app's form, click the 'data root directory' link to open the File Manager pointing at the app directory, `ondemand/data/sys/dashboard/batch_connect/sys/APP_NAME/`, under which the job's files will be created.

#### Troubleshooting: 'Error occurred when attempting to access ondemand/data/sys/dashboard/batch_connect/sys/APP_NAME'

If a dialog pops up with error:

'Error occurred when attempting to access /pun/sys/dashboard/files/fs/.../ondemand/data/sys/dashboard/batch_connect/sys/APP_NAME'

and

'Cannot read file /.../ondemand/data/sys/dashboard/batch_connect/sys/APP_NAME'

then click 'OK'.

This error can arise if you have not used the app before and, so, it's `APP_NAME` subdirectory will not exist under your `ondemand` folder.

---

## Open an SSH session to a back-end or the Open OnDemand host

Open OnDemand supports a number of ways by which you can open an SSH session to a back-end or the Open OnDemand host (if applicable).

In each case, a new browser tab will open with an SSH session for the selected host.

When prompted, enter your project username and password.

!!! Note

    If you see 'Open OnDemand host Shell Access' listed, then you can log into the Open OnDemand host. This is supported for users who have access to back-ends where user home directories are not mounted across both the Open OnDemand host and those back-ends.

### 'Clusters' menu

The 'Clusters' menu lists every back-end to which you have access, and the Open OnDemand host (if applicable).

Select a host-specific menu option to open an SSH session with the selected host.

When prompted, enter your project username and password.

### All Apps page cluster apps

Select the 'Apps' menu, 'All Apps' option to go to the All Apps page.

The 'All apps' page lists every back-end to which you have access, and the Open OnDemand host (if applicable).

Click a host-specific 'Shell Access' link to open an SSH session with the selected host.

### File Manager 'Open in Terminal' button

Select the 'Files' menu, 'Home Directory' option to open the File Manager, then click ['Open in Terminal'](#open-in-terminal).

### My Interactive Sessions page job cards and hosts on which jobs are running

Click 'My Interactive Sessions' (overlaid squares icon) on the menu bar to open the My Interactive Sessions page.

On a 'Running' job's job card, click the 'Host' link to open an SSH session with the host on which the job is running.

### 'Active Jobs' app and hosts on which jobs are running or ran

Open the [Active Jobs](apps/active-jobs.md) app.

Click the '>' button, by the job of interest, to open the job details.

Click 'Open in Terminal', to open an SSH session with the host on which the job is running. Your SSH session change your current directory to match the job context directory.

---

## Restart your Open OnDemand session

Select the 'Help (?)' menu, 'Restart Web Server' option to restart your Open OnDemand session.

!!! Note

    Despite its name, this option does not restart the Open OnDemand web server! It restarts your session only. It does not affect other users!

!!! Tip

    If the Open OnDemand service or apps have been updated during your session, then 'Restart Web Server' allows you to pick up such changes without having to log out and log back into Open OnDemand,

---

## Display your log in name

Click 'Avatar' (head and shoulders icon) on the menu bar to display your log in name e.g., 'Logged in as some-user'.

---

## Log out

Click 'Log Out' button (right arrow icon) on the menu bar to log out of Open OnDemand.
