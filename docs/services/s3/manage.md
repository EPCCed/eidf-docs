# Manage EIDF S3 access

Access keys and accounts for the object store are managed by project managers via the [EIDF Portal](https://portal.eidf.ac.uk/).

## Request an allocation

An object store allocation for a project may be requested by contacting the EIDF helpdesk.

## Object store accounts

Select your project at [https://portal.eidf.ac.uk/project/](https://portal.eidf.ac.uk/project/)
and jump to "S3 Allocation" on the project page to manage access keys and accounts.

![Portal-S3-Access-Keys](../../images/access/portal-s3-accounts.png){: class="border-img"}

S3 buckets and objects are owned by an account.
Each account has a quota for storage and the number of buckets that it can create.
The sum of all account quotas is limited by the total storage quota of the project object store allocation shown at the top.

An account with the minimum storage quota (1B) and zero buckets is effectively read only
as it may not create new buckets and so cannot upload files.

To create an account:

1. On the project page scroll to "S3 Allocation"
1. Click "Add Account"
1. Enter:
    * an account name (letters, numbers and underscore `_` only)
    * a description
    * a quota: a number with a unit B, kB, MiB (MB), GiB (GB), or TiB (TB), the minimum is 1B (1 Byte).
    * the number of buckets that the account may create
1. Click "Create Account"

You will not be allowed to create an account with the quota greater than the available storage quota of the project.

It may take a little while for the account to become available.
Refresh the project page to update the list of accounts.

## Access keys

To use S3 (listing or creating buckets, listing objects or uploading and downloading files) you need an access key and a secret.
An account can own any number of access keys.
These keys share the account's quota and have access to the same buckets.

To create an access key:

1. Select an account and click "Add Key"
1. Click "Create Access Key"

It can take a little while for the access keys to become available.
Refresh the project page to update the list of keys.

## Access key permissions

You can control which project members are allowed to view an access key and secret in the EIDF Portal or the SAFE.
Project managers and the PI have access to all S3 accounts and can view associated access keys and secrets in the project management view.

To grant view permissions for an access key to a project member:

1. Click on the "Edit" icon next to the key.
1. Select the project members that will have view permissions for this access key.
1. Press "Update Permissions"

It can take a little while for the permissions update to complete.

!!! note
    Anyone who knows an access key and secret will be able to perform the associated activities via the S3 API regardless of the view permissions.

## Delete an access key

Click on the "Bin" icon next to a key and press "Delete" on the form.
