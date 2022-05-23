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
The EIDF-Gateway is a method of accessing EIDF Services through SSH for a terminal experience. The user can connect to their VM through the jump host using their given accounts.
The gateway cannot be 'landed' on, a user can only pass through it. So the destination has to be known for the service to work.
The gateway is currently only accessible from University of Edinburgh IP Addresses, so the appropriate VPN will need to be used if accessing outside of campus.


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
9.	`$ ssh -J [gateway-username]@eidf-gateway.epcc.ed.ac.uk [VM-username]@[VM/IP]`

### Installing MobaXTerm
1.	Download MobaXTerm from https://mobaxterm.mobatek.net/
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
The '-J' flag is use to specify that we will access the second specified host by jumping through the first specified host like the example below.
```
$ ssh -J [username]@jumphost [username]@target
```

To access the EIDF Services;
```
$ ssh -J [gateway-username]@eidf-gateway.epcc.ed.ac.uk [VM-username]@[VM/IP]
```
