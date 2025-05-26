# Connecting to a Virtual Machine with a Remote Desktop Client

## Ensure RDP is running on host machine

```bash
systemctl status xrdp
```

Expecting that the status to contain Active: active (running). Example output:

```bash
~$ systemctl status xrdp
● xrdp.service - xrdp daemon
     Loaded: loaded (/lib/systemd/system/xrdp.service; enabled; vendor preset: >
     Active: active (running) since ...
       Docs: man:xrdp(8)
             man:xrdp.ini(5)
   Main PID: 701 (xrdp)
   [...]
```

## Setup Port Forwarding on the Client machine

> [!Note]
> We need to setup port forwarding to get through the EIDF gateway. Whilst some remote desktop viewers support gateways they do not always work (e.g. windows app for macOS does not support ssh keys)

Setup a Port forwarding such that the RDP port on the remote desktop (3389) is forwarded to localhost (in this example we use 23001).

> [!Warning] Port on local machine must be unused
> Ports are usable by one process only as such must check that the port is not in use before doing above, **typically** port 23001 is unused. Checking if a port is in use is client device OS specific

```shell
ssh -N -J <gateway username>@eidf-gateway.epcc.ed.ac.uk -L 23001:<VDI machine IP>:3389 <VDI username>@<VDI machine IP>
```

## Install and configure remote desktop viewer

Different distributions have different software solutions for remote desktop connections. You may also have your own preferred software. General, Mac and Windows based instructions are given below

### Windows

[Remote Desktop Connection](https://support.microsoft.com/en-gb/windows/how-to-use-remote-desktop-5fe128d5-8fb1-7a23-3b8a-41e636865e8c) (link from step 2) (preinstalled)

1. Open the Remote Desktop Connection tool (`mstsc` in Run)
2. Input `localhost:<port forwarded to>` e.g. `localhost:23001` as the connection name
   ![[Windows Remote Desktop.png]]
3. Input VDI login at the Login screen

### MacOS

1. Use [Microsoft Windows App](https://learn.microsoft.com/en-us/windows-app/) (app store)

> [!Note]
> Whilst MacOS has its own built in remote desktop viewer, I could not get this to work as I cannot pass the ssh identity file to the viewer ( #EIDF/ToDo Try and get to work).

1. Open the Windows App -> Click '+' -> Add PC
1. Input into 'PC Name' the forwarded port on the local machine `localhost:23001` ![[IP input.png]]
1. Also add a 'friendly name' to describe the device being connected to
1. Leave all other options as defaults at this stage
1. Click Add
1. Double click on the newly created PC to connect
1. You will be prompted for the VDI username and password

### Linux & General instructions

[Remmina](https://remmina.org/) (package manager)

Connect to forwarded port in remote viewer on client machine

```text
PC Name: localhost:23001
Credentials: Ask when required (or input your credentials for VDI machine)
Friendly Name: EIDF124 Remote Connection
```

Click on the newly created connection, you may have to input your credentials, read through warnings.
