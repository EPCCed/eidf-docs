# EIDF Secure Data Room Policies 

## Networking Policies (R03,R12,R13,R14, R15, R16)

The EIDF Secure Data Room service provides VMs that prevent all host initiated network connections (egress) to the internet except those allowed in the web proxy allow lists by the project PI. The Secure Data Room VMs prevent any incoming network connections (ingress) from the internet, or lateral movements from VMs in the same project or EIDF Infastructure to the VMs.

Secure data room VMs are placed within a standard TRE PPZ project subnet, leveraging understanding and pentesting from development of the infastructure for the Scottish National Safe Haven also run by the EIDF.

## Audit policies (R05)

The EIDF Secure Data Room service provides logging of user activity within the Secure Data Room service VMs. This includes:
    - Login Activity
    - Network requests
    - S3 data ingress and egress(==?==)

## Machine management policies
EIDF Secure Data Room VMs are managed

## End of Life Policy for User Accounts and Projects

### What happens when an account or project is no longer required, or a user leaves a project

These will match those of the main Virtual Machine service. Please see [EIDF VM Service Policies](../vm/policies.md#end-of-life-policy-for-user-accounts-and-projects) for details.

## Backup policies

The current policy, matching that of the main Virtual Machine service (see [EIDF VM Service Policies](../vm/policies.md#backup-policies)), is:

* The content of VM disk images is not backed up
* The VM disk images are not backed up

We strongly advise that you keep copies of any critical data on one of our fully backed-up systems such as the encrypted S3 storage or own servers transferred via [SERV-U](https://www.solarwinds.com/serv-u) .

## Patching of User VMs

The EIDF team updates and patches the hypervisors and the cloud management software as part of the EIDF Maintenance sessions. It is the responsibility of project PIs to keep the VMs in their projects up to date. VMs running the Ubuntu and Rocky operating systems automatically install security patches and alert users at log-on (via SSH) to reboot as necessary for the changes to take effect. They also encourage users to update packages.
