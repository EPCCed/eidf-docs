# Accessing EIDF

Some EIDF services are accessed via a Web browser and some by "traditional" command-line
`ssh`.

All EIDF services use the [EPCC SAFE](https://safe.epcc.ed.ac.uk/) service management
back end, to ensure compatibility with other EPCC high-performance computing services.

## Web Access to Virtual Machines

The Virtual Desktop VM service is browser-based, providing a virtual desktop interface
(Apache Guacamole) for "desktop-in-a-browser" access. Applications to use the VM service
are made through the EIDF Portal.

[EIDF Portal](./project.md): how to ask to join an existing EIDF project and
how to apply for a new project

[VDI access to virtual machines](./virtualmachines-vdi.md): how to connect to the virtual
desktop interface.

## SSH Access to Virtual Machines

Users with the appropriate permissions can also [use `ssh` to login to Virtual Desktop VMs](./ssh.md)

## SSH Access to Computing Services

Includes access to the following services:

* [Cerebras CS-2](../services/cs2/)
* [Ultra2](../services/ultra2/)

To login to most command-line services with `ssh` you should use the username and password
you obtained from SAFE when you applied for access, along with the SSH Key you
registered when creating the account. You can then login to the host following the appropriately linked instructions
above.
