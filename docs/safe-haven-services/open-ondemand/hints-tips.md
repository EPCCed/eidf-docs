# Open OnDemand hints and tips

## Troubleshooting: 'Cannot remove 'ondemand/data/sys/APP/.nfs'

If you delete your `ondemand` directory on the Open OnDemand host, you may see a filure to delete a system file:

```console
$ rm -rf ondemand/
rm: cannot remove 'ondemand/data/sys/myjobs/.nfs0000000601ac7ca000000002': Device or resource busy
```

This can be due to a lingering Open OnDemand process from your session.

Within Open OnDemand, select '?' menu => 'Restart Web Server' to restart your Open OnDemand session, ending the lingering process.
