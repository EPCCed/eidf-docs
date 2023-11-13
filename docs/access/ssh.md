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
1. Generate a new SSH Key: ```$ ssh-keygen```
1. Input the directory and filename of they key. It's recommended to make this something like 'eidf-gateway' so it's easier to identify later
1. Press enter to finish generating the key

### Adding the new SSH Key to your account via the Portal

1. Login into the [Portal](https://portal.eidf.ac.uk)
1. Select 'Your Projects'
1. Select the relevant project
1. Select your username
1. Select the plus button under  'Credentials'
1. Select 'Choose File' to upload the PUBLIC (.pub) ssh key generated in the last step, or open the <ssh-key>.pub file you just created and copy its contents into the text box.
1. Click 'Upload Credential'  <br> It should look something like this:

![eidf-portal-ssh](/eidf-docs/images/access/eidf-portal-ssh.png){: class="border-img"}

#### Adding a new SSH Key via SAFE

This should not be necessary for most users, so only follow this process if you have an issue or have been told to by the EPCC Helpdesk.
If you need to add an SSH Key directly to SAFE, you can follow this [guide.](https://epcced.github.io/safe-docs/safe-for-users/#how-to-add-an-ssh-public-key-to-your-account)
However, select your '[username]@EIDF' login account, not 'Archer2' as specified in that guide.

### Using the SSH-Key to access EIDF - Windows and Linux

1. From your local terminal, import the SSH Key you generated above: ```$ ssh-add [sshkey]```
1. This should return "Identity added [Path to SSH Key]" if successful. You can then follow the steps below to access your VM.

## Accessing from Windows

Windows will require the installation of OpenSSH-Server or MobaXTerm to use SSH. Putty can also be used but won’t be covered in this tutorial.

### Installing and using OpenSSH

1. Click the ‘Start’ button at the bottom of the screen
1. Click the ‘Settings’ cog icon
1. Search in the top bar ‘Add or Remove Programs’ and select the entry
1. Select the ‘Optional Features’ blue text link
1. If ‘OpenSSH Client’ is not under ‘Installed Features’, click the ‘Add a Feature’ button
1. Search ‘OpenSSH Client’
1. Select the check box next to ‘OpenSSH Client’ and click ‘Install’

### Accessing EIDF via a Terminal
<i>If this is your first time connecting to EIDF, see the 'First Password Setting and Password Resets via the EIDF-Gateway' section below.</i><br>

1. Open either Powershell (the Windows Terminal) or a WSL Linux Terminal
1. Import the SSH Key you generated above: ```$ ssh-add [/path/to/sshkey]```
1. This should return "Identity added [Path to SSH Key]" if successful.
1. Login by jumping through the gateway.

```bash
ssh -J [username]@eidf-gateway.epcc.ed.ac.uk [username]@[vm_ip]
```


## Accessing From MacOS/Linux
<i>If this is your first time connecting to EIDF, see the 'First Password Setting and Password Resets via the EIDF-Gateway' section below.</i><br>

OpenSSH is installed on Linux and MacOS usually by default, so you can access the gateway natively from the terminal. <br>
Ensure you have created and added an ssh key as specified in the 'Generating and Adding an SSH Key' section above, then run the command below. <br>
```bash
ssh -J [username]@eidf-gateway.epcc.ed.ac.uk [username]@[vm_ip]
```
<i>The '-J' flag is use to specify that we will access the second specified host by jumping through the first specified host.</i><br>


## First Password Setting and Password Resets via the EIDF-Gateway

You will have to connect to your VM via SSH before you can login with RDP as your initial password needs to be reset, which can only be done via SSH. You can reset your password through the SSH Gateway by connecting to it directly.
<br>You will need to pass your accounts SSH key using either the '-i' flag or running 'ssh-add /path/to/key' first.

```bash
ssh [username]@eidf-gateway.epcc.ed.ac.uk
```

Your first attempt to log in to your account using the SSH Gateway will prompt you for your initial password (provided in the portal) like a normal login. If this is successful you will choose a new password. You will be asked for your initial password again, followed by two entries of your new password. This will reset the password to your account for both the gateway and the VM. Once this reset has been completed, the session will disconnect and you can login via SSH again using the newly set password.

You will not be able to directly connect to the gateway again, so to connect to your VM, jump through the SSH Gateway:

```bash
ssh -J [username]@eidf-gateway.epcc.ed.ac.uk [username]@[vm_ip]
```
