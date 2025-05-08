# Job Composer

Job Composer is an Open OnDemand app that allows you to submit Slurm batch jobs to any back-end to which you have access.

A list of existing jobs, if any, are shown.

To create a new job, select 'New Job':

* 'From Default Template' creates a 'hello world' job.
* 'From Template' creates a 'hello world' job. As there is only one template, this offers the same option as 'From Default Template'.
* 'From Specified Path' creates a new job from the contents of an existing directory. This directory should have the job submission script and any other files within it.
* 'From Selected job' creates a new job from the contents of the job context directory for the currently selected job on the page, if any.

When a job is created, the job files are written to the job context directory, `$HOME/ondemand/data/sys/myjobs/projects/default/<JOB_ID>/`.

Clicking on a job shows details about the job on the same page.

Both 'Edit Files' and 'Open Dir' open the [File browser](../user-interface.md#file-browser) pointing at the job context directory on the Open OnDemand host for the currently selected job.

'Job Options' opens up a form where you can edit the job name, target back-end, Slurm job submission script, account and other options.

'Open Terminal' opens an SSH session into the job context directory for the job on the back-end.

'Open Editor' opens an editor to allow editing of the Slurm job submission script.

Clicking on a file name under 'Folder Contents' opens an editor to allow editing of the selected file.

'Templates' opens a page that allows you to browse and copy existing job templates. You can then customise these templates and use these templates when creating jobs in future. Job templates are copied into your 'ondemand' directory, under `$HOME/ondemand/data/sys/myjobs/templates`. A template-specific subdirectory name is derived from the job name in the source template, converted to lower snake_case (e.g., job name '(default) Simple Sequential Slurm Job' gives directory name 'default_simple_sequential_slurm_job').

For back-ends which do not mount your home directory onto both the Open OnDemand host and back-end, any files created on as a result of running a job are **not** synchronised with the Open OnDemand host. If you want to browse any files created when running a job you need to SSH into that back-end (either via Open OnDemand which is supported from a number of places within the user interface or by other means).

**Troubleshooting: 'Open in Terminal' 'cd ... No such file or directory'**

If you see 'cd ... No such file or directory' error after you have logged into the back-end, then this means that the directory you are currently viewing in the File browser is not in your home directory in the back-end. This can happen if your Open OnDemand home directory is not mounted onto the back-end (for example if using Superdome Flex) and your 'ondemand' directory is synchronised with the back-end when a job is submitted.
