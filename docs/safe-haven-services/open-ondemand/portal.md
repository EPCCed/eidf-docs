# Open OnDemand portal

Here, we describe the key parts of the Open OnDemand's portal.

---

## 'Jobs' panel

The 'Jobs' panel has buttons for a subset of the apps available to you to run jobs on back-ends. The pinned apps include:

| App | Description |
| --- | ----------- |
| [Active Jobs](apps/active-jobs.md) | Open OnDemand app that shows a list of jobs submitted via Open OnDemand to back-ends |
| [Job Composer](apps/job-composer.md) | Open OnDemand app that allows you to submit a Slurm batch job to a back-end |
| [Run Jupyter Notebook](apps/jupyter-app.md) | Container execution service app that allows you to run a Jupyter Notebook container on a back-end |
| [Run RStudio](apps/rstudio-app.md) | Container execution service app that allows you to run an RStudio container on a back-end |
| [Run Container](apps/container-app.md) | Container execution service app that allows you to run a container on a back-end |

Click on a app button to access that app.

!!! Tip

    To see all apps available to you, select the 'Apps' => 'All Apps' menu item to take you to the [All Apps](#all-apps-page) page.

---

## Menu bar

### 'Apps' menu

The 'Apps' menu provides access to all the apps available to you.

Select an app-specific menu items to access that app. The app-specific menu items correspond to the apps available via buttons on the front page.

To see all apps available to you, select the 'All Apps' menu item to take you to the [All Apps](#all-apps-page) page.

### 'Files' menu

The 'Files' menu provides access to your files that are on the Open OnDemand host.

Select 'Home Directory' to open the [File Browser](#file-browser-page) to access your home directory on the Open OnDemand host.

### 'Jobs' menu

The 'Jobs' menu provides access to apps available to you.

Select an app-specific menu items to access that app.

!!! Note

    If you are wondering why the 'Apps' menu and 'Jobs' menu overlap, this is because each app has a 'category' label. This is used by Open OnDemand both to group app buttons on the front page and to create menus with apps belonging to a specific category. All our apps are within a 'Jobs' category, hence the overlap.

### 'Clusters' menu

The 'Clusters' menu allows you to start an SSH session with a back-end (cluster) to which you have access.

!!! Note

    If you see and 'Open OnDemand host Shell Access' menu item, then you can log into the Open OnDemand host. This is supported for users who have access to back-ends where user home directories are not mounted across both the Open OnDemand host and those back-ends.

Select a back-end-specific menu item to open a new browser tab with an SSH session for a specific back-end, or the Open OnDemand host (if applicable).

When prompted, enter your project username and password. These are the same username and password that you used when logging into your safe haven host.

### 'My Interactive Sessions' menu

The 'My Interactive Sessions' menu (overlaid squares icon) opens the [My Interactive Sessions](#my-interactive-sessions-page) page with information on app-specific jobs that have been submitted, are running, or have completed.

### 'Help (?)' menu

Click 'Restart Web Server' to restart your Open OnDemand session.

!!! Note

    Despite its name, this option does not restart the Open OnDemand web server! It restarts your session only. It does not affect other users!

!!! Tip

    If the Open OnDemand service or apps have been updated during your session, then 'Restart Web Server' allows you to pick up such changes without having to log out and log back into Open OnDemand,

### 'Avatar' button

Click the 'Avatar' button (head and shoulders icon) to display your log in name e.g., 'Logged in as some-user'.

### 'Log Out' button

Click the 'Log Out' button (right arrow icon) to log out of Open OnDemand.

---

## 'File Browser' page

The 'File Browser' page provides access to your home directory on the Open OnDemand host.

You can browse your home directory and there are buttons to create new files and directories, upload or download files, copy or move files or directories and delete files or directories and to change directory.

### 'Open in Terminal' button

Click the 'Open in Terminal' button to open a new browser tab with an SSH session to a back-end to which you have access. The default is the first back-end you have access to in alphabetical order.

To select a specific back-end, click the 'Open in Terminal' button's '>' side-button to open a drop down-menu to allow you to choose a back-end.

When prompted, enter your project username and password. These are the same username and password that you used when logging into your safe haven host.

Your SSH session will open and change your current directory to match that you selected in the 'File Browser'.

**Troubleshooting: 'Open in Terminal' 'cd ... No such file or directory'**

If, when your SSH session begins, you see an error like:
```
bash: line 1: cd: /home/user/ondemand: No such file or directory
```
then this means that the directory you are currently viewing in the File Browser on the Open OnDemand host is not available on the back-end.

This can arise if you select a back-end where your home directory is not mounted across both the Open OnDemand host and the back-end and you have not yet run a job on that back-end.

At present, this can arise for the back-ends:

* Superdome Flex.
* DataLoch back-ends.

---

## 'All Apps' page

The 'All apps' page lists every app to which you have access plus every back-end (cluster) to which you have access, and the Open OnDemand host (if applicable).

Click an app-specific link to access that app.

Click a back-end-specific 'Shell Access' link to open a new browser tab with an SSH session for a specific back-end, or the Open OnDemand host (if applicable).

----

## 'My Interactive Sessions' page

The 'My Interactive Sessions' page has information, 'job cards', for each app-specific job run. For more information, see [job cards](jobs.md#job-cards).

!!! Note

    Only information for jobs arising from what Open OnDemand terms 'interactive apps' is shown. All container execution service apps are classed as 'interactive apps'. Information on jobs submitted by Open OnDemand's [Job Composer](apps/job-composer.md) are shown on that app's own page.
