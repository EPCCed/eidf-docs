# Remote desktop client access via SSH

The [EIDF Virtual Desktop Interface (VDI)](./virtualmachines-vdi.md) provides a way of using EIDF VMs via SSH or remote desktop sessions run within your browser. On this page an alternative is described, using a remote desktop client running on your local host to connect to a remote desktop service running on your EIDF VM.

Using a remote desktop client can be both more usable and useful than the VDI for long periods of work. Remote desktop clients can offer a a sharper display than the VDI, better support for copying and pasting, and support for file sharing and other features that may not be available via the VDI.

!!! Tip "Try the VDI first"

    It is strongly recommended that you, initially at least, try using EIDF VMs via remote desktop connections supported by the [EIDF Virtual Desktop Interface (VDI)](./virtualmachines-vdi.md) as the steps to access the remote desktop via the VDI are far more straightforward than those to use a remote desktop client.

!!! Note "Remote desktop client connection security"

    Interactions with the remote desktop client on your local host are securely forwarded, or 'tunnelled', via SSH, to the remote desktop service on your EIDF host, and vice-versa. All your interactions with the remote desktop, including keyboard and mouse clicks, the display state, clipboard contents and files (if drive redirection is enabled) are encrypted.

---

## Set up SSH access to your EIDF VM and configure port forwarding

To connect to a remote desktop service running on your EIDF VM you need to both:

1. Set up SSH access.
1. Connect to the EIDF VM via SSH, forwarding ports from a custom port on your local host to the remote desktop service port, 3389, on your EIDF VM.

See [SSH access via the EIDF Gateway jump host](./ssh.md) for instructions on how to:

* Set up SSH access.
* Connect to an EIDF VM via SSH.
* Access services on an EIDF VM via port forwarding and SSH tunnelling.
* Write an SSH configuration file.
* Specify port forwarding within the SSH configuration file.

!!! Note "Limitations of some remote desktop clients"

    Whilst some remote desktop clients support access to VMs via jump hosts, some clients to not support everything required to connect to an EIDF VM via the EIDF Gateway. For example, the [Windows App](https://apps.apple.com/us/app/windows-app/id1295203466) for MacOS does not support connections via SSH keys. This is why accessing your EIDF VM via SSH, and configuring port forwarding, is also required.

---

## Install a remote desktop client

### Linux

[Remmina](https://remmina.org) is a remote desktop client for Linux. Under Ubuntu, Remmina can be installed by running:

```bash
sudo apt install -y remmina remmina-plugin-rdp remmina-plugin-secret
```

For other Linux flavours, see Remmina's [How to install Remmina](https://remmina.org/how-to-install-remmina/).

### Windows

Windows provides a built-in remote desktop client, Remote Desktop Connection.

### MacOS

[Windows App](https://apps.apple.com/us/app/windows-app/id1295203466) is a free remote desktop client for MacOS. Despite its name, it can be used to connect to Linux VMs also.

---

## Connect to the EIDF VM via SSH

If you are not using an SSH configuration file, then run the 'ssh' command described in [SSH access via the EIDF Gateway jump host](./ssh.md):

```bash
ssh -o ProxyCommand="ssh -i $HOME/.ssh/id_ed25519_eidf<project_id> -W %h:%p <user>@eidf-gateway.epcc.ed.ac.uk" -i $HOME/.ssh/id_ed25519_eidf<project_id> <user>@<host_ip> -L <local_port>:localhost:<eidf_vm_port>
```

where:

* `<project_id>` is your EIDF project ID.
* `<user>` is your project account username.
* `<host_ip>` is the IP address of the EIDF VM. IP addresses of EIDF VMs which your account can access can be found in the 'Your Accounts' table on your project's page in the [EIDF Portal](https://portal.eidf.ac.uk/).
* `-o ProxyCommand="..."` requests a connection to the EIDF Gateway.
* `-i` specifies your private key file.
* `-W %h:%p` requests that the EIDF Gateway forward standard input and output to the EIDF VM.
* `<local_port>` is a port on your local host.
* `localhost` refers to your EIDF VM.
* `<eidf_vm_port>` is a port on your EIDF host.

For example

```bash
ssh -o ProxyCommand="ssh -i $HOME/.ssh/id_ed25519_eidf000 -W %h:%p some-eidf-user@eidf-gateway.epcc.ed.ac.uk" -i $HOME/.ssh/id_ed25519_eidf000 some-eidf-user@10.24.999.999 -L 23001:localhost:3389
```

If you using an SSH configuration file of the format described in [SSH access via the EIDF Gateway jump host](./ssh.md) i.e.:

```text
Host eidf-gateway<project_id>
    HostName eidf-gateway.epcc.ed.ac.uk
Host <host_name>
    HostName <host_ip>
    ProxyJump eidf-gateway<project_id>
Host eidf-gateway<project_id> <host_name>
    User <user>
    IdentityFile ~/.ssh/id_ed25519_eidf<project_id>
    IdentitiesOnly yes
    LocalForward <local_port> localhost:<eidf_vm_port>
    ServerAliveInterval 60
```

For example:

```text
Host eidf-gateway000
    HostName eidf-gateway.epcc.ed.ac.uk
Host eidf000-vm
    HostName 10.24.999.999
    ProxyJump eidf-gateway000
Host eidf-gateway000 eidf000-vm
    User some-eidf-user
    IdentityFile ~/.ssh/id_ed25519_eidf000
    IdentitiesOnly yes
    LocalForward 23001 localhost:3389
    ServerAliveInterval 60
```

then, run the 'ssh' command:

```bash
ssh <host_name>
```

For example:

```bash
ssh eidf000-vm
```

---

## Connect to the EIDF VM remote desktop service via a remote desktop client

Though specific remote desktop clients vary, the following settings are common to many clients:

* Remote desktop server host name and port. As port forwarding is being used, for EIDF VMs the host and port is `localhost:<local_port>` e.g., `localhost:23001`.
* Protocol. 'RDP' or 'Remote Desktop'.
* Memorable name for the connection. One option is to enter a enter a name including the EIDF VM `<host_name>` e.g., `eidf000-vm (SSH/RDP)`.
* Username and password. This will be your EIDF VM username and password.

!!! Tip "Caching usernames and passwords"

    It is recommend that initially you do not cache these values, but instead enter them when the connection is established, or alternatively that you select any 'Ask when required' option, if offered. This allows you to check that you can successfully set up a remote desktop session with your EIDF VM.

    If caching passwords, you should check out the documentation for the remote desktop client you are using, to see how passwords are cached, and how securely.

!!! Warning "Do not leave your remote desktop client session unattended"

    Once a remote desktop client has connected to the EIDF VM, you have access to your EIDF VM as though it was an application running on your local host. You should not leave your local host unlocked while connected to an EIDF VM as this risks both your local host and EIDF VM being accessed by unauthorised users!

### Connect using Remmina on Linux

To run Remmina:

1. Run:

    ```bash
    remmina
    ```

1. The Remmina Remote Desktop Client will appear.

To connect to a remote desktop service in the Remmina Remote Desktop Client:

1. Click **+** (New Connection Profile), on the top-left of the client.
1. A 'Remote Connection Profile' dialog will appear.
1. Enter **Name**: enter a memorable name for the connection.
1. Select **Protocol**: RDP - Remote Desktop Protocol.
1. Enter **Server**: `localhost:<local_port>` e.g., `localhost:23001`
1. Click **Save and Connect**.
1. An 'Enter RDP authentication credentials' dialog will appear.
1. Enter **Username** and **Password**: your EIDF VM username and password.
1. Click **OK**.
1. A window will appear with a remote desktop for your EIDF VM.

To reconnect to a remote desktop service in the Remmina Remote Desktop Client:

1. Double-click on on the row for your remote desktop connection.
1. An 'Enter RDP authentication credentials' dialog will appear.
1. Enter **Username** and **Password**: your EIDF VM username and password.
1. Click **OK**.
1. A window will appear with a remote desktop for your EIDF VM.

To cache your username and, if desired, password in the Remmina Remote Desktop Client:

1. Right-click on the row for your remote desktop connection, select **Edit**.
1. The 'Remote Connection Profile' dialog will appear.
1. Enter **Username** and **Password**: your EIDF VM username and password.
1. Click **OK**.
1. A window will appear with a remote desktop for your EIDF VM.

### Connect using Remote Desktop Connection on Windows

To connect to a remote desktop service using Remote Desktop Connection:

1. Click Windows **Start** or **Search**.
1. Enter 'Remote Desktop Connection' or `mstsc` in the search field.
1. Click **Remote Desktop Connection** when it appears.
1. The 'Remote Desktop Connection' dialog will appear.
1. Enter **Computer**: `localhost:<local_port>` e.g., `localhost:23001`
1. Click **Connect**.
1. A 'The identity of the remote computer cannot be verified. Do you want to connect anyway?' dialog will appear.
1. Click **Yes**.
1. A window will appear with a remote desktop for your EIDF VM.
1. Log in using your EIDF VM username and password.

### Connect using Windows App on MacOS

To connect to a remote desktop service using Windows app:

1. Open the Windows App
1. Click **+**, select **Add PC**.
1. The 'Add PC' dialog will appear.
1. Enter **PC Namer**: `localhost:<local_port>` e.g., `localhost:23001`
1. Enter **Friendly name**: : enter a memorable name for the connection.
1. Select **Reconnect if the connection is dropped**.
1. Click **Add**.
1. Double-click on on the row for your remote desktop connection.
1. You will be prompted for your EIDF VM username and password.
