# Login

Access to CS3 user-nodes is done using SSH via the EIDF Gateway jump host, as used for accessing EIDF virtual desktop VMs via SSH. This access requires two credentials: an SSH key pair protected by a passphrase **and** a Time-based one-time password (TOTP).

## Set up access credentials

[Set up SSH access](../../access/ssh.md#set-up-ssh-access) in [SSH access via the EIDF Gateway jump host](../../access/ssh.md) describes how to:

* Create an SSH private-public key pair
* Add the public key to your project account
* Get a multi-factor authentication app.
* Set up multi-factor authentication, so you can get a TOTP when you connect.

### Log in to CS3 user-nodes

If your private key file has a default OpenSSH name (e.g., `id_ed25519` or `id_rsa`) then run:

```bash
ssh -J <user>@eidf-gateway.epcc.ed.ac.uk cerebras
```

Alternatively, if your private key file has a custom name defined by you, then run:

```bash
ssh -o ProxyCommand="ssh -i $HOME/.ssh/<key_file> -W %h:%p <user>@eidf-gateway.epcc.ed.ac.uk" -i $HOME/.ssh/<key_file> <user>@cerebras
```

Alternatively, you can add the following definition to an SSH configuration file, `$HOME/.ssh/config`:

```text
Host eidf-gateway-cerebras
    HostName eidf-gateway.epcc.ed.ac.uk
Host cerebras
    HostName cerebras
    ProxyJump eidf-gateway
Host eidf-gateway cerebras
    User <user>
    IdentityFile ~/.ssh/<key_file>
    IdentitiesOnly yes
```

then run:

```bash
ssh cerebras
```

In each case, you will be prompted for your SSH key passphrase, then your TOTP, then your SSH key passphrase again. You will only be prompted for a TOTP code roughly once a day.
