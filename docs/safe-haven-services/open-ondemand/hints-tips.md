# Open OnDemand hints and tips

---

## Troubleshooting: 'Cannot remove 'ondemand/data/sys/APP/.nfs'

If you delete your `ondemand` directory on the Open OnDemand host, you may see an error like the following:

```console
$ rm -rf ondemand/
rm: cannot remove 'ondemand/data/sys/myjobs/.nfs0000000601ac7ca000000002': Device or resource busy
```

The file is a system file held by a lingering process created by Open OnDemand as part of your session.

Within Open OnDemand, select the 'Help (?)' menu, 'Restart Web Server' option to restart your Open OnDemand session, which ends the process and allows you to remove the file, and directory.

---

## Find number of processors and cores available on a back-end

You can find the number of processors available on a back-end by logging into the back-end and running one of the following commands which count the number of occurrences of the terms in the `/proc/cpuinfo` file which gives the number of processors and cores available.

```console
$ cat /proc/cpuinfo | grep processor | wc -l
8
$ cat /proc/cpuinfo | grep 'core id' | wc -l
8
```

This back-end has 8 processors and 8 cores.

---

## Find memory available on a back-end

You can find the total memory available on a back end by logging into the back-end and running the following command:

```console
$ free -h
               total        used        free      shared  buff/cache   available
Mem:           125Gi       5.2Gi       6.0Gi       140Mi       114Gi       119Gi
Swap:             0B          0B          0B
```

This back-end has 125 Gib memory in total.
