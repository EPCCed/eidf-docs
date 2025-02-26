# Virtual Machine Connections

Sessions on project VMs may be either remote desktop (RDP) logins or SSH terminal logins. Most users will prefer to use the remote desktop connections, but the SSH terminal connection is useful when remote network performance is poor and it must be used for account password changes.

## First Time Login and Account Password Changes

!!! warning "Account Password Changes"
    Note that first time account login cannot be through RDP as a password change is required. Password reset logins must be SSH terminal sessions as password changes can only be made through SSH connections.

## Connecting to a Remote SSH Session

When a VM SSH connection is selected the browser screen becomes a text terminal and the user is prompted to "Login as: " with a project account name, and then prompted for the account password. This connection type is equivalent to a standard xterm SSH session.

## Connecting to a Remote Desktop Session

Remote desktop connections work best by first placing the browser in Full Screen mode and leaving it in this mode for the entire duration of the Safe Haven session.

When a VM RDP connection is selected the browser screen becomes a remote desktop presenting the login screen shown below.

   ![VM-VDI-connection-login](/docs/images/access/vm-vdi-connection-login.png)
   *VM virtual desktop connection user account login screen*

Once the project account credentials have been accepted, a remote dekstop similar to the one shown below is presented. The default VM environment in the TRE is Ubuntu 22.04 with the Xfce desktop.

   ![VM-VDI-connection](/docs/images/access/vm-vdi-connection.png)
   *VM virtual desktop*
