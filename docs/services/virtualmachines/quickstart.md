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

1. View your user accounts on the project page.

1. Click on an account name to view details of the VMs that are you allowed to access
   with this account, and look up the temporary password allocated to the account.

1. Follow the link to the Guacamole login or
   log in directly at [https://eidf-vdi.epcc.ed.ac.uk/vdi/](https://eidf-vdi.epcc.ed.ac.uk/vdi/).
   Please see the [VDI](/eidf-docs/access/virtualmachines-vdi/#navigating-the-eidf-vdi) guide for more information.

1. Choose the SSH connection to log in for the first time. You will be asked to reset the password.

!!! warning
    Do not use RDP to login for the first time as you have to reset your password.
    Always use SSH to login to the VM for the first time.

## Further information

[Managing VMs](./docs.md): Project management guide to creating, configuring and removing VMs and managing user accounts in the portal.

[Virtual Desktop Interface](/eidf-docs/access/virtualmachines-vdi/): Working with the VDI interface.
