# Storage in the Secure Virtual Desktop Service

The EIDF Secure Virtual Desktop Service provides options for privileged users to store and transfer data securely to and from the Secure Virtual Desktop VMs. To move data from the EIDF Secure Virtual Desktop VMs to other systems, users require an intermediate transfer storage location to reduce the access of the Secure Virtual Desktop VMs to the internet and non-authorised users. Any data should be transferred off of the transfer storage location and onto the VM disk.

## Roles and their Access to Storage Locations

We define three roles in the Secure Virtual Desktop service as described in the [Service Documentation](./docs.md#user-roles-and-their-permissions). These roles are in place to limit who can initiate data transfers to and from the Secure Virtual Desktop VMs. Typically we recommend that only VM Admin users and Data Manager users have access to transfer data to and from the Secure Virtual Desktop VMs. As such the below options for storage and data transfer are recommended as only available to these roles.

## S3 Storage

The Secure Virtual Desktop service allows users to transfer data using EIDF S3 buckets, by default all buckets except for one with the project name are disabled. VM Admins can add buckets to the allowlist to enable data ingress and egress from the machine using them.

To use S3 storage with Secure Virtual Desktop VMs, users must first create an S3 repo in the EIDF Portal, and then a bucket within this repo that will be accessible from the Secure Virtual Desktop VMs.
This bucket must then be added by the VM Admin to the allowed S3 buckets list on the Secure Virtual Desktop project's router, `<projectID>-router`. The file to edit is located at `/etc/squid/allowlist_buckets.txt`. It contains entries in the form below, where the allowed buckets name should be added using the regex pattern shown:

```txt
^https:\/\/s3\.eidf\.ac\.uk\/<ok-bucket-name>
```

For the example of a bucket named `eidf-xxx-bucket` we would add the bucket id to the end of the url pattern like so:

```txt
^https:\/\/s3\.eidf\.ac\.uk\/eidf-xxx-bucket
```

After editing the allowlist Squid must be reconfigured using the command:

```bash
sudo squid -k reconfigure
```

## Data Transfer to Secure Virtual Desktop service via scp

Data transfer to and from the Secure Virtual Desktop VMs can be performed using [`scp`](https://linux.die.net/man/1/scp). This is **only possible for users with the Data Manager role** and requires that the user has SSH key access to the Secure Virtual Desktop Router `<projectID>-router`. Data transfer using `scp` is performed by jumping through the Secure Virtual Desktop project's router, `<projectID>-router`, which acts as an intermediary for data transfer and access.

To transfer data to the Secure Virtual Desktop VMs using `scp`, the following command format should be used:

```bash
scp -o ProxyJump=<username>@<projectID>-router <local-file-path> <username>@<secure-virtual-desktop-vm-ip>:<remote-file-path>
```

Where:

- `<username>` is the user's SSH username for both the router and the Secure Virtual Desktop VM
- `<projectID>` is the EIDF project ID
- `<local-file-path>` is the path to the file on the user's local machine
- `<secure-virtual-desktop-vm-ip>` is the IP address of the Secure Virtual Desktop VM
- `<remote-file-path>` is the destination path on the Secure Virtual Desktop VM where the file will be copied to
