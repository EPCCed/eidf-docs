# Service Documentation

## Project Management Guide

### Create a VM

VMs can only be created by a project manager (PM) or by the principal investigator (PI) of the project.

To create a new VM:

1. Select the project from the list of your projects, e.g. `eidfxxx`
1. Click on the 'New Machine' button
1. Complete the 'Create Machine' form as follows:

    1. Provide an appropriate name, e.g. `dev-01`. The project code will be prepended automatically
        to your VM name, in this case your VM would be named `eidfxxx-dev-01`.
    1. Select a suitable operating system
    1. Select a machine specification that is suitable
    1. Choose the required disk size (in GB) or leave blank for the default
    1. Tick the checkbox "Configure RDP access" if you would like to install RDP
       and configure VDI connections via RDP for your VM.
    1. Select the package installations from the software catalogue drop-down list,
       or "None" if you don't require any pre-installed packages

1. Click on 'Create'
1. You should see the new VM listed under the 'Machines' table on the project page and the status as 'Creating'
1. Wait while the job to launch the VM completes.
   This may take up to 10 minutes, depending on the configuration you requested.
   You have to reload the page to see updates.
1. Once the job has completed successfully the status shows as 'Active' in the list of machines.

You may wish to ensure that the machine size selected (number of CPUs and RAM) does not
exceed your remaining quota before you press Create, otherwise the request will fail.

In the list of 'Machines' in the project page in the portal,
click on the name of new VM to see the configuration and properties,
including the machine specification, its `10.24.*.*` IP address and any configured VDI connections.

### Quota and Usage

Each project has a quota for the number of instances, total number of vCPUs, total RAM and storage.
You will not be able to create a VM if it exceeds the quota.

You can view and refresh the project usage compared to the quota in a table near the bottom of the project page.
This table will be updated automatically when VMs are created or removed, and
you can refresh it manually by pressing the "Refresh" button at the top of the table.

Please contact the helpdesk if your quota requirements have changed.

### Add a user account

User accounts allow project members to log in to the VMs in a project.
The Project PI and project managers manage user accounts for each member of the project.
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

The new account is allocated a temporary password which the account owner can view
in their account details.

## Adding Access to the VM for a User

User accounts can be granted or denied access to existing VMs that are registered as SAFE machines.

1. Click on an existing user account in the 'Project Accounts' table on the project page
1. Click 'Manage'
1. Select the checkboxes next to the VMs that this account should have access to or uncheck the ones without access
1. Click the 'Update' button
1. After a few minutes, the job to give them access to the selected VMs will complete

If a user only has one connection available and logs on to the VDI at
[https://eidf-vdi.epcc.ed.ac.uk/vdi](https://eidf-vdi.epcc.ed.ac.uk/vdi),
they will be automatically directed to the VM with the default SSH connection.

## First login

A new user account is allocated a temporary password which the user must reset before they
can log in for the first time.
The password reset will not work when logging in via RDP -
they must use a SSH connection, either in the VDI or via an SSH gateway.

The user can view the temporary password in their account details page.

## Updating an existing machine

### Adding RDP Access

If you did not select RDP access when you created the VM you can add it later:

1. Open the VM details page by selecting the name on the project page
1. Click on 'Configure RDP'
1. The configuration job runs for a few minutes.

Once the RDP job is completed, all users that are allowed to access the VM
will also be permitted to use the RDP connection.

### Software catalogue

You can install packages from the software catalogue at a later time,
even if you didn't select a package when first creating the machine.

1. Open the VM details page by selecting the name on the project page
1. Click on 'Software Catalogue'
1. Select the configuration you wish to install and press 'Submit'
1. The configuration job runs for a few minutes.
