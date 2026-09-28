# Overview

The EIDF S3 Service is an object store, provisioned using the [Ceph](https://ceph.io) storage platform, that implements a subset of Amazon [Simple Storage Service (S3)](https://docs.aws.amazon.com/AmazonS3/latest/userguide/Welcome.html) service interfaces.

The EIDF S3 Service is directly accessible from the [EIDF Virtual Machine (VM) Service](../virtualmachines), the [EIDF GPU Service](../gpuservice/index.md) and the [EIDF Ultra2 Service](../ultra2/index.md). The EIDF S3 Service is also accessible from anywhere in the world via S3-compatible workflows.

---

## Service provision

Project leads can request an EIDF S3 Service object store allocation, a portion of the EIDF S3 Service storage allocated for the exclusive use of a project, via the [EIDF Helpdesk](https://portal.eidf.ac.uk/queries/submit).

To access EIDF S3 Service object store allocation and account information within the EIDF Portal, users need to have an EIDF account as described in [EIDF Accounts](../../access/project.md).

---

## Service management for project leads

[Managing a project's S3 object store allocation](./manage.md) is a guide for project leads on how to manage a project's object store allocation and its S3 accounts and access permissions.

---

## Using the EIDF S3 Service

[Getting started with S3 and the EIDF S3 Service](./getting-started.md) is a hands-on introduction to S3 and the EIDF S3 Service.

[Get information to use the EIDF S3 Service](./getting-started.md#get-information-to-use-the-eidf-s3-service), part of the introduction, describes the S3 Service endpoint URL and how to view your S3 account names, access keys, secrets, and storage and bucket quotas:

[Using the EIDF S3 Browser](./s3browser.md) is a guide to using the [EIDF S3 Browser](https://portal.eidf.ac.uk/project/s3browser/) which is part of the [EIDF S3 Service](./index.md) and offers a web-based user interface within the EIDF Portal for creating and managing buckets and uploading, downloading and deleting files.

[Using the EIDF S3 Service via Python](./python.md) provides examples of how to use the EIDF S3 Service via Python and the Amazon Web Services Software Development Kit for Python, [Boto3](https://aws.amazon.com/sdk-for-python/).

[Using S3 policies](./policies.md) provides examples of applying Identity Access Management (IAM) policies to buckets. For example, you can grant other accounts (within the same project or from other EIDF projects) read or write access to your buckets, or grant public anonymous read access.
