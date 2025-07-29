# RDP tunnelling over SSH

RDP tunneling is a technique that relies on SSH to create a secure channel that forwards local traffic to a remote server's RDP port. The content of the local traffic in RDP tunneling includes:

- User Input: Keyboard and mouse actions.
- Display Data: Screen updates and graphical interface data.
- Clipboard Contents: Text or files copied and pasted between the local and remote systems.
- File Transfers: Transferred files if drive redirection is enabled.

By setting up an SSH tunnel, a local port is forwarded to the remote server's RDP port (3389). The RDP client is then connected to `localhost:<local_port>`, ensuring that the RDP session is encrypted.

## SSH Commands

### Steps

1. Jump host (-J): connect first to the eidf_gateway as an intermediary before reaching the target VM. Authentication is achieved using the identity file provided by the host (-i).

2. Local Port Forwarding (-L): Forwards local port 12345 to localhost:3389 on the remote machine, allowing RDP access via localhost:12345.

3. Configure a RDP client (for example 'Windows App') to connect to `localhost:<local_forwarded_port>` instead of directly accessing the remote machine's IP. Then connect on the remote server as 'username'.

### Example

Connect to eidf666 (IP address 10.24.2.224) as user u666

```sh
ssh -J u666@eidf-gateway.epcc.ed.ac.uk -i ~/.ssh/eidf666-vm -o ServerAliveInterval=900 -L 39001:localhost:3389 u666@10.24.2.224
```

Defaults like PubkeyAuthentication=yes, PasswordAuthentication=yes, ForwardAgent=yes, ForwardX11=yes, and ForwardX11Trusted=yes are omitted.

Once the connection is established, on Windows App or similar use pc name: `localhost:39001`. When prompted, the username will be 'u666' with corresponding password.

### SSH Configuration

All of the above can also be achieved adding the following to the SSH `.config` file:

```sh
host eidf666_gateway
    Hostname eidf-gateway.epcc.ed.ac.uk
    User u666
    IdentityFile ~/.ssh/eidf666-vm

host eidf666_rdp
    Hostname 10.24.2.224
    User u666
    PubKeyAuthentication yes
    PasswordAuthentication yes
    IdentityFile ~/.ssh/eidf666-vm
    ProxyJump eidf666_gateway
    ServerAliveInterval 900
    ForwardAgent yes
    ForwardX11 yes
    ForwardX11Trusted yes
    LocalForward 39001 localhost:3389
```

Can then use the command 'ssh eidf666_rdp' to create the connection.
