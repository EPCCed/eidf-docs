## Storage in the Secure Virtual Desktop Service

The EIDF Secure Virtual Desktop Service provides options for privaliged users to store and transfer data securely to and from the Secure Virtual Desktop VMs.

## Encrypted S3 Storage

The Secure Virtual Desktop service allows users to transfer data using EIDF S3 buckets, by default all buckets except for one with the project name are disabled, specific buckets can be added to enable data ingres and egress from the machine.

To use S3 storage with Secure Virtual Desktop VMs, users must first create an S3 repo in the EIDF Portal, and then a bucket within this repo that will be accessible from the Secure Virtual Desktop VMs.
This bucket must then be added by the VM-Admin to the allowed S3 buckets list on the Secure Virtual Desktop projects router machine, `<projectID>-router`. The file to edit is located at `/etc/squid/allowlist_buckets.txt`. It contains entries in the form below, where the allowed buckets name should be added using the pattern shown

```txt
^https:\/\/s3\.eidf\.ac\.uk\/<ok-bucket-name>`
```

For the example of a bucket named `eidf-xxx-bucket` we would add the bucket id to the end of the url pattern like so:

```txt
^https:\/\/s3\.eidf\.ac\.uk\/eidf-xxx-bucket
```
