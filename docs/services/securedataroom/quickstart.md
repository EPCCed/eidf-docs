# Quickstart

Projects using the Virtual Desktop cloud service are accessed via the
[EIDF Portal](https://portal.eidf.ac.uk/).

Authentication is provided by SAFE, so if you do not have an active web browser session in SAFE,
you will be redirected to the [SAFE log on page](https://safe.epcc.ed.ac.uk).
If you do not have a SAFE account follow the instructions in the
[SAFE documentation](https://epcced.github.io/safe-docs/safe-for-users/)
how to register and receive your password.

## Accessing your projects

1. Log into the portal at [https://portal.eidf.ac.uk/](https://portal.eidf.ac.uk/).
   The login will redirect you to the [SAFE](https://safe.epcc.ed.ac.uk/).

1. View the projects that you have access to
   at [https://portal.eidf.ac.uk/project/](https://portal.eidf.ac.uk/project/)

## Joining a project

1. Navigate to [https://portal.eidf.ac.uk/project/](https://portal.eidf.ac.uk/project/)
   and click the link to "Request access", or choose "Request Access" in the "Project" menu.

1. Select the project that you want to join in the "Project" dropdown list -
   you can search for the project name or the project code, e.g. "eidf0123".

Now you have to wait for your PI or project manager to accept your request to join.

## Accessing a VM

1. Select a project and view your user accounts on the project page.

1. Click on an account name to view details of the VMs that are you allowed to access
   with this account, and to change the password for this account.

1. Before you log in for the first time with a new user account, you must change your password as described
   [below](../../services/virtualmachines/quickstart.md#set-or-change-the-password-for-a-user-account).

1. Follow the link to the Guacamole login or
   log in directly at [https://eidf-vdi.epcc.ed.ac.uk/vdi/](https://eidf-vdi.epcc.ed.ac.uk/vdi/).
   Please see the [VDI](../../access/virtualmachines-vdi.md#navigating-the-eidf-vdi) guide for more information.

1. You can also log in via the [EIDF Gateway Jump Host](https://epcced.github.io/eidf-docs/access/ssh/)
   if this is available in your project.

!!! warning
    You must set a password for a new account before you log in for the first time.

## Set or change the password for a user account

Follow these instructions to set a password for a new account before you log in for the first time.
If you have forgotten your password you may reset the password as described here.

1. Select a project and click the account name in the project page to view the account details.

1. In the user account detail page, press the button "Set Password"
   and follow the instructions in the form.

There may be a short delay while the change is implemented before the new password becomes usable.

## Further information

[Managing VMs](./docs.md): Project management guide to creating, configuring and removing VMs and managing user accounts in the portal.

[Virtual Desktop Interface](../../access/virtualmachines-vdi.md): Working with the VDI interface.

[EIDF Gateway](../../access/ssh.md): SSH access to VMs via the EIDF SSH Gateway jump host.

[Storage and data transfer options for the Secure Virtual Desktop](./storage.md)