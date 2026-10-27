# Accessing EIDF

Some EIDF services are accessed via a Web browser and some by "traditional" command-line SSH.

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

[VDI access to Confidential Data Workspace VMs](../services/confidentialdataworkspace/quickstart.md): how to connect to the Confidential Data Workspace service.

## SSH Access to Virtual Machines

Users who have been granted the appropriate permissions by a project lead can also access EIDF virtual machines via SSH. See [SSH access via the EIDF Gateway jump host](./ssh.md).

## Remote Desktop Client Access to Virtual Machines

Users who have been granted access to an EIDF virtual machine via SSH may also connect to the virtual machine via a remote desktop client, if the virtual machine has a remote desktop service installed. See [Remote desktop client access via SSH](./ssh-rdp.md).

## SSH Access to Confidential Data Workspace Service

Remote SSH access to Confidential Data Workspace VMs is **disabled** for security of the service, access is provided through the Guacamole web interface only. Access is described in the [Confidential Data Workspace Quickstart](../services/confidentialdataworkspace/quickstart.md) guide.

## SSH Access to Computing Services

SSH access is used for the following services:

* [Ultra2](../services/ultra2/index.md)
* [EIDF Interim and Experimental Systems](../services/experimental/index.md)
