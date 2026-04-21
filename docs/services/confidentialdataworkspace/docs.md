# Confidential Data Workspace - VM & User Management

## Quota and Usage

Quotas and Usage are the same as those for the [standard EIDF VM service](../virtualmachines/docs.md#quota-and-usage).

Each project has a quota for the number of instances, total number of vCPUs, total RAM and storage.
You will not be able to create a VM if it exceeds the quota.

You can view and refresh the project usage compared to the quota in a table near the bottom of the project page.
This table will be updated automatically when VMs are created or removed, and
you can refresh it manually by pressing the "Refresh" button at the top of the table.

Please submit a [support request](https://portal.eidf.ac.uk/queries/submit) if your quota requirements have changed.

## User Management

We suggest adopting the following three user roles when managing users in the CDW service:

**Data User** - Unprivileged user who, by default, may only access permitted data via the VDI

**Data Manager** - Includes all privileges of the Data User. Can import and export data, and directly access the service via SSH

**VM Admin** - Has sudo (super-user or unrestricted) access to manage VMs

!!! note
    These roles are separate from those in [SAFE](../../access/index.md) and are for the purpose of the CDW only

For those familiar with Safe Haven Services (SHS), the following table includes a mapping of roles in the CDW service which are conceptually similar to the roles in the SHS:

| CDW Role     | SHS Equivalent       |
| ------------ | -------------------- |
| Data User    | Researcher           |
| Data Manager | Research Coordinator |
| VM Admin     | EPCC SHS Staff |

### Creating a User Account

User accounts allow project members to log in to the VMs in a project.
The Project PI and Project Managers manage user accounts for each member of the project.
Users usually use one account (username and password) to log in to all the VMs in the same project that they can access,
however a user may have multiple accounts in a project, for example for different roles.

1. From the project page in the portal click on the 'Create account' button under the 'Project Accounts' table at the bottom
1. Complete the 'Create User Account' form as follows:

    1. Choose 'Account user name': this could be something sensible like the first and last names
    concatenated (or initials) together with the project name.
    The username is unique across all EPCC systems so the user will not be able to reuse this name
    in another project once it has been assigned.
    1. Select the project member from the 'Account owner' drop-down field
    1. Click 'Create'

The user can now set the password for their new account on the account details page.

### Setting Groups and Permissions

Management of VMs and user accounts in the portal can only be done by the PI or delegated Project Managers. Please see [Required Member Permissions](../virtualmachines/docs.md#required-member-permissions) for more information.

When a user account is created in the portal it will be added to the default group `<project-name>`. If the user account requires Data Manager access they must also be added to the `<project-name>-datamanager` group in SAFE:

1. Click "Manage Project in SAFE" at the bottom of the project page (opens a new tab)
1. On the project management page in SAFE, click the arrow next to "Project Groups" and click on the `eidfxxx-datamanager` group
1. Click "Add accounts" and enter the requried Data Manager accounts on the next page

### Adding a User to a VM

User accounts can be granted or denied access to existing VMs.

1. Click 'Manage' next to an existing user account in the 'Project Accounts' table on the project page, or click on the account name and then 'Manage' on the account details page
1. Select the checkboxes in the column "Access" for the VMs to which this account should have access or uncheck the ones without access
1. Click the 'Update' button
1. After a few minutes, the job to give them access to the selected VMs will complete and the account status will show as "Active".

If a user is logged in already to the VDI at [https://eidf-vdi.epcc.ed.ac.uk/vdi](https://eidf-vdi.epcc.ed.ac.uk/vdi)
newly added connections may not appear in their connections list immediately.
They must log out and log in again to refresh the connection information, or wait until the login token expires and is refreshed automatically - this might take a while.

If a user only has one connection available in the VDI they will be automatically directed to the VM with the default connection.

#### Sudo Permissions

VM Admins must be given sudo permissions on each VM to have the necessary permissions for managing restricted VMs and router configuration. Unlike addition to the `datamanager` group, sudo permissions are set on a per-VM basis via the Portal.

!!! Warning
    Sudo permissions should only be granted to VM Admins.

### First Login

Each new VM account must have its password reset before it can log-in for the first time.
To do this:

1. The user can log into the [Portal](https://portal.eidf.ac.uk) and select their project from the 'Projects' drop-down.
1. From the project page, they can select their account from the 'Your Accounts' table
1. Finally, click the 'Set Password' button from the 'User Account Info' table.

Users will then be able to log in using the VDI as described in the [VDI documentation](../../access/virtualmachines-vdi.md).

!!! Warning
    Access to the CDW VMs is only possible through the VDI or the project router (for Data Managers).
    You cannot directly SSH onto the VMs, and you cannot access the VMs through the router until you have access to the router itself. Please see the documentation section on [SSH Access to the CDW Router](./router-docs.md#ssh-access-to-the-cdw-router) for more information on how to access the router and then the VMs via SSH.

## Creating a VM

To create a new VM:

1. Select the project from the list of your projects, e.g. `eidfxxx`
1. Click on the 'New Private Machine' button
1. Complete the 'Create Machine' form as follows:

    1. Select the 'CDW' router to use, typically this will be the default router for your project e.g. `eidfxxx-router`
    1. Provide an appropriate name, e.g. `dev-01`. The project code will be prepended automatically to your VM name, in this case your VM would be named `eidfxxx-dev-01`.
    1. Select a suitable operating system
    1. Select a machine specification that is suitable
    1. Choose the required disk size (in GB) or leave blank for the default
    1. Tick the checkbox "Configure RDP access" if you would like to install RDP
      and configure VDI connections via RDP for your VM.

1. Click on 'Create'
1. You should see the new VM listed under the 'Machines' table on the project page and the status as 'Creating'
1. Wait while the job to launch the VM completes.
   This may take up to 10 minutes, depending on the configuration you requested.
   You have to reload the page to see updates.
1. Once the job has completed successfully the status shows as 'Active' in the list of machines.

You may wish to ensure that the machine size selected (number of CPUs and RAM) does not
exceed your remaining quota before you press Create, otherwise the request will fail.

In the list of 'Machines' in the project page in the portal, click on the name of new VM to see the configuration and properties, including the machine specification, its IP address and any configured VDI connections.

## Updating a VM

### Adding RDP Access to a VM

The instructions in this section match the instructions given in the [EIDF Virtual Machine Service Documentation](../virtualmachines/docs.md#adding-rdp-access).

If you did not select RDP access when you created the VM you can add it later:

1. Open the VM details page by selecting the name on the project page
1. Click on 'Configure RDP'
1. The configuration job runs for a few minutes.

Once the RDP job is completed, all users that are allowed to access the VM
will also be permitted to use the RDP connection.

### Software Catalogue

See [EIDF Virtual Machine Service Documentation](../virtualmachines/docs.md#software-catalogue).

### Patching and Updating

It is the responsibility of project PIs to keep the VMs in their projects up to date as stated in the [policy](policies.md#patching-of-user-vms).

!!! important "Snap packages"

    Snap packages are not supported by default on the CDW VMs. Snap requires data egress to install software packages. Allowing this could potentially be used to bypass the security of the CDW. If you require snap packages then the VM Admin can enable usage by following the instructions in the [FAQs](./faq.md#unable-to-download-packages-from-snap-on-the-cdw-vms).

Since updates and patches require access to the internet, users should ensure that their CDW VMs have access to the sources that the operating system gets updates from. These will have been configured by default, but repository sources can change and may need to be updated in the squid proxy configuration. Updating of allowed sources is detailed in the documentation section [Updating the allowed access for CDW VMs](router-docs.md#updating-the-list-of-allowed-domains-and-buckets).

#### Ubuntu

To patch and update packages on Ubuntu run the following commands (requires sudo permissions):

```bash
sudo apt update
sudo apt upgrade
```

Your system might require a restart after installing updates.

#### Rocky

To patch and update packages on Rocky run the following command (requires sudo permissions):

```bash
sudo dnf update
```

Your system might require a restart after installing updates.

### Rebooting

When logged in you can reboot a VM with this command (requires sudo permissions):

```bash
sudo reboot now
```

or use the reboot button in the EIDF Portal (requires project manager permissions).

### Managing Access to External Content

See [Router Configuration](router-docs.md) for documentation on updating the allowed access configuration for CDW VMs.
