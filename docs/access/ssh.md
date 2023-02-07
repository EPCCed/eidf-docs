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

# SSH Access to Virtual Machines using the EIDF-Gateway Jump Host
The EIDF-Gateway is an SSH gateway suitable for accessing EIDF Services via a console or terminal. As the gateway cannot be 'landed' on, a user can only pass through it and so the destination (the VM IP) has to be known for the service to work. Users connect to their VM through the jump host using their given accounts.

The gateway is currently only accessible from University of Edinburgh IP Addresses, an appropriate VPN will need to be used if accessing outside of campus.


## Generating and Adding an SSH Key
In order to make use of the EIDF-Gateway, your EIDF account needs an SSH-Key associated with it.
If you added one while creating your EIDF account, you can skip this step.

### Check for an existing SSH Key
To check if you have an SSH Key associated with your account:

1. Login to the [Portal](https://portal.eidf.ac.uk)
2. Select 'Your Projects'
3. Select your project name
4. Select your username

If there is an entry under 'Credentials', then you're all setup.
If not, you'll need to generate an SSH-Key, to do this:

### Generate a new SSH Key
1. Open a new window of whatever terminal you will use to SSH to EIDF.
2. Generate a new SSH Key:  
$ ssh-keygen
3. Input the directory and filename of they key. It's recommended to make this something like 'eidf-gateway' so it's easier to identify later
4. Press enter to finish generating the key

### Adding the new SSH Key to your account via the Portal
1. Login into the [Portal](https://portal.eidf.ac.uk)
2. Select 'Your Projects'
3. Select the relevant project
4. Select your username
5. Select the plus button under  'Credentials'
6. Select 'Choose File' to upload the PUBLIC (.pub) ssh key generated in the last step, or open the <ssh-key>.pub file you just created and copy its contents into the text box.
7. Click 'Upload Credential'  <br>
It should look something like this:  

![eidf-portal-ssh](/eidf-docs/images/access/eidf-portal-ssh.png){: class="border-img"}

#### Adding a new SSH Key via SAFE
This should not be necessary for most users, so only follow this process if you have an issue or have been told to by the EPCC Helpdesk.  
If you need to add an SSH Key directly to SAFE, you can follow this [guide.](https://epcced.github.io/safe-docs/safe-for-users/#how-to-add-an-ssh-public-key-to-your-account)  
However, select your '[username]@EIDF' login account, not 'Archer2' as specified in that guide.

### Using the SSH-Key to access EIDF - Windows and Linux
1. From your local terminal, import the SSH Key you generated above:  
$ ssh-add [sshkey]
2. This should return "Identity added [Path to SSH Key]" if successful. You can then follow the steps below to access your VM.


## Accessing from Windows
Windows will require the installation of OpenSSH-Server or MobaXTerm to use SSH. Putty can also be used but won’t be covered in this tutorial.

### Installing and using OpenSSH
1.	Click the ‘Start’ button at the bottom of the screen
2.	Click the ‘Settings’ cog icon
3.	Search in the top bar ‘Add or Remove Programs’ and select the entry
4.	Select the ‘Optional Features’ blue text link
5.	If ‘OpenSSH Client’ is not under ‘Installed Features’, click the ‘Add a Feature’ button
6.	Search ‘OpenSSH Client’
7.	Select the check box next to ‘OpenSSH Client’ and click ‘Install’
8.	Once this is installed, you can reach your VM by opening CMD and running
9.	$ ssh -J [SAFE-username]@eidf-gateway.epcc.ed.ac.uk [VM-username]@[VM/IP]

### Installing MobaXTerm
1.	Download [MobaXTerm](https://mobaxterm.mobatek.net/) from https://mobaxterm.mobatek.net/
2.	Once installed click the ‘Session’ button in the top left corner
3.	Click ‘SSH’
4.	In the ‘Remote Host’ section, specify the VM name or IP
5.	Click the ‘Network Settings’ Tab
6.	Click the ‘SSH Gateway (jump host)’ button in the middle
7.	Under Gateway Host, specify: eidf-gateway.epcc.ed.ac.uk
8.	Under Username, specify your SAFE Username
9.	Click ‘OK’
10.	Click ‘OK’ to launch the session
11.	For the EIDF-Gateway login prompt, use your SAFE credentials
12.	For the VM login, use your VM credentials from within SAFE


## Accessing From MacOS/Linux

OpenSSH is installed on Linux and MacOS usually by default, so you can access the gateway natively from the terminal. <br>
The '-J' flag is use to specify that we will access the second specified host by jumping through the first specified host like the example below. <br>
$ ssh -J [username]@jumphost [username]@target

To access the EIDF Services; <br>
$ ssh -J [SAFE-username]@eidf-gateway.epcc.ed.ac.uk [VM-username]@[VM/IP]
