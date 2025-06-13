# Open OnDemand hints and tips

---

## Find number of processors and cores available on a back-end

You can find the number of processors available on a back-end by logging into the back-end and running one of the following commands which count the number of occurrences of the terms in the `/proc/cpuinfo` file which gives the number of processors and cores available.

```bash
$ cat /proc/cpuinfo | grep processor | wc -l
8
$ cat /proc/cpuinfo | grep 'core id' | wc -l
8
```

This back-end has 8 processors and 8 cores.

---

## Find memory available on a back-end

You can find the total memory available on a back end by logging into the back-end and running the following command:

```bash
$ free -h
               total        used        free      shared  buff/cache   available
Mem:           125Gi       5.2Gi       6.0Gi       140Mi       114Gi       119Gi
Swap:             0B          0B          0B
```

This back-end has 125 Gib memory in total.

---

## Troubleshooting 'sbatch: error: Memory specification can not be satisfied'

If, on submitting a job you get an error:

> Failed to submit session with the following error:
>
> ```text
> sbatch: error: Memory specification can not be satisfied
> sbatch: error: Batch job submission failed: Requested node configuration is not available
> ```

then this can arise if you have requested more memory for your job than is available on the back-end.

---

## Troubleshooting: Job stays in 'Queued' state

A job may stay in a 'Queued' state for the following reasons:

* You requested more CPUs/cores than are available on the back-end. If this is the case, then you need to cancel the job and resubmit it, requesting a number of CPUs/cores that the back-end can provide.
* You requested a number of CPUs/cores and/or memory that is available on the back-end, but those resources are not available at the moment due to other users' jobs. Your job will remain 'Queued' until one or more of the other users' jobs complete and resources are available for your job. You can see if this is the case via the [Job details](./apps/active-jobs.md#job-details) in the [Active Jobs](./apps/active-jobs.md). If so then your job state will be one of:
    * 'State: PENDING', 'Reason: Resources': your job is waiting for resources, and when these are available your job will run.
    * 'State: PENDING', 'Reason: Priority': your job is waiting for resources, but there are are other jobs ahead of yours.

---

## Troubleshooting: 'Cannot remove 'ondemand/data/sys/APP/.nfs'

If you delete your `ondemand` directory on the Open OnDemand host, you may see an error like the following:

```bash
$ rm -rf ondemand/
rm: cannot remove 'ondemand/data/sys/myjobs/.nfs0000000601ac7ca000000002': Device or resource busy
```

The file is a system file held by a lingering process created by Open OnDemand as part of your session.

Within Open OnDemand, select the 'Help (?)' menu, 'Restart Web Server' option to restart your Open OnDemand session, which ends the process and allows you to remove the file, and directory.
