# SSH access via the EIDF Gateway jump host

EIDF virtual machines (VMs) can be accessed via SSH from a terminal or console on your own host. SSH offers an alternative to using the [EIDF Virtual Desktop Interface (VDI)](virtualmachines-vdi.md) to access the EIDF VMs.

Access to EIDF VMs via SSH uses the EIDF Gateway, a secure 'jump host' which is accessible from anywhere which manages authorised connections from arbitrary hosts to EIDF VMs.

!!! Important "SSH access prerequisites"

    You can only access an EIDF VM via SSH and the EIDF Gateway if your project lead has granted you permission to access both the VM and the EIDF Gateway.

!!! Note "SSH access is not the same as SSH via the EIDF Virtual Desktop Interface"

    You may have noticed that the EIDF Virtual Desktop Interface allows you to create an SSH session. This is not the same as running an SSH session from your local host, that is described on this page. An SSH session run within the VDI offers the same look-and-feel as an actual SSH session but there is no SSH connection from your local host to an EIDF VM.

SSH (OpenSSH) is available under Linux, Windows 11 (Windows Subsystem for Linux, Powershell, or Git Bash) and MacOS. Unless noted otherwise, all commands on this page can be run under any of these environments.

---

## Set up SSH access

To access an EIDF VM via SSH from your terminal or console, you will need:

1. An EIDF project account to have been created for you.
1. Access to the project VM to have been granted for your project account.
1. Access to the EIDF Gateway, eidf-gateway.epcc.ed.ac.uk, to have been granted.

The above steps need to be done by your project lead.

Once your account has been created and access granted, you need to set up your SSH access as follows:

1. [Create an SSH private-public key pair](#create-an-ssh-private-public-key-pair) on the host from which you want to access the EIDF VM via SSH.
1. [Add the public key to your project account](#add-the-public-key-to-your-project-account) within the EIDF Portal.
1. [Get a multi-factor authentication app](#get-a-multi-factor-authentication-app).
1. [Set up multi-factor authentication](#set-up-multi-factor-authentication) for your project account within the EIDF Portal.

Once you have done these setup steps, you can [connect to your EIDF VM via SSH](#connect-to-an-eidf-vm-via-ssh).

### Create an SSH private-public key pair

To create a SSH private-public key pair on the host from which you want to access the EIDF VM via SSH:

1. Create a `$HOME/.ssh` directory if one does not exist:

    Linux, Windows (Git Bash, Windows Subsystem for Linux), MacOS:

    ```bash
    mkdir -p $HOME/.ssh
    ```

    Windows (Powershell):

    ```powershell
    mkdir -Force $HOME/.ssh
    ```

1. Create an SSH private-public key pair:

    ```bash
    ssh-keygen -C '<comment>' -f $HOME/.ssh/<key_file>
    ```

    where:

    * `-C <comment>` is a comment added to the public key that is created, A suitable value for `<comment>` can be your email address, or a username and local host name (e.g., `some-user-laptop` or `some-user-cirrus`), Alternatively, `-C '<comment>'` can be omitted, and the default comment of `<user>@<host>` will be used.
    * `-f <key_file>` specifies the private key file path.

    For example:

    ```bash
    ssh-keygen -C 'some-user@somedept.ed.ac.uk' -f $HOME/.ssh/id_ed25519_eidf000
    ```

    !!! Tip "Naming the private key file"

        It is recommended that the private file name include both the default algorithm used to create the key, `ed25519`, and the EIDF project number, `<project_id>` i.e., `<key_file>` is `id_ed25519_eidf<project_id>`. This can be useful if you have multiple keys for multiple projects or for other services. However, your choice of key name is up to you.

1. You will be prompted to enter, then re-enter a passphrase to protect your private key. For example:

    ```bash
    Generating public/private ed25519 key pair.
    Enter passphrase for "/home/some-user/.ssh/id_ed25519_eidf000" (empty for no passphrase):
    Enter same passphrase again:
    ```

    Whenever you use the private key, you will be prompted for the passphrase.

    !!! Tip "Use a unique non-empty passphrase"

        It is **strongly recommended** that you use a unique, **non-empty**, passphrase for each key that your create.

1. Private and public key files will be created in your `.ssh` directory:

    ```text
    Your identification has been saved in /home/some-user/.ssh/id_ed25519_eidf000
    Your public key has been saved in /home/some-user/.ssh/id_ed25519_eidf000.pub
    ...
    ```

    The files are:

    * `.ssh/<key_file>`, the private key file, which includes the private key itself. **Do not** share your private key with anyone.
    * `.ssh/<key_file>.pub`, a complementary public key file, which shares the private key file name with a `.pub` suffix. The public key file has content:

        ```text
        <key_type> <base64_encoded_public_key> <comment>
        ```

        The default `<key_type>` is `ssh-ed25519`.

### Add the public key to your project account

To add the public key to your project account:

1. On the [Your Projects](https://portal.eidf.ac.uk/project) page within the [EIDF Portal](https://portal.eidf.ac.uk/), click your project.
1. Your selected project's page will appear.
1. Within the 'Your Accounts' table, click your account username.
1. Your 'User Account Info' page will appear.
1. Under 'Credentials', click the **+ (plus)** button.
1. Either, the paste contents of the public key file, `$HOME/.ssh/<key_file>.pub`, into the **Credential** field.
1. Or, click **Choose File** and select the public key file, `$HOME/.ssh/<key_file>.pub`
1. Click **Upload Credential**.
1. The 'User Account Info' page will reappear.
1. Your public key will be shown in the 'Credentials' table. An excerpt of the start of the public key will be shown under 'Credential' and the public key's comment will be shown under 'Identifier'.
1. Initially, the public key will have a 'Status' of 'Pending'. If you refresh the page, the 'Status' will eventually update to 'Active'.

!!! Warning "Delay in public key being usable"

    There may be a lag, possibly of a few minutes, between a public key being added and it being usable, even if the public key is marked as 'Active'. This is due to the time taken for the update to be reflected across the EIDF infrastructure.

### Get a multi-factor authentication app

To provide additional security, the EIDF Gateway uses multi-factor authentication (MFA). When you access an EIDF VM with the EIDF Gateway you will be prompted not only for your private key's passphrase but also for a time-based one-time password (TOTP) code. To provide this password you will need to have installed a suitable authenticator app on your mobile device. There are many such apps available. Popular options include:

* [Apple Passwords app](https://support.apple.com/en-gb/120758)
* [Google Authenticator](https://play.google.com/store/apps/details?id=com.google.android.apps.authenticator2)
* [Microsoft Authenticator](https://www.microsoft.com/en-gb/security/mobile-authenticator-app)

!!! Note "Your mobile device and EIDF"

    Use of these apps does not require you to register your mobile device with the EIDF infrastructure. Instead, these apps rely on the use of a shared secret between the EIDF infrastructure and the app. How this secret is shared is described in the next section.

### Set up multi-factor authentication

To set up multi-factor authentication for your project account within the EIDF Portal:

1. On the [Your Projects](https://portal.eidf.ac.uk/project) page within the [EIDF Portal](https://portal.eidf.ac.uk/), click your project.
1. Your selected project's page will appear.
1. Within the 'Your Accounts' table, click your account username.
1. Your 'User Account Info' page will appear.
1. Click **Set MFA Token**.
1. The 'Set MFA token' page will appear. This will show both a QR code and a **Key** field with a complementary key.
1. Within your authenticator app, either scan the QR code or enter the key value.
1. Your authenticator app will add an entry for your project account username and display a TOTP code.
1. Enter the TOTP code from your authenticator app into the **Verification code** field.
1. Click **Set Token**.
1. The 'User Account Info' page will reappear, with the text 'Added MFA Token'. The 'MFA token' entry on the 'User Account Info' page will show a tick/check mark.

---

## Connect to an EIDF VM via SSH

To connect to an EIDF VM via SSH:

1. Run:

    ```bash
    ssh -o ProxyCommand="ssh -i $HOME/.ssh/<key_file> -W %h:%p <user>@eidf-gateway.epcc.ed.ac.uk" -i $HOME/.ssh/<key_file> <user>@<host_ip>
    ```

    where:

    * `-i` specifies your private key file.
    * `<key_file>` is your private key file.
    * `<user>` is your project account username.
    * `<host_ip>` is the IP address of the EIDF VM. IP addresses of EIDF VMs which your account can access can be found in the 'Your Accounts' table on your project's page in the EIDF Portal.
    * `-o ProxyCommand="..."` requests a connection to the EIDF Gateway.
    * `-W %h:%p` requests that the EIDF Gateway forward standard input and output to the EIDF VM.

    For example:

    ```bash
    ssh -o ProxyCommand="ssh -i $HOME/.ssh/id_ed25519_eidf000 -W %h:%p some-eidf-user@eidf-gateway.epcc.ed.ac.uk" -i $HOME/.ssh/id_ed25519_eidf000 some-eidf-user@10.24.999.999
    ```

1. The first time that you connect to the EIDF Gateway you will be asked if you want to connect. For example:

    ```bash
    The authenticity of host 'eidf-gateway.epcc.ed.ac.uk (129.215.62.65)' can't be established.
    ED25519 key fingerprint is SHA256:........
    This key is not known by any other names.
    Are you sure you want to continue connecting (yes/no/[fingerprint])?
    ```

1. Enter `yes`.
1. When you connect to the EIDF Gateway, a welcome message will be displayed. You will then be prompted for your private key's passphrase, to log into the EIDF Gateway. For example:

    ```bash
    Enter passphrase for key '/home/some-user/.ssh/id_ed25519_eidf000':
    ```

1. Enter your private key's passphrase.
1. The first time that you connect to an EIDF VM each day, you will be prompted for a TOTP code. For example:

    ```bash
    Expecting a code for eidf-ipa:some-user

    (some-eidf-user@eidf-gateway.epcc.ed.ac.uk) TOTP code:
    ```

1. Open your authenticator app, and enter the TOTP code shown.
1. The first time you connect to the EIDF VM, you will be asked if you want to connect. For example:

    ```text
    The authenticity of host '10.24.999.999 (<no hostip for proxy command>)' can't be established.
    ED25519 key fingerprint is SHA256:........
    This key is not known by any other names.
    Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
    ```

1. Enter `yes`.
1. You will again be prompted for your private key's passphrase, this time to log into the EIDF VM. For example:

    ```bash
    Enter passphrase for key '/home/some-user/.ssh/id_ed25519_eidf000':
    ```

1. Again, enter your private key's passphrase.
1. All going well, you will be logged into the EIDF VM and its prompt will appear.

What you are prompted for depends upon when you SSH into an EIDF VM via the EIDF Gateway as shown in the table below:

| When | Connect to EIDF Gateway? | Passphrase | Connect to EIDF VM? | TOTP code | Passphrase |
| ---- | ------------------------ | ---------- | ------------------- | --------- | ---------- |
| First connection via SSH ever | &#10004; | &#10004; | &#10004; | &#10004; | &#10004; |
| First connection via SSH on a specific day | | &#10004; | | &#10004; | &#10004; |
| Subsequent connection via SSH on the same day | | &#10004; | | | &#10004; |

As the 'ssh' connection command is verbose, you can [Write an SSH configuration file](#write-an-ssh-configuration-file), described below, to reduce the verbosity.

### Troubleshooting: 'Warning: Identity file .ssh/id_ed25519_eidf000 not accessible: No such file or directory'

If you see an error like:

```text
Warning: Identity file /home/some-user/.ssh/id_ed25519_eidf000 not accessible: No such file or directory.
Warning: Identity file /home/some-user/.ssh/id_ed25519_eidf000 not accessible: No such file or directory.
...
some-eidf-user@eidf-gateway.epcc.ed.ac.uk: Permission denied (publickey).
Connection closed by UNKNOWN port 65535
```

then this means that your private key file could not be found on your local host.

### Troubleshooting: 'Permission denied (publickey)'

If you see an error like:

```text
some-eidf-user@eidf-gateway.epcc.ed.ac.uk: Permission denied (publickey).
Connection closed by UNKNOWN port 65535
```

then this means that your public key is not known to the EIDF Gateway.

!!! Warning "Delay in public key being usable"

    There may be a lag, possibly of a few minutes, between a public key being added and it being usable, even if the public key is marked as 'Active'. This is due to the time taken for the update to be reflected across the EIDF infrastructure.

### Troubleshooting: 'No MFA key for this user'

If you see an error like:

```text
No MFA key for this user
```

then you need to [Set up multi-factor authentication](#set-up-multi-factor-authentication) for your project account within the EIDF Portal.

### Troubleshooting: Multiple prompts to 'Enter passphrase'

You can expect to be prompted for your private key's passphrase twice. If you are prompted more than twice then this implies that you have entered the wrong passphrase.

For each passphrase prompt - to access the EIDF Gateway and to access the EIDF VM - you have three attempts.

If you fail all three attempts when prompted by the EIDF Gateway, you will see:

```text
some-eidf-user@eidf-gateway.epcc.ed.ac.uk: Permission denied (publickey).
Connection closed by UNKNOWN port 65535
```

If you fail all three attempts when prompted by the EIDF VM, you will see:

```text
(some-eidf-user@10.24.999.999) Password:
```

i.e., you will be prompted for your EIDF VM password. If you have set an EIDF VM password (as described in [Set or change the password for a user account](../services/virtualmachines/quickstart.md#set-or-change-the-password-for-a-user-account)), then you can use it. If not, then you will need to try connecting again, remembering to use the correct passphrase.

---

## Access services on an EIDF VM via port forwarding and SSH tunnelling

There may be services running on your EIDF VM what you want to connect to from your local host. This can be done via port forwarding and SSH tunnelling. A common example is connecting to your EIDF VM's remote desktop service, if available, from a remote desktop client running on your local host (as described in [Remote desktop client access via SSH](./ssh-rdp.md)).

For each port you want to access on your EIDF VM, add a parameter of form `-L <local_port>:localhost:<eidf_vm_port>` to your 'ssh' command, where `<local_port>` is a port on your local host, `localhost` refers to your EIDF VM, and `<eidf_vm_port>` is a port on your EIDF host:

```bash
ssh -o ProxyCommand="ssh -i $HOME/.ssh/<key_file> -W %h:%p <user>@eidf-gateway.epcc.ed.ac.uk" -i $HOME/.ssh/<key_file> <user>@<host_ip> -L <local_port>:localhost:<eidf_vm_port>
```

Interactions with the local port on your local host are securely forwarded, or 'tunnelled', to the port on your EIDF host.

For example, in the following, the port 23001 on a user's local host is forwarded to the remote desktop service port 3389 on their EIDF VM:

```bash
ssh -o ProxyCommand="ssh -i $HOME/.ssh/id_ed25519_eidf000 -W %h:%p some-eidf-user@eidf-gateway.epcc.ed.ac.uk" -i $HOME/.ssh/id_ed25519_eidf000 some-eidf-user@10.24.999.999 -L 23001:localhost:3389
```

Multiple `-L` parameters can be used, if required. For example:

```bash
ssh ... -L 23001:localhost:3389 -L 18192:localhost:8192
```

---

## Write an SSH configuration file

The command to [connect to the EIDF VM via SSH](#connect-to-an-eidf-vm-via-ssh), described above, is very verbose:

```bash
ssh -o ProxyCommand="ssh -i $HOME/.ssh/<key_file> -W %h:%p <user>@eidf-gateway.epcc.ed.ac.uk" -i $HOME/.ssh/<key_file> <user>@<host_ip>
```

An SSH configuration file can be used to specify some, or all, of these parameters and so reduce the verbosity of this command.

Create a file, `$HOME/.ssh/config`, with the following content, or, if you already have an `$HOME/.ssh/config` file, then add the following content, where:

* `<project_id>` is your EIDF project ID.
* `<host_name>` is the name of the EIDF VM. Host names and IP addresses of EIDF VMs which your account can access can be found in the 'Your Accounts' table on your project's page in the EIDF Portal.
* `<host_ip>` is the IP address of the EIDF VM.
* `<user>` is your project account username.

```text
Host eidf-gateway<project_id>
    HostName eidf-gateway.epcc.ed.ac.uk
Host <host_name>
    HostName <host_ip>
    ProxyJump eidf-gateway<project_id>
Host eidf-gateway<project_id> <host_name>
    User <user>
    IdentityFile ~/.ssh/<key_file>
    IdentitiesOnly yes
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
```

In the configuration above:

* `Host eidf-gateway<project_id>` includes configuration parameters specific to the EIDF Gateway only.
* `Host <host_name>` includes configuration parameters specific to the EIDF VM only.
* `Host eidf-gateway<project_id> <host_name>` includes configuration parameters common to both.

One the SSH configuration file has been edited, to connect to a EIDF VM via SSH, run:

```bash
ssh <host_name>
```

For example:

```bash
ssh eidf000-vm
```

### About the SSH configuration file

The SSH configuration file parameters are as follows (from [ssh_config](https://man7.org/linux/man-pages/man5/ssh_config.5.html)):

* `Host`, pattern that matches to host names provided on the command-line when running 'ssh'.
* `User`, username to log in as.
* `HostName`, actual host name or IP address.
* `IdentityFile`, private key file.
* `IdentitiesOnly yes`, require that only the key specified in `IdentityFile` be used. This is of use if you [Cache private keys using 'ssh-agent'](#cache-private-keys-using-ssh-agent). By default, an 'ssh-agent' will try every private key it knows about in turn which, if there are many keys, can raise a 'Too many authentication failures' error. This SSH configuration file parameter tells the 'ssh-agent' to only use this key.
* `ProxyJump`, jump proxy.

When `ssh <host_name>` is run, the following happens:

* A search is done in the SSH configuration file for all blocks whose `Host` includes the pattern `<host_name>` and the configuration parameters from all matching blocks are aggregated. This gives the following parameters for `<host_name>`, that is, everything needed to connect to the EIDF VM at `<host_ip>` via the EIDF Gateway:

    ```text
    HostName <host_ip>
    ProxyJump eidf-gateway<project_id>
    User <user>
    IdentityFile ~/.ssh/<key_file>
    IdentitiesOnly yes
    ```

* As these configuration parameters include a `ProxyJump`, a search is done for all blocks whose `Host` includes the pattern `eidf-gateway<project_id>` and, again, the parameters are aggregated. This gives the following parameters for `eidf-gateway<project_id>`, that is, everything needed to connect to the EIDF Gateway:

    ```text
    HostName eidf-gateway.epcc.ed.ac.uk
    User <user>
    IdentityFile ~/.ssh/<key_file>
    IdentitiesOnly yes
    ```

* A connection is made to the EIDF Gateway, using the username (`User`) and private key (`IdentityFile`), and then on to the EIDF VM, again, using the username (`User`) and private key (`IdentityFile`).

### Specify port forwarding

If using a SSH configuration file, you can still forward ports by using `-L <local_port>:localhost:<eidf_vm_port>` parameters:

```bash
ssh <host_name> -L <local_port>:localhost:<eidf_vm_port>
```

For example:

```bash
ssh eidf000-vm -L 23001:localhost:3389
```

To save typing, you can add port forwarding parameters to the EIDF VM's host block in your SSH configuration file, using the `LocalForward` parameter. An additional SSH parameter, `ServerAliveInterval`, is also useful, to configure SSH to regularly request a response from the server which can help to avoid connection timeouts:

```text
    LocalForward <local_port> localhost:<eidf_vm_port>
    ServerAliveInterval <interval_in_seconds>
```

For example:

```text
Host eidf000-vm
    HostName 10.24.999.999
    ProxyJump eidf-gateway000
    LocalForward 23001 localhost:3389
    ServerAliveInterval 60
```

Multiple `LocalForward` parameters can be used, if required. For example:

```text
Host eidf000-vm
    HostName 10.24.999.999
    ProxyJump eidf-gateway000
    LocalForward 23001 localhost:3389
    LocalForward 18192 localhost:8192
    ServerAliveInterval 60
```

### Add other hosts for the same project

To add other hosts for the same project, add a new `Host` block for the host, with `HostName` and `ProxyJump` parameters for the host, and edit the `Host eidf-gateway<project_id> <host_name>` pattern to add the new host name. For example, the following adds to the example above content for another project host `<other_host>` with IP address `<other_host_ip>`:

```text
Host eidf-gateway<project_id>
    HostName eidf-gateway.epcc.ed.ac.uk
Host <host_name>
    HostName <host_ip>
    ProxyJump eidf-gateway<project_id>
Host <other_host_name>
    HostName <other_host_ip>
    ProxyJump eidf-gateway<project_id>
Host eidf-gateway<project_id> <host_name> <other_host_name>
    User <user>
    IdentityFile ~/.ssh/<key_file>
    IdentitiesOnly yes
```

### Add hosts for other project(s)

If you have access to EIDF VMs in multiple projects, then you can add entries for each project using the template given at the start of this [Write an SSH configuration file](#write-an-ssh-configuration-file) section, and replacing `<project_id>` and `<key_file>` with the appropriate EIDF VM project ID and private key file name in each case.

---

## Cache private keys using 'ssh-agent'

'ssh-agent' is an SSH key manager which caches decrypted private keys in-memory. You can add private keys to the 'ssh-agent' and, once you've provided your passphrase to decrypt the key, you will not be prompted for that private key's passphrase again when using the private key until either you remove the private key from the 'ssh-agent' or the 'ssh-agent' is stopped.

### Start the 'ssh-agent'

To start the 'ssh-agent':

1. Check if the 'ssh-agent' is running:

    ```bash
    ssh-add -l
    ```

    If the output is `The agent has no identities.`, then the 'ssh-agent' is running.

    If the output is either of the following, then the 'ssh-agent' is not running:

    * Linux, Windows (Git Bash, Windows Subsystem for Linux), MacOS: `Could not open a connection to your authentication agent.`
    * Windows (Powershell): `Error connecting to agent: No such file or directory`

1. Start the 'ssh-agent' if it is not running:

    Linux, Windows (Git Bash, Windows Subsystem for Linux), MacOS:

    ```bash
    eval $(ssh-agent)
    ```

    Windows (Powershell), as Administrator:

    ```powershell
    Get-Service -Name ssh-agent | Set-Service -StartupType Manual
    Start-Service -Name ssh-agent
    Get-Service -Name ssh-agent
    ```

### Add a private key to the 'ssh-agent'

To add a private key to the 'ssh-agent':

1. Run:

    ```bash
    ssh-add $HOME/.ssh/<key_file>
    ```

    For example:

    ```bash
    ssh-add $HOME/.ssh/id_ed25519_eidf000
    ```

1. You will be prompted for your private key's passphrase. For example:

    ```bash
    Enter passphrase for /home/someuser/.ssh/id_ed25519_eidf000
    ```

1. Enter your private key's passphrase.
1. The private key will be added and a message displayed which includes the comment from when you created your key. For example:

    ```text
    Identity added: /home/someuser/.ssh/id_ed25519_eidf000 (some-user@somedept.ed.ac.uk)
    ```

Now, when you connect to a EIDF VM via the 'ssh' command, if SSH finds your private key in the 'ssh-agent', then it will not prompt you to enter your private key's passphrase.

### List the keys currently cached by the 'ssh-agent'

To list the keys currently cached by the 'ssh-agent':

1. Run:

    ```bash
    ssh-add -L
    ```

1. A list of public keys corresponding to the private keys will be displayed. For example:

    ```text
    ssh-ed25519 AABACHRza72l6Q31ZTD5ABAEIB/kq6tgG4chsEgI7BhGDhngFJ6SyjgU4Q53S3tGpmya some-user@somedept.ed.ac.uk
    ```

    If there are no private keys, then the output will be:

     ```text
     The agent has no identities.
     ```

### Remove private keys from the 'ssh-agent'

To remove a private key from the 'ssh-agent':

1. Run:

    ```bash
    ssh-add -d ~/.ssh/<key_file>
    ```

1. The private key will be removed and a message displayed which includes the comment from when you created your key:

    ```text
    Identity removed: /home/someuser/.ssh/id_ed25519_eidf000 (some-user@somedept.ed.ac.uk)
    ```

To remove all the private keys from the 'ssh-agent', run:

```bash
ssh-add -D
```

### Stop the 'ssh-agent'

The 'ssh-agent' runs until one of the following occurs:

* Your local host is restarted or rebooted.
* You manually stop the 'ssh-agent'.

To manually stop the 'ssh-agent':

* Linux, Windows (Git Bash, Windows Subsystem for Linux), MacOS:

    Run, in the same terminal in which you started the 'ssh-agent':

    ```bash
    ssh-agent -k
    ```

    If you no longer have that terminal open, then run:

    ```bash
    ps -ef | grep ssh-agent
    ```

    And, using te 'ssh-agent' process ID from the second column, kill the 'ssh-agent' process:

    ```bash
    kill <process_id>
    ```

* Windows (Powershell), as Administrator:

    ```powershell
    Stop-Service ssh-agent
    Get-Service ssh-agent
    ```

!!! Warning "Stopping 'ssh-agent' under Powershell does not delete cached private keys"

    Stopping 'ssh-agent' under Powershell does not delete the cached private keys. When the 'ssh-agent' is restarted, then the private keys will still be available. This is because the keys are cached in the Windows registry, encrypted in a Windows-specific way.

    To ensure that the keys are deleted, run `ssh-add -D` when the 'ssh-agent' is running.

---

## Remove a public key from your project account

To remove a public key from your project account:

1. On the [Your Projects](https://portal.eidf.ac.uk/project) page within the [EIDF Portal](https://portal.eidf.ac.uk/), click your project.
1. Your selected project's page will appear.
1. Within the 'Your Accounts' table, click your account username.
1. Your 'User Account Info' page will appear.
1. Under 'Credentials', click the **bin** button.
1. Select a public key to delete.
1. Click **Delete Selected**.
1. The 'User Account Info' page will reappear.
1. Initially, the public key will have a 'Status' of 'Deleting'.
1. If you refresh the page, the public key will eventually disappear from the table.

!!! Warning "Delay in public key being no longer usable"

    There may be a lag, possibly of a few minutes, between a public key being removed and it being no longer usable, even if the public key is no longer shown. This is due to the time taken for the update to be reflected across the EIDF infrastructure.

---

## EIDF VM passwords

An SSH private-public key pair is sufficient to access an EIDF VM via SSH and the EIDF Gateway, you do not have to set a password for your account on that VM.

However, if you intend to run commands via 'sudo' once logged in, then you will need your EIDF VM password. You can set (or reset) a password via the 'User Account Info' page in the EIDF Portal by following the instructions in [Set or change the password for a user account](../services/virtualmachines/quickstart.md#set-or-change-the-password-for-a-user-account).
