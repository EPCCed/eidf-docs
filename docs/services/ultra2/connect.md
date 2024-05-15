# Login

The hostname for SSH access to the system is `ultra2.eidf.ac.uk`

## Access credentials

To access Ultra2, you need to use two credentials: your SSH key pair protected by a passphrase **and** a Time-based one-time password (TOTP).

### SSH Key

You must upload the public part of your SSH key pair to the SAFE by following the [instructions from the SAFE documentation](https://epcced.github.io/safe-docs/safe-for-users/#how-to-add-an-ssh-public-key-to-your-account)

### Time-based one-time password (TOTP)

You must set up your TOTP token by following the [instructions from the SAFE documentation](https://epcced.github.io/safe-docs/safe-for-users/#how-to-turn-on-mfa-on-your-machine-account)

### SSH Login example

To login to Ultra2, you will need to use the SSH Key and TOTP token as noted above.
With the appropriate key loaded<br>`ssh <username>@ultra2.eidf.ac.uk` will then prompt you, roughly once per day, for your TOTP code.
