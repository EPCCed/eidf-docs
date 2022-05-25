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

1. Click on 'Create'
1. You should see the new VM listed under the 'Machines' table on the project page and the status as 'Creating'
1. Wait for a few minutes while the job to launch the VM completes.
    You have to reload the page to see updates.
1. Once the job has completed the status shows as 'Success' in the list of machines.

In the list of 'Machines' in the project page in the portal, click on the name of new VM
and check it has the correct configuration,
including a `10.24.*.*` IP address and a default SSH Guacamole connection.

### Quota

Each project has a quota for the number of instances, total number of vCPUs, total RAM and storage.
You may not be able to create a VM if it exceeds the quota.

Please contact the helpdesk if your quota requirements have changed.

### Register machine with SAFE

To manage the user accounts in your project and allow users to access a VM,
you have to register it as a "SAFE machine".

1. Open the details page for the VM by clicking on its name in the 'Machines' table
1. Click 'Register SAFE machine' to enable central account management

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

At this point, if the user logs into [https://eidf-vdi.epcc.ed.ac.uk/vdi](https://eidf-vdi.epcc.ed.ac.uk/vdi),
they will be automatically directed to the VM with the default SSH connection (unless they have other connections available in the VDI).

## First login

A new user account is allocated a temporary password which the user must reset before they
can log in for the first time.
The password reset will not work when logging in via RDP -
they must use a SSH connection in the VDI.

The user can view the temporary password in their account details page.

## Adding RDP Access to the VM

To configure the VM for access via RDP:

1. Open the VM details page by selecting the name on the project page
1. Click on 'Configure RDP'
1. The configuration job runs for a few minutes.

Once the RDP job is completed, all users that are allowed to access the VM
will also be permitted to use the RDP connection.

<!--
## Online support
-->
