# FAQ

## EIDF Frequently Asked Questions

### How do I contact the EIDF Helpdesk?

If you are an existing user of EIDF or other EPCC systems then please submit your queries via our [EIDF Helpdesk](https://portal.eidf.ac.uk/queries/submit) otherwise send your query by email to [eidf@epcc.ed.ac.uk](mailto:eidf@epcc.ed.ac.uk).

### How do I request more resources for my project? Can I extend my project?

Submit a support request: In the [form](https://portal.eidf.ac.uk/queries/submit) select the project that your request relates to and select "EIDF Project extension: duration and quota" from the dropdown list of categories. Then enter the new quota or extension date in the description text box below and submit the request.

The EIDF approval team will consider the extension and you will be notified of the outcome.

### New VMs and VDI connections

My project manager gave me access to a VM but the connection doesn't show up in the VDI connections list?

This may happen when a machine/VM was added to your connections list while you were logged in to the VDI. Please refresh the connections list by logging out and logging in again, and the new connections should appear.

### Default SSH private keys

'Can I connect to an EIDF VM using a private key file with a default name like `id_ed25519` or `id_rsa`?'

Yes. In the 'ssh' command described in [SSH access via the EIDF Gateway jump host](../access/ssh.md) the use of named, non-default, private key files, can be replaced by the default private key file names. For example:

```bash
ssh -o ProxyCommand="ssh -i $HOME/.ssh/id_ed25519 -W %h:%p some-eidf-user@eidf-gateway.epcc.ed.ac.uk" -i $HOME/.ssh/id_ed25519 some-eidf-user@10.24.999.999
```

Alternatively, you can run a shorter command:

```bash
ssh -J some-eidf-user@eidf-gateway.epcc.ed.ac.uk some-eidf-user@10.24.999.999
```

### Non-default SSH private keys

'Can I connect to an EIDF VM via SSH using a private key file with a custom name, not a default like `id_ed25519` or `id_rsa`?'

Yes. In the 'ssh' command described in [SSH access via the EIDF Gateway jump host](../access/ssh.md) the use of named, non-default, private key files, is shown. For example:

```bash
ssh -o ProxyCommand="ssh -i $HOME/.ssh/id_ed25519_eidf000 -W %h:%p some-eidf-user@eidf-gateway.epcc.ed.ac.uk" -i $HOME/.ssh/id_ed25519_eidf000 some-eidf-user@10.24.999.999
```

### Different EIDF Gateway and EIDF VM usernames and private keys

'My EIDF Gateway username and EIDF VM usernames and private keys differ. How do I log into my EIDF VM via SSH?'

In the 'ssh' command described in [SSH access via the EIDF Gateway jump host](../access/ssh.md) the usernames and private key files used to connect to both the EIDF Gateway and an EIDF VM are specified. This allows for a different username and private key to be used for each host. For example:

```bash
ssh -o ProxyCommand="ssh -i $HOME/.ssh/id_ed25519_gateway_key -W %h:%p some-eidf-gateway-user@eidf-gateway.epcc.ed.ac.uk" -i $HOME/.ssh/id_ed25519_eidf_host_key some-eidf-user@10.24.999.999
```

For the majority of EIDF users, however, the same user name and private key will be used to access both the EIDF Gateway and an EIDF VM.

### Username Policy

I already have an EIDF username for project Y, can I use this for project X?

We mandate that every username must be unique across our estate. EPCC machines including EIDF services such as the SDF and DSC VMs, and HPC services such as Cirrus require you to create a new machine account with a unique username for each project you work on. Usernames cannot be used on multiple projects, even if the previous project has finished. However, some projects span multiple machines so you may be able to login to multiple machines with the same username.
