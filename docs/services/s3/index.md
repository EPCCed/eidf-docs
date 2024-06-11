# Overview

The EIDF S3 Service is an object store with an interface that is compatible with a subset of the Amazon S3 RESTful API.

## Service Access

Users should have an EIDF account as described in [EIDF Accounts](../../access/project.md).

Project leads can request an object store allocation through a request to the EIDF helpdesk.

## Access keys

Select your project at [https://portal.eidf.ac.uk/project/](https://portal.eidf.ac.uk/project/).
Your access keys are displayed in the table at the top of the page.

![Portal-S3-Access-Keys](/eidf-docs/images/access/portal-s3-keys.png){: class="border-img"}

For each account, the quota and the number of buckets that it is permitted to create is shown, as well as the access keys.
Click on "Secret" to view the access secret.
You will need the access key, the corresponding access secret and the endpoint `https://s3.eidf.ac.uk` to connect to the EIDF S3 Service with an S3 client.


## Further information
[Access management](./manage.md): Project management guide to managing accounts and access permissions for your S3 allocation.

[Tutorial](./tutorial.md): Examples using EIDF S3
