# Confidential Data Workspace - Admin Quickstart

This guide is a condensed version of the information contained across the other pages, providing a starting point for the setup of new CDW projects.

By the end of this guide, you will have:

1. Created a VM Admin account
1. Configured the project's router VM
1. Created a standard VM and granted access to users
1. Imported data into the project
1. Reviewed the project's audit logs

## Prerequisites

Configuration of a new CDW project is the exclusive responsibility of the Principal Investigator, or delegated Project Managers.

!!! Note
    This guide assumes that you have applied and have been granted access to use the EIDF CDW service via the [application process](https://edinburgh-international-data-facility.ed.ac.uk/access).

Projects are managed via the
[EIDF Portal](https://portal.eidf.ac.uk/). This documentation closely follows that of the
[Virtual Desktop Service Quickstart](../virtualmachines/quickstart.md), users of that service will find many familiar steps in this guide. There are some differences in the way that projects are set up, managed and users access the service, so please read this guide carefully.

Authentication is provided by SAFE, so if you do not have an active web browser session in SAFE,
you will be redirected to the [SAFE log on page](https://safe.epcc.ed.ac.uk).
If you do not have a SAFE account follow the instructions in the
[SAFE documentation](https://epcced.github.io/safe-docs/safe-for-users/)
on how to register and receive your password.

## Set up the Virtual Machine Admin (VM Admin) for the project

We need to create at least one user account which can manage VMs in the project. These accounts will be responsible for installing software and managing the list of allowed external domains for all other users.

Create one or more VM Admin accounts by following the [User Management](./docs.md#creating-a-user-account) section. Ensure that you check the "sudo" option when assigning the account(s) to the VMs.

## Configuring the project router

Within the 'machines' list at this stage you will have the pre-created `eidfxxx-router` VM. This machine acts as the gateway through which all data from other VMs passes through to the outside internet, and hence it can be set up to allow or disallow data as a CDW project requires. For connections to external sites from project VMs, the default action is to deny all requests unless the site is explicitly allowed.

!!! Warning
    The CDW Router itself has full external network access. It is therefore vital that only trusted project managers are granted access to this VM.

### Managing external site access

A default list of common domains is pre-configured on the VM, but this can be modified as required. Sites on this list are limited to data retrieval only, for example users are able to download code from a software repository but not upload.

To configure this list:

- On the Portal project page, click the "VDI login" button
- Find or search for the `eidfxxx-router_ssh` connection and click on it
- Login to the VM using the VM Admin account from the previous step
- Configure websites and domains that users will be able to get data from via list of domains in specific syntax, more details can be found in the [Updating allowed access for Confidential Data Workspace VMs documentation](./router-docs.md#updating-the-list-of-allowed-domains-and-buckets) section of the Service documentation.

### Managing EIDF S3 bucket access

We also configure a list of buckets within the [EIDF S3](https://docs.eidf.ac.uk/services/s3/) repo that data managers can pull and push from.

Follow the same steps as above to log-in to the router VM, but edit the `/etc/squid/allowlist_buckets.txt` file instead.

## Creating private VMs

Project Managers will need to set up the actual VMs that users within the project will work on. These private instance VMs are machines with locked down access to the outside world with access only via the router. They are set up to have the router as a proxy for network access this means all traffic passes through the router to reach the outside world. They also have clipboard access disabled, so users cannot copy & paste text through the virtual desktop interface.

To create and set up the private instance VMs for the CDW project you will need to:

- Create a new private VM for the project following the [Creating a new VM section of the Service documentation](./docs.md#creating-a-vm).
- Add the VM admin account(s) to the new VM by following [Adding a user to a VM](./docs.md#adding-a-user-to-a-vm).
- Trial connecting to the VM via the VDI following the [Accessing a VM section of the Service documentation](./docs.md#first-login) to ensure it is working correctly.
- Apply additional configuration of the VM such as installing software or configuring access to data sources following the [Managing VMs section of the Service documentation](./docs.md#updating-a-vm) and the [Details of the Confidential Data Workspace Router section of the Service documentation](./router-docs.md) for any network access configuration. It is also worth noting the [FAQs](./faq.md) for common questions around software
  and network configuration for the VMs.

## Add additional users

Project Managers will need to set up the remaining users for the CDW project, these include data managers and data users. Data users are created following the same process as typical users in EIDF projects. They are given no other permissions than access to a private VM.

Data managers are created as typical EIDF project users but are added to the `eidfxxx-datamanager` group to give them permissions to disclose data from the CDW project. They should not be given sudo access, as we recommend this is restricted to specific VM Admin accounts only.

Specific guides exist for user creation steps and steps should be followed for each user that needs to be added to the CDW project. For data manager users the steps are:

- Add a data manager user account following the [Adding user accounts to a project section of the Service documentation](./docs.md#adding-a-user-to-a-vm)
- Add the data manager user accounts to the `eidfxxx-datamanager` group for each user who should have the ability to disclose data from the CDW project, following the [Setting up the correct Groups and permissions](./docs.md#setting-groups-and-permissions) section of the Service documentation.

For non-data manager users the steps are:

- Add users as data users to the CDW project for each user who should have access to the project but not the ability to disclose data, following the [Adding user accounts to a project section of the Service documentation](./docs.md#adding-a-user-to-a-vm)
- Add users to CDW project VMs following the [Adding access to the VM for a user section of the Service documentation](./docs.md#adding-a-user-to-a-vm) for each user who should have access to the CDW project VMs, this includes both data manager users and data users.

## Import data

Data can be added to the CDW project by Data Manager accounts in two ways:

- Copying the data in from an external machine using scp via the project router machine as described in the [Data Transfer Using SCP documentation](./storage.md#data-transfer-using-scp-with-and-without-ssh-config)
- Adding data to an S3 bucket that is accessible inside and outside the CDW as described in the [S3 Storage documentation](./storage.md#s3-storage)

## Access audit logs

Details around the location and configuration of logs from the CDW project VMs can be found in the policies section of the documentation [Audit Policies](./policies.md#audit-policies).
