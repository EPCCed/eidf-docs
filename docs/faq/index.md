# FAQ

## EIDF Frequently Asked Questions

### How do I contact the EIDF Helpdesk?

Submit a query in the [EIDF Portal](https://portal.eidf.ac.uk/) by selecting "Submit a Support Request" in the "Help and Support" menu and filling in [this form](https://portal.eidf.ac.uk/queries/submit).

You can also email us at [eidf@epcc.ed.ac.uk](mailto:eidf@epcc.ed.ac.uk).

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
