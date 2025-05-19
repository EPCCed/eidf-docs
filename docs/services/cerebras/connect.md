# Login

The route for SSH access to the CS3 user-nodes is via the `eidf-gateway` bastion, as for the EIDF VirDS desktop VMs. This requires two credentials, your SSH key pair protected by a passphrase **and** a Time-based one-time password (TOTP).

## Access credentials

To access the CS3 system, follow the login example below. For the majority of authorised users, no further passwords or credentials are required other than for `eidf-gateway`.

To configure your SSH keys and MFA (TOTP) token, see [our general SSH documentation.](https://docs.eidf.ac.uk/access/ssh/)

### SSH Login example

To login to the CS3 user-nodes, you will need to use the SSH Key and TOTP token as noted above.
With the appropriate key loaded<br>`ssh -J <username>@eidf-gateway.epcc.ed.ac.uk cerebras` will then prompt you, roughly once per day, for your TOTP code.
