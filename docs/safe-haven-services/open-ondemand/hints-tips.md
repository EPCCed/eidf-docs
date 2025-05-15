# Open OnDemand hints and tips

## Troubleshooting: 'Cannot remove 'ondemand/data/sys/APP/.nfs'

If you delete your `ondemand` directory on the Open OnDemand host, you may see an error like the following:

```console
$ rm -rf ondemand/
rm: cannot remove 'ondemand/data/sys/myjobs/.nfs0000000601ac7ca000000002': Device or resource busy
```

The file is a system file held by a lingering process created by Open OnDemand as part of your session.

Within Open OnDemand, select '?' menu => 'Restart Web Server' to restart your Open OnDemand session, which ends the process and allows you to remove the file, and directory.
