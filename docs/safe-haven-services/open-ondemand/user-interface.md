# Open OnDemand user interface

Here, we describe the key parts of the Open OnDemand user interface.

---

## 'Jobs' panel

The 'Jobs' panel has buttons for a subset of the apps available to you to run specific jobs on back-ends. The pinned apps include:

| App | Description |
| --- | ----------- |
| [Active Jobs](apps/active-jobs.md) | Open OnDemand app that shows a list of active jobs submitted via Open OnDemand |
| [Job Composer](apps/job-composer.md) | Open OnDemand app that allows you to submit Slurm batch jobs to any back-end to which you have access |
| [Run Jupyter Notebook](apps/jupyter-app.md) | Container execution service app that allows you to run a Jupyter Notebook container on a back-end |
| [Run RStudio](apps/rstudio-app.md) | Container execution service app that allows you to run an RStudio container on a back-end |
| [Run Container](apps/container-app.md) | Container execution service app that allows you to run an RStudio container on a back-end |

Click on a app button to be taken to a page allowing you run that app's job.

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

Select 'Home Directory' to open the [File browser](#file-browser-page) to access your home directory on the Open OnDemand host.

### 'Jobs' menu

The 'Jobs' menu provides access to apps available to you.

Select an app-specific menu items to access that app.

!!! Note

    If you are wondering why the 'Apps' menu and 'Jobs' menu overlap, this is because each app has a 'category' label. This is used by Open OnDemand both to group app buttons on the front page and to create menus with apps belonging to a specific category. All our Open OnDemand apps are within a 'Jobs' category, hence the overlap.

### 'Clusters' menu

The 'Clusters' menu allows you to start an SSH session with a back-end (or cluster) to which you have access.

Select a back-end-specific menu item to open a new browser tab with an SSH session for that back-end.

When prompted, enter your project username and password. These are the same username and password that you used when logging into your safe haven host.

### 'My Interactive Sessions' menu

The 'My Interactive Sessions' menu (overlaid squares icon) opens the [My Interactive Sessions](#my-interactive-sessions-page) page with information on each app run.

### 'Help (?)' menu

Click 'Restart Web Server' to restart your Open OnDemand session.

!!! Note

    Despite its name, this option does not restart the Open OnDemand web server! It restarts your session only. It does not affect other users!

!!! Tip

    If the Open OnDemand service or apps have been updated during your session then then 'Restart Web Server' allows you to pick up such changes without having to log out and log back into Open OnDemand,

### 'Avatar' button

Click the 'Avatar' button (head and shoulders icon) to display your log in name e.g., 'Logged in as some-user'.

### 'Log Out' button

Click the 'Log Out' button (right arrow icon) to log out of Open OnDemand.

---

## 'File browser' page

The 'File browser' page provides access to your home directory on the Open OnDemand host.

You can browse your home directory and there are buttons to create new files and directories, upload or download files, copy or move files or directories and delete files or directories and to change directory.

### 'Open in Terminal' button

Click the 'Open in Terminal' button to open a new browser tab with an SSH session to a back-end to which you have access. The default is the first back-end you have access to in alphabetical order.

To select a specific back-end, click the 'Open in Terminal' button's '>' side-button to open a drop down-menu to allow you to choose a back-end.

When prompted, enter your project username and password. These are the same username and password that you used when logging into your safe haven host.

Your SSH session will open in the currently selected directory in the 'File browser'.

**Troubleshooting: 'Open in Terminal' 'cd ... No such file or directory'**

TODO
TODO double check on 031
TODO

If, when your SSH session begins, you see the error `cd ... No such file or directory`, then this means that the directory you are currently viewing in the File browser on the Open OnDemand host is not available on the back-end.

This can arise if you select a back-end where your home directory is not mounted across both the Open OnDemand host and the back-end and you have not yet run an app on that back-end.

At present, this can arise for the back-ends:

* Superdome Flex.
* DataLoch back-ends.

---

## 'All Apps' page

TODO

The 'All apps' page which has a list of links to all the above apps above, any other available apps, plus one 'Shell Access' link for each back-end to which you have access (selecting an option opens a new browser tab with an SSH session to the back-end).

Select an app-specific menu items to access that app. The app-specific menu items correspond to the apps available via buttons on the front page.

----

## 'My Interactive Sessions' page

TODO

The 'My Interactive Sessions' menu (overlaid squares icon) opens the [My Interactive Sessions](#my-interactive-sessions-page) page with information each app run.

Select an app-specific menu items to access that app. The app-specific menu items correspond to the apps available via buttons on the front page.

This page lists [job cards](jobs.md#job-cards) for jobs created by the following apps:

TODO

All but Active Jobs and Job Composter
