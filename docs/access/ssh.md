# SSH Access to Virtual Machines Using the EIDF-Gateway Jump Host

The EIDF-Gateway is a method of accessing EIDF Services through SSH for a terminal experience. The user can connect to
their VM through the jump host using their given accounts. The gateway cannot be 'landed' on, a user can only pass
through it. So the destination has to be known for the service to work. The gateway is currently only accessible from
University of Edinburgh IP Addresses, so the appropriate VPN will need to be used if accessing outside of campus.

## Accessing from Windows

Windows will require the installation of OpenSSH-Server or MobaXTerm to use SSH. Putty can also be used but won’t be covered in this tutorial.

### Installing and Using OpenSSH

1. Click the ‘Start’ button at the bottom of the screen
1. Click the ‘Settings’ cog icon
1. Search in the top bar ‘Add or Remove Programs’ and select the entry
1. Select the ‘Optional Features’ blue text link
1. If ‘OpenSSH Client’ is not under ‘Installed Features’, click the ‘Add a Feature’ button
1. Search ‘OpenSSH Client’
1. Select the check box next to ‘OpenSSH Client’ and click ‘Install’
1. Once this is installed, you can reach your VM by opening CMD and running
1. `$ ssh -J [gateway-username]@eidf-gateway.epcc.ed.ac.uk [VM-username]@[VM/IP]`

### Installing MobaXTerm

1. Download MobaXTerm from [https://mobaxterm.mobatek.net/](https://mobaxterm.mobatek.net/)
1. Once installed click the ‘Session’ button in the top left corner
1. Click ‘SSH’
1. In the ‘Remote Host’ section, specify the VM name or IP
1. Click the ‘Network Settings’ Tab
1. Click the ‘SSH Gateway (jump host)’ button in the middle
1. Under Gateway Host, specify: `eidf-gateway.epcc.ed.ac.uk`
1. Under Username, specify your EIDF-Gateway username
1. Click ‘OK’
1. Click ‘OK’ to launch the session
1. For the EIDF-Gateway login prompt, use your EIDF-Gateway credentials
1. For the VM login, use your VM credentials

## Accessing From MacOS/Linux

OpenSSH is installed on Linux and MacOS usually by default, so you can access the gateway natively from the terminal.
The '-J' flag is use to specify that we will access the second specified host by jumping through the first specified
host like the example below.

```shell
$ ssh -J [username]@jumphost [username]@target
password:
```

To access the EIDF Services:

```shell
$ ssh -J [gateway-username]@eidf-gateway.epcc.ed.ac.uk [VM-username]@[VM/IP]
password:
```

You have to configure the SSH config, usually located at `~/.ssh/config`,
to disable strict host key checking and storing the host key for EIDF VMs, as follows:

```bash
Host 10.24.*
     StrictHostKeyChecking no
     UserKnownHostsFile /dev/null
```
