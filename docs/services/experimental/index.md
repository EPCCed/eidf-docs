# Experimental System Access

## Introduction

A pair of redundant SSH Gateways were built to replace the aging Hydra-VPN Service. This service replicates the requirements of Hydra-VPN, while implementing much higher security standards, with greater ease of use.

In order to access these gateways, you need to be a member of a project which uses them, for example a NextGenIO Project. If you're unsure if you need access, speak to your EPCC Project Contact.

These gateways act as a jump host only, you cannot SSH to them directly. See [Using the Gateway](#using-the-gateway) below for more information.

## Gaining Access

1. Access [SAFE](https://safe.epcc.ed.ac.uk).
1. Select 'Projects' menu, 'Request Access' option.
1. Beside 'Project', search for your project code, e.g. 'nx04'.
1. Beside 'Access route', select 'Request machine account'.
1. Click 'Apply'.
1. Under the 'Select a machine for the login account' select 'gateways'.
1. Click 'Next'.
1. Specify the username you'd like. This **cannot** be the same as an account name in another project.
1. Upload an SSH public key. This is required to access these gateways. To create an SSH private and public key, if you do not already have one, see, for example, [Create SSH private and public keys](../../access/ssh.md#create-ssh-private-and-public-keys) in [SSH access to EIDF VMs](../../access/ssh.md).
1. Click 'Request'.
1. You'll get an email when your account has been accepted.

### Set Multi-Factor Authentication Token

Once your account has been added, you need to enable multi-factor authentication (MFA). Like your SSH key, this is required to use these gateways.

1. Get a multi-factor authentication app, if you do not already have one. For example, see [Get a multi-factor authentication app](../../access/ssh.md#get-a-multi-factor-authentication-app) in [SSH access to EIDF VMs](../../access/ssh.md).
1. Access [SAFE](https://safe.epcc.ed.ac.uk).
1. Select 'Login Accounts' menu and select the username you just made.
1. Click 'Set MFA Token'.
1. Scan the QR code or enter the 'New token' into your authenticator
1. Within 'Verification Code', enter the code displayed in your authenticator app.
1. Click 'Set'
1. MFA has now been enabled.

## Using the Gateway

[SSH access to EIDF VMs](../../access/ssh.md) describes how to access an EIDF VM via the EIDF Gateway jump host, `eidf-gateway.epcc.ed.ac.uk`.  These instructions can also be used to access the experimental services gateway by replacing all mentions of `eidf-gateway.epcc.ed.ac.uk` with `gateway.epcc.ed.ac.uk` in any 'ssh' commands and SSH configuration files.

`eidf-gateway.epcc.ed.ac.uk` and `gateway.epcc.ed.ac.uk` are two separate services and you cannot access experimental services through `eidf-gateway.epcc.ed.ac.uk`.
