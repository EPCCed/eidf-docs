# Active Jobs

'Active Jobs' is an Open OnDemand app that shows a list of active jobs submitted via Open OnDemand.

The 'Status' in the active job table can be one of: 'Queued', 'Running', 'Hold', 'Suspend', 'Completed', 'Undetermined'.

!!! Note

    The table does not display whether a job that is 'Completed' did so with success or failure. However, the job details does show that information.

To see more details about a job, click the '>' button.

The view can be altered as follows:

* 'All Jobs' toggles between 'All Jobs' and 'Your Jobs'.
* 'All Clusters' toggles between 'All Clusters' (back-ends) or a specific back-end to which you have access.

For each job:

* 'Open in File Manager' opens the [File browser](../user-interface.md#file-browser) pointing at the job context directory on the Open OnDemand host for the job. For example:
```
$HOME/ondemand/data/sys/myjobs/projects/default/<JOB_ID>/
$HOME/ondemand/data/sys/dashboard/batch_connect/sys/<app_name>/output/<SESSION_ID>/
```
* 'Open in File Terminal' opens a new browser tab with an SSH session into the job context directory for the job on the back-end.
* 'Delete' cancels the selected job if it is running.
