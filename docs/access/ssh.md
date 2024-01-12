# SSH Access to Virtual Machines using the EIDF-Gateway Jump Host

<style>
.borderimg1 {
  border: 5px solid transparent;
  padding: 5px;
  /*margin: 15px;*/
  border-color: rgba(192, 192, 192, 0.1);
  border-radius: 10px;
}

.bold {
  font-weight: bold;
  color: blue;
}
</style>

The EIDF-Gateway is an SSH gateway suitable for accessing EIDF Services via a console or terminal. As the gateway cannot be 'landed' on, a user can only pass through it and so the destination (the VM IP) has to be known for the service to work. Users connect to their VM through the jump host using their given accounts.
You will require three things to use the gateway:

1. A user within a project allowed to access the gateway and a password set.
1. An SSH-key linked to this account, used to authenticate against the gateway.
1. Have MFA setup with your project account via SAFE.

Steps to meet all of these requirements are explained below.

## Generating and Adding an SSH Key

In order to make use of the EIDF-Gateway, your EIDF account needs an SSH-Key associated with it.
If you added one while creating your EIDF account, you can skip this step.

### Check for an existing SSH Key

To check if you have an SSH Key associated with your account:

1. Login to the [Portal](https://portal.eidf.ac.uk)
1. Select 'Your Projects'
1. Select your project name
1. Select your username

If there is an entry under 'Credentials', then you're all setup.
If not, you'll need to generate an SSH-Key, to do this:

### Generate a new SSH Key

1. Open a new window of whatever terminal you will use to SSH to EIDF.
1. Generate a new SSH Key:

   ```bash
   ssh-keygen
   ```

1. It is fine to accept the default name and path for the key unless you manage a number of keys.
1. Press enter to finish generating the key

### Adding the new SSH Key to your account via the Portal

1. Login into the [Portal](https://portal.eidf.ac.uk)
1. Select 'Your Projects'
1. Select the relevant project
1. Select your username
1. Select the plus button under  'Credentials'
1. Select 'Choose File' to upload the PUBLIC (.pub) ssh key generated in the last step, or open the <ssh-key>.pub file you just created and copy its contents into the text box.
1. Click 'Upload Credential' - it should look something like this:

   ![eidf-portal-ssh](../images/access/eidf-portal-ssh.png){: class="border-img"}

#### Adding a new SSH Key via SAFE

This should not be necessary for most users, so only follow this process if you have an issue or have been told to by the EPCC Helpdesk.
If you need to add an SSH Key directly to SAFE, you can follow this [guide.](https://epcced.github.io/safe-docs/safe-for-users/#how-to-add-an-ssh-public-key-to-your-account)
However, select your '[username]@EIDF' login account, not 'Archer2' as specified in that guide.

## Enabling MFA via SAFE

A multi-factor Time-Based One-Time Password is now required to access the SSH Gateway. <br>

To enable this for your EIDF account:

1. Login to the [portal.](https://portal.eidf.ac.uk)
1. Select 'Projects' then 'Your Projects'
1. Select the project containing the account you'd like to add MFA to.
1. Under 'Your Accounts', select the account you would like to add MFA to.
1. Select 'Set MFA Token'
1. Within your chosen MFA application, scan the QR Code or enter the key and add the token.
1. Enter the code displayed in the app into the 'Verification Code' box and select 'Set Token'
1. You will be redirected to the User Account page and a green 'Added MFA Token' message will confirm the token has been added successfully.

!!! note
    TOTP is only required for the SSH Gateway, not to the VMs themselves, and not through the VDI.<br>
    An MFA token will have to be set for each account you'd like to use to access the EIDF SSH Gateway.

### Using the SSH-Key and TOTP Code to access EIDF - Windows and Linux

1. From your local terminal, import the SSH Key you generated above: ```$ ssh-add [sshkey]```

1. This should return "Identity added [Path to SSH Key]" if successful. You can then follow the steps below to access your VM.

## Accessing From MacOS/Linux

!!! warning
    If this is your first time connecting to EIDF using a new account, you have to set a password as described in [Set or change the password for a user account](../services/virtualmachines/quickstart.md#set-or-change-the-password-for-a-user-account).

OpenSSH is installed on Linux and MacOS usually by default, so you can access the gateway natively from the terminal.

Ensure you have created and added an ssh key as specified in the 'Generating and Adding an SSH Key' section above, then run the command below.

```bash
ssh -J [username]@eidf-gateway.epcc.ed.ac.uk [username]@[vm_ip]
```

The `-J` flag is use to specify that we will access the second specified host by jumping through the first specified host.

You will be prompted for a 'TOTP' code upon successful public key authentication to the gateway. At the TOTP prompt, enter the code displayed in your MFA Applicaiton.

## Accessing from Windows

Windows will require the installation of OpenSSH-Server to use SSH. Putty or MobaXTerm can also be used but won’t be covered in this tutorial.

### Installing and using OpenSSH

1. Click the ‘Start’ button at the bottom of the screen
1. Click the ‘Settings’ cog icon
1. Search in the top bar ‘Add or Remove Programs’ and select the entry
1. Select the ‘Optional Features’ blue text link
1. If ‘OpenSSH Client’ is not under ‘Installed Features’, click the ‘Add a Feature’ button
1. Search ‘OpenSSH Client’
1. Select the check box next to ‘OpenSSH Client’ and click ‘Install’

### Accessing EIDF via a Terminal

!!! warning
    If this is your first time connecting to EIDF using a new account, you have to set a password as described in [Set or change the password for a user account](../services/virtualmachines/quickstart.md#set-or-change-the-password-for-a-user-account).

1. Open either Powershell (the Windows Terminal) or a WSL Linux Terminal
1. Import the SSH Key you generated above: ```$ ssh-add [/path/to/sshkey]```
1. This should return "Identity added [Path to SSH Key]" if successful.
1. Login by jumping through the gateway.

```bash
ssh -J [username]@eidf-gateway.epcc.ed.ac.uk [username]@[vm_ip]
```

You will be prompted for a 'TOTP' code upon successful public key authentication to the gateway. At the TOTP prompt, enter the code displayed in your MFA Application.

## First Password Setting and Password Resets

Before logging in for the first time you have to reset the password using the web form in the EIDF Portal following the instructions in [Set or change the password for a user account](../services/virtualmachines/quickstart.md#set-or-change-the-password-for-a-user-account).
