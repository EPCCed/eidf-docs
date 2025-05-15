# Open OnDemand user interface

The Open OnDemand user interface consists of a menu bar and an apps panel ('Jobs').

---

## Menu bar

'Apps' menu:

* 'Active Jobs' opens the [Active Jobs](apps/active-jobs.md) app.
* 'Job Composer' opens the [Job Composer](apps/job-composer.md) app.
* Links to apps shown on the ['Jobs' panel](#jobs-panel).
* 'All Apps' opens 'All apps' page which has a list of links to all the above apps above, any other available apps, plus one 'Shell Access' link for each back-end to which you have access (selecting an option opens a new browser tab with an SSH session to the back-end).

'Files' menu:

* 'Home Directory' opens the [File browser](#file-browser) pointing at your home directory on the Open OnDemand host.

'Jobs' menu:

* 'Active Jobs' opens the [Active Jobs](apps/active-jobs.md) app.
* 'Job Composer' opens the [Job Composer](apps/job-composer.md) app.
* Links to apps shown on the ['Jobs' panel](#jobs-panel).

'Clusters' menu:

* One option for each back-end to which you have access. Selecting an option open a new browser tab with an SSH session to the back-end.

'My Interactive Sessions (overlaid squares icon)' opens [My Interactive Sessions](#my-interactive-sessions).

'?' menu:

* 'Restart Web Server'. Despite its name, this option does not restart the whole Open OnDemand web server! Rather it restarts your personal session with Open OnDemand. If the Open OnDemand service or apps have been updated during your session, then this option allows you to access the changes. You won't need to log in again.

'Log Out' logs you out of Open OnDemand.

---

## 'Jobs' panel

The 'Jobs' panel has a selection of pinned apps. All available apps are shown on the 'All Apps' page (available via 'Apps' => 'All Apps').

* [Active Jobs](apps/active-jobs.md)
* [Job Composer](apps/job-composer.md)
* [Run Container](apps/container-app.md)
* [Run Jupyter Notebook](apps/jupyter-app.md)
* [Run RStudio](apps/rstudio-app.md)

---

## File browser

A page with a file browser that allows you to explore your home directory on the Open OnDemand host, including the job context directories.

'Open in Terminal' opens a new browser tab with an SSH session to a back-end. The default back-end is the first one in alphabetical order. Click '>' to see one option for each back-end to which you have access.

**Troubleshooting: 'Open in Terminal' 'cd ... No such file or directory'**

If you see 'cd ... No such file or directory' error after you have logged into the back-end, then this means that the directory you are currently viewing in the File browser is not in your home directory in the back-end. This can happen if your Open OnDemand home directory is not mounted onto the back-end (for example if using Superdome Flex) and your 'ondemand' directory is synchronised with the back-end when a job is submitted.

---

## Apps

Open OnDemand offers a number of apps which submit jobs to carry out various tasks.

---

## My Interactive Sessions

This page lists [job cards](#job-cards) for jobs created by the following apps:

* [Run Container](apps/container-app.md)
* [Run Jupyter Notebook](apps/jupyter-app.md)
* [Run RStudio](apps/rstudio-app.md)
