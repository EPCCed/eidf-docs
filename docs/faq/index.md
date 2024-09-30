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

### Non-default SSH Keys

I have different SSH keys for the SSH gateway and my VM, or I use a key which does not have the default name (~/.ssh/id_rsa) and I cannot login.

The command syntax shown in our SSH documentation (using the ```-J <username>@eidf-gateway``` stanza) makes assumptions about SSH keys and their naming. You should try the full version of the command:

```bash
ssh -o ProxyCommand="ssh -i ~/.ssh/<gateway_private_key> -W %h:%p <gateway_username>@eidf-gateway.epcc.ed.ac.uk" -i ~/.ssh/<vm_private_key> <vm_username>@<vm_ip>
```

Note that for the majority of users, gateway_username and vm_username are the same, as are gateway_private_key and vm_private_key

### Username Policy

I already have an EIDF username for project Y, can I use this for project X?

We mandate that every username must be unique across our estate. EPCC machines including EIDF services such as the SDF and DSC VMs, and HPC services such as Cirrus require you to create a new machine account with a unique username for each project you work on. Usernames cannot be used on multiple projects, even if the previous project has finished. However, some projects span multiple machines so you may be able to login to multiple machines with the same username.
