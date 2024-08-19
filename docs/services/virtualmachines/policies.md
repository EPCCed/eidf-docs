# EIDF Data Science Cloud Policies

## End of Life Policy for User Accounts and Projects

### What happens when an account or project is no longer required, or a user leaves a project

These situations are most likely to come about during one of the following scenarios:

1. The retirement of project (usually one month after project end)
1. A Principal Investigator (PI) tidying up a project requesting the removal of user(s) no longer working on the project
1. A user wishing their own account to be removed
1. A failure by a user to respond to the annual request to verify their email address held in the SAFE

For each user account involved, assuming the relevant consent is given, the next step can be summarised as one of the following actions:

* Removal of the EIDF account
* The re-owning of the EIDF account within an EIDF project (typically to PI)
* In addition, the corresponding SAFE account may be retired under scenario 4

It will be possible to have the account re-activated up until resources are removed (as outlined above); after this time it will be necessary to re-apply.

A user's right to use EIDF is granted by a project. Our policy is to treat the account and associated data as the property of the PI as the owner of the project and its resources. It is the user's responsibility to ensure that any data they store on the EIDF DSC is handled appropriately and to copy off anything that they wish to keep to an appropriate location.

A project manager or the PI can revoke a user's access accounts within their project at any time, by locking, removing or re-owning the account as appropriate.

A user may give up access to an account and return it to the control of the project at any time.

When a project is due to end, the PI will receive notification of the closure of the project and its accounts one month before all project accounts and DSC resources (VMs, data volumes) are closed and cleaned or removed.

## Backup policies

The current policy is:

* The content of VM disk images is not backed up
* The VM disk images are not backed up

We strongly advise that you keep copies of any critical data on an alternative system that is fully backed up.

## Patching of User VMs

The EIDF team updates and patches the hypervisors and the cloud management software as part of the EIDF Maintenance sessions. It is the responsibility of project PIs to keep the VMs in their projects up to date. VMs running the Ubuntu and Rocky operating systems automatically install security patches and alert users at log-on (via SSH) to reboot as necessary for the changes to take effect. They also encourage users to update packages.

## Customer-run outward facing web services

PIs can apply to run an outward-facing service; that is a webservice on port 443, running on a project-owned VM. The policy requires the customer to accept the following conditions:

* Agreement that the customer will automatically apply security patches, run regular maintenance, and have named contacts who can act should we require it.
* Agreement that should EPCC detect any problematic behaviour (of users or code), we reserve the right to remove web access.
* Agreement that the customer understands all access is filtered and gated by EPCC’s Firewalls and NGINX (or other equivalent software) server such that there is no direct exposure to the internet of their application.
* Agreement that the customer owns the data, has permission to expose it, and that it will not bring UoE into disrepute.

Pis can apply for such a service on application and also at any time by contacing the EIDF Service Desk.
