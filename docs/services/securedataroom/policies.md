# EIDF Secure Virtual Desktop Policies

## Networking Policies (R03,R12,R13,R14, R15, R16)

The EIDF Secure Virtual Desktop service provides VMs that prevent all host initiated network connections (egress) to the internet except those allowed in the web proxy allow lists by the project PI. The Secure Virtual Desktop VMs prevent any incoming network connections (ingress) from the internet, or lateral movements from VMs in the same project or EIDF Infrastructure to the VMs.

Secure Virtual Desktop VMs are placed within a standard TRE Private Project Zone (PPZ) subnet, leveraging understanding and pentesting from development of the infrastructure for the Scottish National Safe Haven also run by the EIDF.

## Audit policies (R05)

The EIDF Secure Virtual Desktop service provides logging of user activity within the Secure Virtual Desktop service VMs. This includes:

- Network requests
- Login Activity

### Network access logging

The Squid web proxy logs all network traffic like web requests made by Secure Virtual Desktop VMs. These logs are stored in the EIDF Squid router and are configured to be retained for a default period of 30 days before being automatically deleted.

The access logs are available in /var/log/squid/access.log.x where x is the log rotation number, with access.log.0 being the most recent log file.

The log retention period can be adjusted by changing the `logfile_rotate` parameter in the squid configuration file located at /etc/squid/squid.conf and the cronjob that runs the log rotation command. By default the log rotation happens every day at midnight. This is the [frequency recommended by Squid](https://wiki.squid-cache.org/SquidFaq/SquidLogs#which-log-files-can-i-delete-safely) to ensure log files do not grow too large.

### Login Activity

Login activity is automatically logged by the access tools (XRDP and SSH). The relevant log files follow these naming patterns: `xrdp-sesman.log*` for XRDP logins and `auth.log*` for SSH authentication.

Login activity to the Secure Virtual Desktop VMs is copied periodically from each VM to the project router VM `<projectID>-router`, where it is stored in the `ubuntu` user's home directory `/home/ubuntu/log-replications/`.

Logs are retained for a default period of 30 days before being automatically deleted. Each machine has its own log file and type of log file.

## Machine management policies (R06)

The Secure Virtual Desktop VMs are managed by the VM Admin users within the project. The EIDF team will manage ONLY the underlying infrastructure, hypervisors and cloud management software as part of the EIDF Maintenance sessions.

EIDF Secure Virtual Desktop VMs are provided in a state that allows easy customisation by VM Admin users to meet the requirements of their project. [Documentation is provided](docs.md) to guide VM Admin users on how to customise and manage their VMs for their own needs.

## End of Life Policy for User Accounts and Projects

### What happens when an account or project is no longer required, or a user leaves a project

These will match those of the main Virtual Machine service. Please see [EIDF VM Service Policies](../virtualmachines/policies.md#end-of-life-policy-for-user-accounts-and-projects) for details.

## Backup policies

The current policy, matching that of the main Virtual Machine service (see [EIDF VM Service Policies](../virtualmachines/policies.md#backup-policies)), is:

- The content of VM disk images is not backed up
- The VM disk images are not backed up

We strongly advise that you keep copies of any critical data on one of our fully backed-up systems such as the encrypted S3 storage or own servers transferred via [SERV-U](https://www.solarwinds.com/serv-u) .

## Patching of User VMs

The EIDF team updates and patches the hypervisors and the cloud management software as part of the EIDF Maintenance sessions. It is the responsibility of project PIs to keep the VMs in their projects up to date. VMs running the Ubuntu and Rocky operating systems automatically install security patches and alert users at log-on (via SSH) to reboot as necessary for the changes to take effect. They also encourage users to update packages.
