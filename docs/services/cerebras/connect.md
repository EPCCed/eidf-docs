# Login

The route for SSH access to the CS3 user-nodes is via the `eidf-gateway` bastion, as for the EIDF VirDS desktop VMs. This requires two credentials, your SSH key pair protected by a passphrase **and** a Time-based one-time password (TOTP).

## Access credentials

To access the CS3 system, follow the login example below. For the majority of authorised users, no further passwords or credentials are required other than for `eidf-gateway`.

### SSH Key

You must upload the public part of your SSH key pair to the SAFE by following the [instructions from the SAFE documentation](https://epcced.github.io/safe-docs/safe-for-users/#how-to-add-an-ssh-public-key-to-your-account)

### Time-based one-time password (TOTP)

You must set up your TOTP token by following the [instructions from the SAFE documentation](https://epcced.github.io/safe-docs/safe-for-users/#how-to-turn-on-mfa-on-your-machine-account)

### SSH Login example

To login to the CS3 user-nodes, you will need to use the SSH Key and TOTP token as noted above.
With the appropriate key loaded<br>`ssh -J <username>@eidf-gateway.epcc.ed.ac.uk cerebras` will then prompt you, roughly once per day, for your TOTP code.
