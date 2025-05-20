# Open OnDemand portal

Here, we describe what you can do using Open OnDemand.

---

[Browse and manage files](./files.md)

[Open an SSH session](./ssh.md)

[Run jobs](./jobs.md)

[View and access apps](./apps.md)

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
