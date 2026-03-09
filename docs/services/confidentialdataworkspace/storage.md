# Storage in the Confidential Data Workspace Service

The EIDF Confidential Data Workspace Service provides options for privileged users to store and transfer data securely to and from the Confidential Data Workspace VMs. To move data from the EIDF Confidential Data Workspace VMs to other systems, users require an intermediate transfer storage location to reduce the access of the Confidential Data Workspace VMs to the internet and non-authorised users. Any data should be transferred off of the transfer storage location and onto the VM disk.

## Roles and Their Access to Storage Locations

We define three roles in the Confidential Data Workspace service as described in the [Service Documentation](./docs.md#user-roles-and-their-permissions). These roles are in place to limit who can initiate data transfers to and from the Confidential Data Workspace VMs. Typically we recommend that only VM Admin users and Data Manager users have access to transfer data to and from the Confidential Data Workspace VMs. As such the below options for storage and data transfer are recommended as only available to these roles.

## Data Manager Group Directory

A directory is created for users with the Data Manager role on Confidential Data Workspace VMs, this is located at `/data/datamanager`. This directory is owned by root and has group ownership set to a group named `<project_code>-datamanager`, which all users with the Data Manager role for the project should be added to following [Setting up the correct groups and permissions for user accounts](./docs.md#setting-up-the-correct-groups-and-permissions-for-user-accounts).

This directory can be used as a controlled staging area for data that is being transferred to or from Confidential Data Workspace VMs, before that data is made available to additional users or copied off the VM.

## S3 Storage

The Confidential Data Workspace service allows users to transfer data using EIDF S3 buckets, by default all EIDF S3 buckets except for one with the project name are disabled. VM Admins can add buckets to the allowlist to enable data ingress and egress from the machine using them.

For each S3 bucket you want to use, you must decide whether it should be read-only or read-write from the VM. This is controlled by adding the bucket to the appropriate allowlist domains:

- To only allow pulling data into the VM from a bucket, add the bucket to the `/etc/squid/allowlist_domains.txt` file on the Confidential Data Workspace project's router (`<project_code>-router`), as with access for any read only site. Buckets on this allowlist can be accessed with read permissions only.
- To allow both pulling data into the VM and pushing data from the VM to a bucket, add the bucket to the `/etc/squid/allowlist_buckets.txt` file on the Confidential Data Workspace project's router (`<project_code>-router`). Buckets on this allowlist can be accessed with both read and write permissions.
To use S3 storage with Confidential Data Workspace VMs, an S3 repository must exist or be created in the EIDF Portal. Project leads can request an object store allocation through a request to the EIDF helpdesk.

Once the S3 repository is created, a bucket must be created within this repository that will be accessible from the Confidential Data Workspace VMs.
This bucket must then be added by the VM Admin to the allowed S3 buckets list on the Confidential Data Workspace project's router, `<project_code>-router`. The file to edit is located at `/etc/squid/allowlist_buckets.txt`. It contains entries where the allowed buckets name should be added using the regex pattern as shown in the form below.

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

## Data Transfer Using SCP (With and Without SSH Config)

Data transfer to and from the Confidential Data Workspace VMs can be performed using [`scp`](https://linux.die.net/man/1/scp).

For a user to transfer data to and from the Confidential Data Workspace VMs using `scp` the following is required:

- The user has the Data Manager role
- The user has been added to the EIDF gateway, Confidential Data Workspace Router `<project_code>-router` and the target Confidential Data Workspace VM in the EIDF Portal
- An SSH client is installed on the user's local machine (see [SSH connection to EIDF](../../access/ssh.md) for more details)
- The user has SSH access to the Confidential Data Workspace Router `<project_code>-router`

Data transfer using `scp` is performed by jumping through the Confidential Data Workspace project's router, `<project_code>-router`, which acts as an intermediary for data transfer and access.

Because all traffic to EIDF services must first go through the gateway, the below command needs to do a double jump via both the EIDF gateway and the Confidential Data Workspace router.

### Where Users Have Set Up an SSH Config File With Configuration for the Router and VM (Recommended)

Users should first set up an SSH config file with configuration for the router and VM, as described in the documentation section [SSH Access to the Confidential Data Workspace Router](./router-docs.md#ssh-access-to-the-confidential-data-workspace-router) and [SSH Access to Confidential Data Workspace VMs via the Router](./router-docs.md#ssh-access-to-confidential-data-workspace-vms-via-the-router). After this is configured, they can use a simplified `scp` command. In this case, the `scp` command is:

    ```bash
    scp <local-file-path> eidfxxx-VM:/data/datamanager/
    ```

Where:

- `eidfxxx-VM` is the Host defined in the user's SSH config file for the target Confidential Data Workspace VM
- `/data/datamanager/` is the destination path on the Confidential Data Workspace VM where the file will be copied to
- `<local-file-path>` is the path to the file on the user's local machine

### Where Users Do Not Have an SSH Config File Set Up With Configuration for the Router and VM

To transfer data **to** the Confidential Data Workspace VMs from a local machine using `scp`, the following command format should be used:

    ```bash
    scp -i <path-to-private-key> -o ProxyJump=<username>@eidf-gateway.epcc.ed.ac.uk,<username>@<project-router-ip> <local-file-path> <username>@<confidential-data-workspace-vm-ip>:/data/datamanager/
    ```

Where:

- `<path-to-private-key>` is the path to the user's private SSH key that corresponds to the public SSH key added for the user in the EIDF Portal for access to the router and VM, more information on how to do this can be seen in the documentation section on [SSH Credentials in the EIDF Portal](../../access/ssh.md#generate-a-new-ssh-key).
- `<username>` is the user's SSH username for EIDF gateway, router and the Confidential Data Workspace VM
- `<project-router-ip>` is the IP address of the Confidential Data Workspace Router for the project. This IP address can be found in the EIDF Portal on the project details page, in the `machines` section, for the router machine named `<project_code>-router`.
- `<local-file-path>` is the path to the file on the user's local machine
- `<confidential-data-workspace-vm-ip>` is the IP address of the Confidential Data Workspace VM
- `/data/datamanager/` is the destination path on the Confidential Data Workspace VM where the file will be copied to
