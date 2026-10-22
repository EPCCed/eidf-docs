# SSH Access to Virtual Machines using the EIDF-Gateway Jump Host

EIDF virtual machines (VMs) can be accessed via SSH from a terminal or console on your own host. SSH offers an alternative to using the EIDF [Virtual Desktop Interface (VDI)](virtualmachines-vdi.md) to access the EIDF VMs.

Access to EIDF VMs via SSH uses the EIDF-Gateway, a secure 'jump host' which is accessible from anywhere which manages authorised connections from arbitrary hosts to EIDF VMs.

!!! Note "SSH access is not the same as SSH"

    You may have noticed that the EIDF Virtual Desktop Interface allows you to create an SSH session. This is not the same as running an SSH session from your own host, that is described on this page. An SSH session run within the VDI offers the same look-and-feel as an actual SSH session but there is no SSH connection from your host to an EIDF VM.

To access an EIDF VM via SSH from your terminal or console, you will need:

1. An EIDF project user account to have been created for you.
1. Access to the project VM for your user account to have been granted.
1. Access to the EIDF-Gateway, eidf-gateway.epcc.ed.ac.uk, to have been granted.

The above steps need to be done by your project lead.

Once your account has been created and access granted, you need to set up your SSH access as follows:

1. [Create an SSH private-public key pair](#create-an-ssh-private-public-key-pair) on the host from which you want to access the EIDF VM via SSH.
1. [Add the public key to your account](#add-the-public-key-to-your-account) within the EIDF Portal.
1. [Set up multi-factor authentication](#set-up-multi-factor-authentication) for your account within the EIDF Portal.

Once you have done these setup steps, you can [connect to the EIDF VM via SSH](#connect-to-an-eidf-vm-via-ssh).

## Create an SSH private-public key pair

TODO: Replace `/c/Users/mjj` with `/home/someuser`
TODO: Replace 'NNN' with `<project_id>` where appropriate.

Create a SSH private-public key pair on the host from which you want to access the EIDF VM via SSH.

1. Create a `$HOME/.ssh` directory if one does not exist:

    ```bash
    mkdir -p $HOME/.ssh
    ```

1. Create an SSH private-public key pair, replacing `<comment>` with a comment (see below) and `<project_id>` with your EIDF project number, 'NNN':

    ```bash
    ssh-keygen -C '<comment>' -f $HOME/.ssh/id_ed25519_eidf<project_id>
    ```

    A suitable value for `<commment>` can be your email address, or a username and local host name (e.g., `someuser-laptop` or `someuser-cirrus`), Alternatively, `-C '<comment>'` can be omitted, and the default comment of `<user>@<host>` will be used.

    `-f` specifies the private key file path. We recommend that the file name include the default algorithm used to create the key, `ed25519`, and the EIDF project number, `<project_id>`, in the file name. This will help if you have multiple keys for multiple projects or other services.

1. When prompted, enter, then re-enter a passphrase:

    ```bash
    Generating public/private ed25519 key pair.
    Enter passphrase for "/c/Users/mjj/.ssh/id_ed25519_eidfNNN" (empty for no passphrase):
    Enter same passphrase again:
    ```

    The passphrase is used to protect the key. Whenever you use the key, you will be prompted for the passphrase.

Information about the key will be printed. For example:

```text
Your identification has been saved in /c/Users/mjj/.ssh/id_ed25519_eidfNNN
Your public key has been saved in /c/Users/mjj/.ssh/id_ed25519_eidfNNN.pub
The key fingerprint is:
SHA256:KBjX+Dl0wl8GO8ec7Q7M6PCUETk+yqM/eybpUBuY7Bc a@b
The key's randomart image is:
+--[ED25519 256]--+
|        o.       |
|     +  o* o     |
|  . o =.=.B .    |
|   = = *o@ .     |
|  . =.E.S.+ .    |
|   . o+X   o     |
|    o.ooo   .    |
|    .o+ o        |
|     o+*         |
+----[SHA256]-----+
```

Two files will be created in your `.ssh` directory:

* `.ssh/id_ed25519_eidfNNN`, the private key file, which includes the private key itself. **Do not** share your private key with anyone.
* `.ssh/id_ed25519_eidfNNN.pub`, a complementary public key file, which shares the private key file name with a `.pub` suffix. The public key file has content:

    ```text
    <key-type> <base64-encoded-public-key> <comment>
    ```

    The default `<key-type>` is `ssh-ed25519`.

## Add the public key to your account

To add the public key to your account:

1. On the [Your Projects](https://portal.eidf.ac.uk/project) page within the [EIDF Portal](https://portal.eidf.ac.uk/), click your project.
1. Your selected project's page will appear.
1. Within the 'Your Accounts' table, click your user account name.
1. Your 'User Account Info' page will appear.
1. Under 'Credentials', click **+**.
1. Either, the paste contents of the public key file, `$HOME/.ssh/id_ed25519_eidfNNN.pub`, into the **Credential** field.
1. Or, click **Choose file** and select the public key file, `$HOME/.ssh/id_ed25519_eidfNNN.pub`
1. Click **Upload Credential**.
1. The 'User Account Info' page will reappear.

Your public key will be shown in the 'Credentials' table. An excerpt of the start of the public key will be shown under 'Credential' and the public key's comment will be shown under 'Identifier'. Initially, the public key will have a 'Status' of 'Pending'. If you refresh the page, the 'Status' will eventually update to 'Active'.

!!! Warning "Delay in public key being usable"

    There may be a lag, possibly up to an hour, between a public key being added and it being usable, even if the public key is marked as 'Active'. This is due to the time taken for the update to be reflected across the EIDF infrastructure.
    
TODO: Double-check delay with AK.

## Set up multi-factor authentication

To set up multi-factor authentication for your account within the EIDF Portal:

TODO

## Connect to an EIDF VM via SSH

TODO

## Miscellaneous

### Remove a public key from your account

To remove a public key from your account:

* On the [Your Projects](https://portal.eidf.ac.uk/project) page within the EIDF Portal, click your project.
* Your selected project's page will appear.
* Within the 'Your Accounts' table, click your account name.
* Your 'User Account Info' page will appear.
* Under 'Credentials', click the **bin** icon.
* Select a public key to delete.
* Click **Delete Selected**.
* The 'User Account Info' page will reappear.

Initially, the public key will have a 'Status' of 'Deleting'. If you refresh the page, the public key will eventually disappear from the table.

!!! Warning "Delay in public key being no longer usable"

    There may be a lag, possibly up to an hour, between a public key being removed and it being no longer usable, even if the public key is no longer shown. This is due to the time taken for the update to be reflected across the EIDF infrastructure.
    
TODO: Double-check delay with AK.

---
---
---

## Existing content

### Adding the new SSH Key to your account via the Portal

1. Click 'Upload Credential' - it should look something like this:

   ![eidf-portal-ssh](../images/access/eidf-portal-ssh.png){: class="border-img"}

## Enabling MFA via the Portal

A multi-factor Time-Based One-Time Password is now required to access the SSH Gateway.

To enable this for your EIDF account:

1. Login to the [portal.](https://portal.eidf.ac.uk)
1. Select 'Projects' then 'Your Projects'
1. Select the project containing the account you'd like to add MFA to.
1. Under 'Your Accounts', select the account you would like to add MFA to.
1. Select 'Set MFA Token'
1. Within your chosen MFA application, scan the QR Code or enter the key and add the token.
1. Enter the code displayed in the app into the 'Verification Code' box and select 'Set Token'
1. You will be redirected to the User Account page and a green 'Added MFA Token' message will confirm the token has been added successfully.

!!! note
    TOTP is only required for the SSH Gateway, not to the VMs themselves, and not through the VDI.
    An MFA token will have to be set for each account you'd like to use to access the EIDF SSH Gateway.

### Using the SSH-Key and TOTP Code to access EIDF - Windows and Linux

1. From your local terminal, import the SSH Key you generated above:
    `ssh-add /path/to/ssh-key`

1. This should return "Identity added [Path to SSH Key]" if successful. You can then follow the steps below to access your VM.

## Accessing From MacOS/Linux

OpenSSH is installed on Linux and MacOS usually by default, so you can access the gateway natively from the terminal.

Ensure you have created and added an ssh key as specified in the 'Generating and Adding an SSH Key' section above, then run the commands below:

```bash
ssh-add /path/to/ssh-key
ssh -J [username]@eidf-gateway.epcc.ed.ac.uk [username]@[vm_ip]
```

For example:

```bash
ssh-add ~/.ssh/keys/id_ed25519
ssh -J alice@eidf-gateway.epcc.ed.ac.uk alice@10.24.1.1
```

!!! info
    If the `ssh-add` command fails saying the SSH Agent is not running, run the below command:

    ```bash
    eval `ssh-agent`
    ```

    Then re-run the ssh-add command above.

The `-J` flag is use to specify that we will access the second specified host by jumping through the first specified host.

You will be prompted for a 'TOTP' code upon successful public key authentication to the gateway. At the TOTP prompt, enter the code displayed in your MFA Application.

## Accessing from Windows

Windows will require the installation of OpenSSH-Server to use SSH. Putty or MobaXTerm can also be used but won’t be covered in this tutorial.

### Installing and using OpenSSH

1. Click the ‘Start’ button at the bottom of the screen
1. Click the ‘Settings’ cog icon
1. Select 'System'
1. Select the ‘Optional Features’ option at the bottom of the list
1. If ‘OpenSSH Client’ is not under ‘Installed Features’, click the ‘View Features’ button
1. Search ‘OpenSSH Client’
1. Select the check box next to ‘OpenSSH Client’ and click ‘Install’

### Accessing EIDF via a Terminal

1. Open either Powershell or the Windows Terminal
1. Import the SSH Key you generated above:

    ```powershell

    ssh-add \path\to\sshkey
    ```

    For Example:

    ```powershell
    ssh-add .\.ssh\id_ed25519
    ```

1. This should return "Identity added [Path to SSH Key]" if successful. If it doesn't, run the following in Powershell:

    ```powershell

    Get-Service -Name ssh-agent | Set-Service -StartupType Manual
    Start-Service ssh-agent
    ssh-add \path\to\sshkey

    ```

1. Login by jumping through the gateway.

    ```powershell
    ssh -J [EIDF username]@eidf-gateway.epcc.ed.ac.uk [EIDF username]@[vm_ip]
    ```

    For Example:

    ```powershell
    ssh -J alice@eidf-gateway.epcc.ed.ac.uk alice@10.24.1.1
    ```

You will be prompted for a 'TOTP' code upon successful public key authentication to the gateway. At the TOTP prompt, enter the code displayed in your MFA Application.

### Accessing with PuTTY

#### Creating the Gateway Config

1. Install PuTTY v0.81 or greater and launch it
1. From the default 'Session' menu, input the gateway URL: `eidf-gateway.epcc.ed.ac.uk`
1. Set the port to `22`
1. Naviagte to 'Connection' > 'SSH' > 'Auth' > 'Credentials'
1. Specify your gateway private key by selecting the 'Browse' button next to 'Private key file for authentication'
1. Select the path to your SSH key for your gateway account
1. Return to the main 'Session' tab and in the empty box under 'Saved Sessions' input a memorable name, for example 'eidf-gateway'
1. Click Save

#### Adding a client/VM config

Now we can create a config session for a VM which can be connected to through the gateway

1. From the 'Sessions' tab, select 'Default Settings' in the 'Saved Settings' box and select 'Load'
1. Input the hostname/IP of the VM, e.g. 10.24.X.Y.
1. Ensure the port is `22`
1. From the navigation menu, move to 'Connection' > 'Proxy'
1. Select 'Proxy Type' at the top to 'SSH to proxy and use port forward'. *Note this doesn't exist in older versions of PuTTY*
1. Under 'Proxy Hostname', set the name of the gateway session you created above. In the SOP this was called 'eidf-gateway'
1. Set the Port to `22`
1. Put your eidf-gateway username into the 'Username' box
1. Set 'Do DNS name lookup at proxy end' to 'Yes'
1. Navigate to 'Connection' > 'SSH' > 'Auth' > 'Credentials' and select 'Browse' next to the 'Private key file for authentication' box
1. Select your private key for your VM account (this may be the same as the gateway)
1. Navigate to 'Connection' > 'Data'
1. Put your VM username into the 'Auto-Login username' box
1. Return to the original 'Sesstion' tab
1. Put the VM name or a nickname into the 'Saved Settings' name box
1. Select 'Save'
1. Select 'Open' and you should connect to your VM.

## SSH Aliases

You can use SSH Aliases to access your VMs with a single command.

1. Create a new entry for the EIDF-Gateway in your ~/.ssh/config file. Using the text editor of your choice (vi used as an example), edit the .ssh/config file:

    ```bash

    vi ~/.ssh/config

    ```

1. Insert the following lines:

    ```bash

    Host eidf-gateway
      Hostname eidf-gateway.epcc.ed.ac.uk
      User <eidf project username>
      IdentityFile /path/to/ssh/key

    ```

    For example:

    ```bash

    Host eidf-gateway
      Hostname eidf-gateway.epcc.ed.ac.uk
      User alice
      IdentityFile ~/.ssh/id_ed25519

    ```

1. Save and quit the file.

1. Now you can ssh to your VM using the below command:

    ```bash

    ssh -J eidf-gateway [EIDF username]@[vm_ip] -i /path/to/ssh/key

    ```

    For Example:

    ```bash
    ssh -J eidf-gateway alice@10.24.1.1 -i ~/.ssh/id_ed25519
    ```

1. You can add further alias options to make accessing your VM quicker. For example, if you use the below template to create an entry below the EIDF-Gateway entry in ~/.ssh/config, you can use the alias name to automatically jump through the EIDF-Gateway and onto your VM:

    ```terminalShell
    Host <vm name/alias>
      HostName 10.24.VM.IP
      User <vm username>
      IdentityFile /path/to/ssh/key
      ProxyCommand ssh eidf-gateway -W %h:%p
    ```

    For Example:

    ```terminalShell
    Host demo
      HostName 10.24.1.1
      User alice
      IdentityFile ~/.ssh/id_ed25519
      ProxyCommand ssh eidf-gateway -W %h:%p
    ```

    If your key is RSA, you will need to add the following line to the bottom of the 'demo' alias:
    `HostKeyAlgorithms +ssh-rsa`

1. Now, by running `ssh demo` your ssh agent will automatically follow the 'ProxyCommand' section in the 'demo' alias and jump through the gateway before following its own instructions to reach your VM.

!!! info
    This has added an 'Alias' entry to your ssh config, so whenever you ssh to 'eidf-gateway' your ssh agent will automatically fill the hostname, your username and ssh key.
    This method allows for a much less complicated ssh command to reach your VMs.
    You can replace the alias name with whatever you like, just change the 'Host' line from saying 'eidf-gateway' to the alias you would like.
    The `-J` flag is use to specify that we will access the second specified host by jumping through the first specified host.

## sudo, Password Setting and Password Resets

You do not have to set a password to log into virtual machines. However, if you have been given sudo permission, you will need to set a password to be able to make use of sudo. You can set (or reset) a password using the web form in the EIDF Portal following the instructions in [Set or change the password for a user account](../services/virtualmachines/quickstart.md#set-or-change-the-password-for-a-user-account).
