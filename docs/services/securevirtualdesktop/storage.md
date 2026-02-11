# Storage in the Secure Virtual Desktop Service

The EIDF Secure Virtual Desktop Service provides options for privileged users to store and transfer data securely to and from the Secure Virtual Desktop VMs. To move data from the EIDF Secure Virtual Desktop VMs to other systems, users require an intermediate transfer storage location to reduce the access of the Secure Virtual Desktop VMs to the internet and non-authorised users. Any data should be transferred off of the transfer storage location and onto the VM disk.

## Roles and their Access to Storage Locations

We define three roles in the Secure Virtual Desktop service as described in the [Service Documentation](./docs.md#user-roles-and-their-permissions). These roles are in place to limit who can initiate data transfers to and from the Secure Virtual Desktop VMs. Typically we recommend that only VM Admin users and Data Manager users have access to transfer data to and from the Secure Virtual Desktop VMs. As such the below options for storage and data transfer are recommended as only available to these roles.

## Data Manager Group directory

A directory is created for users with the Data Manager role on Secure Virtual Desktop VMs, this is located at `/data/<project_code>-datamanager` where `<project_code>` is the EIDF project code e.g. eidfxyz. This directory is owned by root and has group ownership set to a group named `<project_code>-datamanager`, which all users with the Data Manager role for the project should be added to following [Setting up the correct groups and permissions for user accounts](./docs.md#setting-up-the-correct-groups-and-permissions-for-user-accounts).

This directory can be used as a controlled staging area for data that is being transferred to or from Secure Virtual Desktop VMs, before that data is made available to additional users or copied off the VM.

## S3 Storage

The Secure Virtual Desktop service allows users to transfer data using EIDF S3 buckets, by default all buckets except for one with the project name are disabled. VM Admins can add buckets to the allowlist to enable data ingress and egress from the machine using them.

To use S3 storage with Secure Virtual Desktop VMs, users must first create an S3 repo in the EIDF Portal, and then a bucket within this repo that will be accessible from the Secure Virtual Desktop VMs.
This bucket must then be added by the VM Admin to the allowed S3 buckets list on the Secure Virtual Desktop project's router, `<project_code>-router`. The file to edit is located at `/etc/squid/allowlist_buckets.txt`. It contains entries in the form below, where the allowed buckets name should be added using the regex pattern shown:

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

Data transfer to and from the Secure Virtual Desktop VMs can be performed using [`scp`](https://linux.die.net/man/1/scp).

For a user to transfer data to and from the Secure Virtual Desktop VMs using `scp` the following is required:

- The user has the Data Manager role
- The user has been added to the EIDF gateway, Secure Virtual Desktop Router `<project_code>-router` and the target Secure Virtual Desktop VM in the EIDF Portal
- An SSH client is installed on the user's local machine (see [SSH connection to EIDF](../../access/ssh.md) for more details)
- The user has SSH access to the Secure Virtual Desktop Router `<project_code>-router`

Data transfer using `scp` is performed by jumping through the Secure Virtual Desktop project's router, `<project_code>-router`, which acts as an intermediary for data transfer and access.

Because all traffic to EIDF services must first go through the gateway, the below command needs to do a double jump via both the EIDF gateway and the Secure Virtual Desktop router.

To transfer data **to** the Secure Virtual Desktop VMs from a local machine using `scp`, the following command format should be used:

```bash
scp -o ProxyJump=<username>@eidf-gateway.epcc.ed.ac.uk,<username>@<project_code>-router <local-file-path> <username>@<secure-virtual-desktop-vm-ip>:/data/<project_code>-datamanager/
```

Where:

- `<username>` is the user's SSH username for EIDF gateway, router and the Secure Virtual Desktop VM
- `<project_code>` is the EIDF project_code
- `<local-file-path>` is the path to the file on the user's local machine
- `<secure-virtual-desktop-vm-ip>` is the IP address of the Secure Virtual Desktop VM
- `/data/<project_code>-datamanager/` is the destination path on the Secure Virtual Desktop VM where the file will be copied to
