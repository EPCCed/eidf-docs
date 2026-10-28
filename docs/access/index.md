# Accessing EIDF

Some EIDF services are accessed via a web browser and some via the command-line, using SSH. Some EIDF services can be accessed via both.

All EIDF services use the [EPCC SAFE](https://safe.epcc.ed.ac.uk/) service management back end, to ensure compatibility with other EPCC high-performance computing services.

## Web Access to Virtual Machines

The EIDF Virtual Desktop Interface (VDI) service provides browser-based access to EIDF virtual machines. From within a browser, users can interact with an EIDF virtual machine via a user interface that mimics a command-line SSH session or, if the virtual machine has a remote desktop service installed, via a user interface that provides access to this remote desktop.

The EIDF VDI service can be used to access a project's [EIDF virtual machines](../services/virtualmachines/index.md) and virtual machines within a [Confidential Data Workspace (CDW)](../services/confidentialdataworkspace/index.md).

Applications to use the EIDF VDI service, and to access EIDF virtual machines, are made through the EIDF Portal.

For more information, see:

* [EIDF Portal](./project.md): how to ask to join an existing EIDF project and how to apply for a new project.
* [VDI access to virtual machines](./virtualmachines-vdi.md): how to connect to the virtual desktop interface, and so to EIDF virtual machines, from a browser.

## SSH Access to EIDF Virtual Machines

Users who have been granted the appropriate permissions by a project lead can also access EIDF virtual machines via SSH from their local host. See [SSH access to EIDF VMs](./ssh.md).

!!! Note "SSH Access to Confidential Data Workspace service"

    SSH access to Confidential Data Workspace VMs is **disabled** for security of the Confidential Data Workspace service, access is provided through the EIDF Virtual Desktop Interface service only.

## Remote Desktop Client Access to EIDF Virtual Machines

Users who have been granted access to an EIDF virtual machine via SSH can also connect to the virtual machine via a remote desktop client on their local host, if the EIDF virtual machine has a remote desktop service installed. See [Remote desktop client access via SSH](./ssh-rdp.md).

## SSH Access to Other EIDF Computing Services

SSH is used to access the following services:

* [Ultra2](../services/ultra2/index.md)
* [EIDF Interim and Experimental Systems](../services/experimental/index.md)
