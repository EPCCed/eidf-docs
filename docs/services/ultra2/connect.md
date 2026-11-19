# Connect to Ultra2

Access to Ultra2 is via SSH. This access requires two credentials: an SSH key pair protected by a passphrase **and** a Time-based one-time password (TOTP).

The hostname for SSH access to Ultra2 is `ultra2.eidf.ac.uk`.

---

## Set up SSH access

To set up SSH access to Ultra2:

1. Create SSH private and public keys on the host from which you want to access Ultra2. For example, see [Create SSH private and public keys](../../access/ssh.md#create-ssh-private-and-public-keys) in [SSH access to EIDF VMs](../../access/ssh.md).
1. Add the public key to SAFE, by following SAFE's [How to add an SSH public key to your account](https://epcced.github.io/safe-docs/safe-for-users/#how-to-add-an-ssh-public-key-to-your-account).
1. Get a multi-factor authentication app. For example, see [Get a multi-factor authentication app](../../access/ssh.md#get-a-multi-factor-authentication-app) in [SSH access to EIDF VMs](../../access/ssh.md).
1. Set up multi-factor authentication for your account within SAFE, by following SAFE's [How to turn on MFA on your machine account](https://epcced.github.io/safe-docs/safe-for-users/#how-to-turn-on-mfa-on-your-machine-account).

---

## Connect to Ultra2 via SSH

If your private key file has a default OpenSSH name (e.g., `id_ed25519` or `id_rsa`) then run:

```bash
ssh -J <user>@ultra2.eidf.ac.uk
```

Alternatively, if your private key file has a custom name defined by you, then run:

```bash
ssh -i $HOME/.ssh/<key_file> <user>@ultra2.eidf.ac.uk
```

Alternatively, you can add the following definition to an SSH configuration file, `$HOME/.ssh/config`:

```text
Host ultra2
    User <user>
    HostName ultra2.eidf.ac.uk
    IdentityFile ~/.ssh/<key_file>
    IdentitiesOnly yes
```

then run:

```bash
ssh ultra2
```

In each case, you will be prompted for your SSH key passphrase, then your TOTP. You will only be prompted for a TOTP roughly once a day.
