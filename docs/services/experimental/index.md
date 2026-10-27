# Experimental System Access

## Introduction

A pair of redundant SSH Gateways were built to replace the aging Hydra-VPN Service. This service replicates the requirements of Hydra-VPn, while implementing much higher security standards, with greater ease of use.

In order to access these gateways, you need to be a member of a project which uses them, for example a NextGenIO Project. If you're unsure if you need access, speak to your EPCC Project Contact.

These gateways act as a jump host only, you can't SSH to them directly. See the [Using the Gateway](#using-the-gateway) section for more information.

## Gaining Access

1. Access [SAFE](https://safe.epcc.ed.ac.uk)
1. Select 'Projects' and 'Request Access'
1. Search for your project code, e.g. nx04
1. Select 'Request machine account' then 'Apply'
1. Under the 'Select a machine for the login account' select 'gateways'
1. Select 'Next'
1. Specify the username you'd like. This can't be the same as an account name in another project
1. Upload an SSH public key. This is required to access these gateways.
1. Select 'Request'
1. You'll get an email when your account has been accepted.

### Set MFA Token

Once your account has been added, you need to enable MFA. Like the SSH key, this is required to use these gateways.

1. Access [SAFE](https://safe.epcc.ed.ac.uk)
1. Select 'Login Accounts' and select the username you just made
1. Select 'Set MFA-Token'
1. Scan the QR Code into the authenticator of your choice, and verify the code displayed in your app in the 'Verification Code' box.
1. MFA has now been enabled.

## Using the Gateway

[SSH access via the EIDF Gateway jump host](../../access/ssh.md) describes how to access an EIDF VM via the EIDF Gateway jump host, `eidf-gateway.epcc.ed.ac.uk`.  These instructions can also be used to access thhe experimental services gateway by replacing all mentions of `eidf-gateway.epcc.ed.ac.uk` with `gateway.epcc.ed.ac.uk` in any 'ssh' commands and SSH configuration files.

`eidf-gateway.epcc.ed.ac.uk` and `gateway.epcc.ed.ac.uk` are two separate services and you cannot access experimental services through `eidf-gateway.epcc.ed.ac.uk`.
