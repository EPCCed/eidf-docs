# Manage EIDF S3 access


Access keys and accounts for the object store are managed by project managers via the [EIDF Portal](https://portal.eidf.ac.uk/).

## Request an allocation

An object store allocation for a project may be requested by contacting the EIDF helpdesk.

## Object store accounts

Select your project at [https://portal.eidf.ac.uk/project/](https://portal.eidf.ac.uk/project/)
and jump to "S3 Allocation" on the project page to manage access keys and accounts.

S3 buckets and objects are owned by an account.
Each account has a quota for storage and the number of buckets that it can create.
The sum of storage quotas of all accounts is limited by the total quota of the project object store allocation.

An account with the minimum storage quota (1kB) and zero buckets is effectively read only
as it may not create new buckets and so cannot upload files.

To create an account:

1. On the project page scroll to "S3 Allocation"
1. Click "Add Account"
1. Enter:
    * an account name (letters, numbers and underscore `_` only)
    * a description
    * a quota: must be at least 1kB, a number with a unit B, kB, MB, GB, or TB.
    * the number of buckets that the account may create
1. Click "Create Account"

## Access keys

An account can have any number of access keys. These keys share the account's quota and have access to the same buckets.

To create an access key:

1. Select an account and click "Add Key"
1. Click "Create Access Key"

It can take a little while for the access keys to become available.
Refresh the project page to update the list of keys.

## Access key permissions

You can control which project members are allowed to view an access key and secret in the EIDF Portal or the SAFE.
Project managers and the PI have access to all S3 accounts and associated access keys.

To grant view permissions for an access key:

1. Click on the "Edit" icon next to the key.
1. Select the project members that will have view permissions for this access key.
1. Press "Update Permissions"

It can take a little while for the permissions update to complete.

!!! note
    Anyone who knows an access key and secret will be able to perform the associated activities via the S3 API regardless of the view permissions.


## Delete an access key

Click on the "Bin" icon next to a key and press "Delete" on the form.