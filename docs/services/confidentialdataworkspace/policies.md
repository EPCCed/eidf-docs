# Confidential Data Workspace - Policies

## Networking Policies

The Confidential Data Workspace (CDW) service provides VMs that prevent all host initiated network connections (egress) to the internet, except for destinations explicitly allowed in the web proxy allow list. VMs also prevent any incoming network connections (ingress) from the internet, VMs from any other project, and by default also any lateral movements from VMs in the same project. As a result, CDW VMs cannot be directly accessed via SSH, and can only be accessed via the project router or
browser based remote desktop.

## Audit Policies

The CDW service provides logs of user activity within service VMs. This includes:

- Network requests
- Login Activity

### Network Access Logging

The Squid web proxy logs all network traffic like web requests made by CDW VMs. These logs are stored on the router VM and are configured to be retained for a default period of 30 days before being automatically deleted. Logs are available at `/var/log/squid/access.log.x` where x is the log rotation number, with `access.log.0` being the most recent log file.

The log retention period can be adjusted by changing the `logfile_rotate` parameter in the squid configuration file located at `/etc/squid/squid.conf`. By default the log rotation happens every day at midnight, based on a cron job owned by the root user. This is the [frequency recommended by Squid](https://wiki.squid-cache.org/SquidFaq/SquidLogs#which-log-files-can-i-delete-safely) to ensure log files do not grow too large.

### Login Activity

Login activity is automatically logged by the access tools (XRDP and SSH). The relevant log files follow these naming patterns: `xrdp-sesman.log*` for XRDP logins and `auth.log*` for SSH authentication.

Login activity to CDW VMs is copied periodically to the project router VM `<project_code>-router`, where it is stored in the log directory under the host name for the VM `/var/log/<vm_hostname>/`.

Logs are retained for a default period of 30 days before being automatically deleted. Each machine has its own log file and type of log file.

## Machine Management Policies

The CDW VMs are managed by the VM Admin users within the project. The EIDF team will manage ONLY the underlying infrastructure, hypervisors and cloud management software as part of the EIDF Maintenance sessions.

EIDF CDW VMs are provided in a state that allows easy customisation by VM Admin users to meet the requirements of their project. [Documentation is provided](docs.md) to guide VM Admin users on how to customise and manage their VMs for their own needs.

## End of Life Policy for User Accounts and Projects

### What Happens When an Account or Project Is No Longer Required, or a User Leaves a Project

These will match those of the main Virtual Machine service. Please see [EIDF VM Service Policies](../virtualmachines/policies.md#end-of-life-policy-for-user-accounts-and-projects) for details.

## Backup Policies

The current policy, matching that of the main Virtual Machine service (see [EIDF VM Service Policies](../virtualmachines/policies.md#backup-policies)), is:

- The content of VM disk images is not backed up
- The VM disk images are not backed up

We strongly advise that you keep copies of any critical data on one of our fully backed-up systems such as the S3 storage.

## Patching of User VMs

The EIDF team updates and patches the hypervisors and the cloud management software as part of the EIDF Maintenance sessions. It is the responsibility of project PIs to keep the VMs in their projects up to date. VMs running the Ubuntu and Rocky operating systems automatically install security patches and alert users at log-on (via SSH) to reboot as necessary for the changes to take effect. They also encourage users to update packages.
