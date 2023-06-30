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

The project PI or manager will then need to accept your request to join the project.

## Accessing a VM

1. View your user accounts on the project page.

1. Click on an account name to view details of the VMs that are you allowed to access
   with this account, and look up the temporary password allocated to the account.

1. Follow the link to the Guacamole login or
   log in directly at [https://eidf-vdi.epcc.ed.ac.uk/vdi/](https://eidf-vdi.epcc.ed.ac.uk/vdi/).
   Please see the [VDI](/eidf-docs/access/virtualmachines-vdi/#navigating-the-eidf-vdi) guide for more information.

1. Choose the SSH connection to log in for the first time. You will be asked to reset the password.

!!! warning
    The first time you log in to a new project you are required to change your one-time password.
    The password is visible through the project page of the [EIDF Portal](https://portal.eidf.ac.uk/)
    or via [SAFE](https://safe.epcc.ed.ac.uk/). The password
    cannot be changed using the RDP login, or by using a direct SSH via the [jumphost](../../access/ssh.md) and you must 
    use SSH via [VDI](https://eidf-vdi.epcc.ed.ac.uk/vdi/) in the
    web browser.

## Further information

[Managing VMs](./docs.md): Project management guide to creating, configuring and removing VMs and managing user accounts in the portal.

[Virtual Desktop Interface](/eidf-docs/access/virtualmachines-vdi/): Working with the VDI interface.
