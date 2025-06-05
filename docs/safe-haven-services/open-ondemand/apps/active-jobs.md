# Active Jobs

Active Jobs is an Open OnDemand app that allows you to browse and manage jobs created via both apps and the [Job Composer](job-composer.md) app.

The Active Jobs app shows a table of running and recently completed jobs.

---

## Jobs table

The job ID is a unique job ID created by the Slurm job scheduler, when you submitted the job.

!!! Note

    The job ID is not the same as the session ID for an app. The latter is an identifier created by Open OnDemand itself. Each job created by an app will have both an Open OnDemand session ID and a Slurm job ID.

The job status can be one of: 'Queued', 'Running', 'Hold', 'Suspend', 'Completed', 'Undetermined'.

!!! Note

    The job status does not display whether a job that is 'Completed' did so with success or failure. Whether a job succeeded or failed can be seen in the job details for the job.

---

## Job details

To see details about a job, click the **>** button, by the job of interest.

The 'Output Location' is the location of the job context directory for the job on the Open OnDemand host.

---

## Open File Manager to job context directory

Click **Open in File Manager** to open the [File Manager](../files.md) pointing at the job context directory for the job on the Open OnDemand host.

---

## Log into to back-end on which job is running

Click **Open Terminal** to log into the back-end on which the currently selected job will be run. Once logged in, your current directory will be changed to match the job context directory.

---

## Cancel a job

Click the **Delete job** (red trash icon) by the job in the job table or click **Delete** in the job details to cancel (delete) a running job.
