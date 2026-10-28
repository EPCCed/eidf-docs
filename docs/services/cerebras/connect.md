# Connect to Cerebras

Access to Cerebras CS3 user-nodes is done using SSH via the EIDF Gateway jump host, as used for accessing EIDF VMs via SSH. This access requires two credentials: an SSH key pair protected by a passphrase **and** a Time-based one-time password (TOTP).

---

## Set up SSH access

[Set up SSH access](../../access/ssh.md#set-up-ssh-access) in [SSH access to EIDF VMs](../../access/ssh.md) describes how to:

1. Create SSH private and public keys on the host from which you want to access the EIDF VM via SSH.
1. Add the public key to your project account within the EIDF Portal.
1. Get a multi-factor authentication app.
1. Set up multi-factor authentication for your project account within the EIDF Portal.

---

## Connect to Cerebras CS3 via SSH

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
    ProxyJump eidf-gateway-cerebras
Host eidf-gateway-cerebras cerebras
    User <user>
    IdentityFile ~/.ssh/<key_file>
    IdentitiesOnly yes
```

then run:

```bash
ssh cerebras
```

In each case, you will be prompted for your SSH key passphrase, then your TOTP, then your SSH key passphrase again. You will only be prompted for a TOTP roughly once a day.
