# Quickstart

## Introduction to the Confidential Data Workspace

The Confidential Data Workspace (CDW) service provides an environment in which users can work with valuable controlled data in a familiar desktop environment where project leads can control which users have access to the project, install software, bring in data or take out data (disclose data).

Project managers can control the access of data into and out of a project's Virtual Machine (VM).

Examples of data used in the CDW include:

- Data disclosed for use in a secure, controlled manner, for example data that is subject to regulations such as the General Data Protection Regulation (GDPR)
- Data that is subject to a data sharing agreement that requires controls on how the data is used and shared
- Consented personal identifiable data that is used for research purposes and is subject to controls on how the data is used and shared
- Valuable data that should not exist in many, untrusted, non-audited or unauthorised locations

This service provides a controlled, auditable environment for working with this type of data that can be setup quickly to allow focus on data processing rather than meeting data access requirements.

## Prerequisites to using the Confidential Data Workspace

Projects using the CDW cloud service are accessed via the
[EIDF Portal](https://portal.eidf.ac.uk/). This documentation closely follows that of the
[Virtual Desktop Service Quickstart](../virtualmachines/quickstart.md), users of that service will find many familiar steps in this guide. There are some differences in the way that projects are set up, managed and users access the service, so please read this guide carefully.

Authentication is provided by SAFE, so if you do not have an active web browser session in SAFE,
you will be redirected to the [SAFE log on page](https://safe.epcc.ed.ac.uk).
If you do not have a SAFE account follow the instructions in the
[SAFE documentation](https://epcced.github.io/safe-docs/safe-for-users/)
on how to register and receive your password.

## Setting up a project as a Virtual Machine Administrator (VM Admin)

Configuration of a CDW project is the exclusive responsibility of the Project Virtual Machine Administrator (VM Admin) which is typically the Principal Investigator (PI) but can be delegated to a person of your choice. This section details the steps required to set up a project as a VM admin.

!!! Note
   The below requires that a CDW project has already been created for you by the EIDF team. If you do not have a CDW project or would like one created for you please contact the EIDF team to request this.

### Set up the Virtual Machine Admin (VM Admin) for the project

We will need to create a user that manages the CDW project and VMs. This VM Administration user will have the majority of permissions in the CDW project and will be responsible for managing data ingress and egress, creating VMs, installing software and managing access to the CDW project for other users. As part of this step we also need to set up groups that allow data disclosure of which the VM Admin is a member. Setup for the VM Admin is as follows:

- Add to the CDW project a user account for the VM Admin following the [Add a user account documentation](./docs.md#add-a-user-account). This will be a typical user account with no attached VM access.
- Following the ['Setting up the correct Groups and permissions' section of the Service documentation](./docs.md#setting-up-the-correct-groups-and-permissions-for-user-accounts), create a group with the name `eidfxxx-datamanager`. This will become the [Data Manager group](./docs.md#user-roles-and-their-permissions) for users who can disclose data. The VM admin should be added to this group.

### Connecting and configuring the project router

Within the 'machines' list at this stage you will have the pre-created `eidfxxx-router` VM. This machine acts as the gate through which all data passes through to the outside internet and hence it can be set up to allow or disallow data as a CDW project requires. We configure a list of domains from which machines are allowed to GET data. For example being able to access the Google search webpage but not send out our search which would allow egress of potentially sensitive information.

We also configure a list of buckets within the EIDF S3 repo that data managers can pull and push from.

To connect and configure the CDW project router you will need to:

- Set up VM Admin accounts for the CDW Project router (eidfxxx-router):
  - [Add the VM Admin user account to the project router virtual machine eidfxxx-router](docs.md#adding-access-to-the-vm-for-a-user),
  - Add [sudo permissions to the user account](./docs.md#sudo-permissions) for the project router.
- [Connect to the project router virtual machine eidfxxx-router](docs.md#connecting-to-the-project-router-virtual-machine-eidfxxx-router)
- Configure websites and domains that users will be able to get data from via list of domains in specific syntax, more details can be found in the [Updating allowed access for Confidential Data Workspace VMs documentation](./router-docs.md#updating-the-allowed-access-for-confidential-data-workspace-vms) section of the Service documentation.
- Configure allowed data disclosure out of the project via S3 buckets if this is desired by editing the list of allowed buckets that can be pulled and pushed to, this is documented in [Updating allowed access for Confidential Data Workspace VMs](./router-docs.md#updating-the-allowed-access-for-confidential-data-workspace-vms) section of the Service documentation.

### Setting up the private instance VMs for the CDW project

VM Admins will need to set up the actual VMs that users within the project will work on. These private instance VMs are machines with locked down access to the outside world with access only via the router. They are set up to have the router as a proxy for network access this means all traffic passes through the router to reach the outside world.

To create and set up the private instance VMs for the CDW project you will need to:

- Create a new private VM for the project following the [Creating a new VM section of the Service documentation](./docs.md#creating-a-new-vm-for-the-project).
- Add the VM admin account to the new VM following the [Adding user accounts to a project section of the Service documentation](./docs.md#adding-user-accounts-to-a-project) and [Adding access to the VM for a user section of the Service documentation](./docs.md#adding-access-to-the-vm-for-a-user).
- Trial connecting to the VM via the VDI following the [Accessing a VM section of the Service documentation](./docs.md#first-login) to ensure it is working correctly.
- Apply additional configuration of the VM such as installing software or configuring access to data sources following the [Managing VMs section of the Service documentation](./docs.md#managing-vms) and the [Details of the Confidential Data Workspace Router section of the Service documentation](./router-docs.md#details-of-the-confidential-data-workspace-router) for any network access configuration. It is also worth noting the [FAQs](./faq.md) for common questions around software and network configuration for the VMs.

### Add additional users for the CDW project

The VM Admin will need to set up the remaining users for the CDW project, these include data managers and data users. Data users are created following the same process as typical users in EIDF projects. They are given no other permissions than access to a private VM (not the router).

Data managers are created as typical EIDF project users but are added to the `eidfxxx-datamanager` group to give them permissions to disclose data from the CDW project. They also have access to the CDW project router VM which allows them to pass data through the router to the outside world. They do not have sudo access to the router as this would allow them to change its configuration and potentially enable unexpected data disclosure.

Specific guides exist for user creation steps and steps should be followed for each user that needs to be added to the CDW project. For data manager users the steps are:

- Add a data manager user account following the [Adding user accounts to a project section of the Service documentation](./docs.md#add-a-user-account)
- Add the data manager user accounts to the `eidfxxx-datamanager` group for each user who should have the ability to disclose data from the CDW project, following the [Setting up the correct Groups and permissions](./docs.md#setting-up-the-correct-groups-and-permissions-for-user-accounts) section of the Service documentation.

For non-data manager users the steps are:

- Add users as data users to the CDW project for each user who should have access to the project but not the ability to disclose data, following the [Adding user accounts to a project section of the Service documentation](./docs.md#add-a-user-account)
- Add users to CDW project VMs following the [Adding access to the VM for a user section of the Service documentation](./docs.md#adding-access-to-the-vm-for-a-user) for each user who should have access to the CDW project VMs, this includes both data manager users and data users.

### Add data to the CDW project

Data can be added to the CDW project by the VM Admin or data manager users in two ways:

- Copying the data in from an external machine using scp via the CDW project router machine as described in the [Data Transfer Using SCP documentation](./storage.md#data-transfer-using-scp-with-and-without-ssh-config)
- Adding data to an S3 bucket that is accessible inside and outside the CDW and copying the data from the bucket to the CDW project VMs via the CDW project router machine as given in the [S3 Storage documentation](./storage.md#s3-storage)

### CDW project VM access logs and data transfer logs

Details around the location and configuration of logs from the CDW project VMs can be found in the policies section of the documentation [Audit Policies](./policies.md#audit-policies).

## Accessing Your Projects as a Data User or Data Manager

1. Log into the portal at [https://portal.eidf.ac.uk/](https://portal.eidf.ac.uk/).
   The login will redirect you to the [SAFE](https://safe.epcc.ed.ac.uk/).

1. View the projects that you have access to
   at [https://portal.eidf.ac.uk/project/](https://portal.eidf.ac.uk/project/)

## Joining a Project

1. Navigate to [https://portal.eidf.ac.uk/project/](https://portal.eidf.ac.uk/project/)
   and click the link to "Request access", or choose "Request Access" in the "Project" menu.

1. Select the project that you want to join in the "Project" dropdown list -
   you can search for the project name or the project code, e.g. "eidf0123".

Now you have to wait for your PI or project manager to accept your request to join.

## Accessing a VM

1. Select a project and view your user accounts on the project page.

1. Click on an account name to view details of the VMs that you are allowed to access
   with this account, and to change the password for this account.

1. Before you log in for the first time with a new user account, you must change your password as described
   in the section [Set or change the password for a user account](../../services/virtualmachines/quickstart.md#set-or-change-the-password-for-a-user-account).

1. Follow the link to the Guacamole login or
   log in directly at [https://eidf-vdi.epcc.ed.ac.uk/vdi/](https://eidf-vdi.epcc.ed.ac.uk/vdi/).
   Please see the [VDI](../../access/virtualmachines-vdi.md#navigating-the-eidf-vdi) guide for more information.

!!! warning
    You must set a password for a new account before you log in for the first time.

## Set or Change the Password for a User Account

Follow these instructions to set a password for a new account before you log in for the first time.
If you have forgotten your password you may reset the password as described here.

1. Select a project and click the account name in the project page to view the account details.

1. In the user account detail page, press the button "Set Password"
   and follow the instructions in the form.

There may be a short delay while the change is implemented before the new password becomes usable.

## Further Information

[Managing VMs](./docs.md): Project management guide to creating, configuring and removing CDWs and managing user accounts in the portal.

[Frequently Asked Questions](./faq.md): Common questions and solutions for working with the CDW service.

[policies](./policies.md): Policies governing the use of the CDW service.

[Virtual Desktop Interface](../../access/virtualmachines-vdi.md): Working with the VDI interface.

[Storage and data transfer options for the Confidential Data Workspace](./storage.md)
