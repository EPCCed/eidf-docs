# Greetings

Greetings is a 'getting started' app for new users of Open OnDemand that writes a greetings file on a back-end.

---

## Run the app

Complete the following information the app form:

* **Cluster**: A back-end (cluster) within your safe haven on which to run the app. Back-end-specific short-names are used in the drop-down list (see [Back-end (cluster) names](../jobs.md#back-end-cluster-names) for more information). If there is only one back-end available to you then this form field won't be shown.

    !!! Note

        **National Safe Haven users**: If using a 'desktop' back-end, then you must select the 'desktop' you have been granted access to.

* **Greetings file destination**: Where to write the greetings file to. Select one of:

    * '/safe_data/PROJECT_DIRECTORY/': If selected, then the app will write a greetings file, `YYYYMMDD-HHMMSS-USER-greetings.txt` into your 'safe data' directory on the back-end.

        Your 'safe data' directory is chosen to be the first `/safe_data/PROJECT_DIRECTORY` subdirectory found where `PROJECT_DIRECTORY` shares its name with one of the your user groups. For example, if you are a member of a user group `your-project` and there is a `/safe_data/your-project` directory, then that is the directory into which the file is written.

    * '$HOME': If selected, then the app will write a greetings file, `YYYYMMDD-HHMMSS-USER-greetings.txt` into your home directory on the back-end.

Click **Launch**.

Open OnDemand will create job files for the app in a job-specific job context directory in an app-specific directory under your `ondemand` directory and then submits the job for the app to the job scheduler.

Open OnDemand will show an app job card with information about the app's job including:

* Job status (on the top right of the job card): initially 'Queued'.
* 'Created at': The time the job was submitted.
* 'Time Requested': The runtime requested for the job.
* 'Session ID': An auto-generated value which is used as the name of the job-specific job context directory.

When the job starts, the Job status on the job card will update to 'Starting' and 'Time Requested' will switch to 'Time Remaining', the time your job has left to run before it is cancelled by the job scheduler.

When the Job status updates to 'Running', a **Host** link will appear on the job card. This is the back-end on which the job is now running. A message of form 'Writing file FILE on HOST' will also appear on the job card.

When the job completes, the Job status on the job card will update to 'Completed'. A message of form 'Wrote file FILE on HOST' will also appear on the job card.

---

## View the greetings file

The greetings file includes your user name, the back-end host name and a date and time. For example:

```text
Greetings!

Greetings to your-user
from
some-vm.nsh.loc
at
2026-06-09 10:09:10
```

### 'Greetings file destination': '/safe_data/PROJECT_DIRECTORY/'

`/safe_data` is not available on Open OnDemand host. To view the greetings file:

1. Select **Clusters** menu, back-end **Shell Access** option, to log into the back-end.
1. View the greetings file:

     ```bash
     ls /safe_data/PROJECT_DIRECTORY/
     cat /safe_data/PROJECT_DIRECTORY/YYYYMMDD-HHMMSS-USER-greetings.txt
     ```

     For example:

     ```bash
     ls /safe_data/your-project
     cat /safe_data/your-project/20260609-100910-your-user-greetings.txt
     ```

### 'Greetings file destination': '$HOME'

For most back-ends, your home directory is common to both the Open OnDemand VM and the back-ends so any files created within your home directory on a back-end will be available on the Open OnDemand VM, and vice-versa.

View the greetings file via the Open OnDemand File Manager:

1. Click the **Session ID** link in the job card to open the File Manager, pointing at the job context directory for the job on the Open OnDemand VM.
1. Click **Home Directory**.
1. Click on the greetings file, `YYYYMMDD-HHMMSS-USER-greetings.txt` e.g., `20260609-100910-your-user-greetings.txt`.

For back-ends where your home directory is not common to both the Open OnDemand VM and the back-end, the File Manager cannot be used. An alternative to the File Manager is to log in to the back-end and view the files there, which can be done for any back-end.

View the greetings file within the back-end:

1. Select **Clusters** menu, back-end **Shell Access** option to log into the back-end.
1. View the greetings file:

     ```bash
     cat YYYYMMDD-HHMMSS-USER-greetings.txt
     ```

     For example:

     ```bash
     cat 20260609-100910-your-user-greetings.txt
     ```

---

## Troubleshooting: Something went wrong. Please check the app's 'output.log' file

As described in [Job cards](../jobs.md#job-cards), app job cards will only show such jobs as having 'Completed'. Whether a job succeeded or failed can be seen in the job details for the job which can be seen via the [Active Jobs](./active-jobs.md) app.

However, this app is simple enough to allow for this error message to be displayed on the job card.

In cases where there are errors in inferring or accessing your 'safe data' directory, then the `output.log` log file for the app's job, in the job context directory, `ondemand/data/sys/dashboard/batch_connect/sys/batch_container_app/output/SESSION_ID`, will include a message like one of the following:

```text
Mon Jun  8 12:55:44 UTC 2026 before.sh ERROR: Cannot find a project directory corresponding to any of the user's groups
```

```text
Mon Jun  8 12:55:44 UTC 2026 before.sh ERROR: Cannot read from /safe_data/your-project
```

```text
Mon Jun  8 12:55:44 UTC 2026 before.sh ERROR: Cannot write to /safe_data/your-project
```

If this problem occurs, then please contact your Research Coordinator (or equivalent).

---

## View job files

On a job's job card, click the **Session ID** link to open the [File Manager](../files.md), pointing at the job context directory for the job on the Open OnDemand VM.

!!! Note

    When using a back-end where your home directory is not common to both the Open OnDemand VM and the back-end, then, if your job creates files on the back-end, you will have to log into the back-end to view your files - see [Log into back-ends](../ssh.md).

---

## Log into back-end

While the job is running, click the **Host** link to log into to back-end on which the job is running.

If the job has completed, see [Log into back-ends](../ssh.md) for ways to log into the back-end.

---

## App job name

Within the job scheduler, and the [Active Jobs](./active-jobs.md) app, this app's jobs are named 'greetings_app'.

---

## End your job

You can end your job early as follows:

* Cancel or delete the job via Open OnDemand. See [Browse and manage jobs](../jobs.md#browse-and-manage-jobs).
