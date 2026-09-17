# Overview

The EIDF S3 Service is an object store that offers an interface that is compatible with a subset of the Amazon [Simple Storage Service (S3)](https://docs.aws.amazon.com/s3/) RESTful [S3 API](https://docs.aws.amazon.com/AmazonS3/latest/API).

The EIDF S3 Service is directly accessible from the [EIDF Virtual Machine (VM) Service](../virtualmachines), the [EIDF GPU Service](../gpuservice/index.md) and the [EIDF Ultra2 Service](../ultra2/index.md).

The EIDF S3 Service is also accessible from anywhere in the world via S3-compatible workflows.

## Service Access

To access the EIDF S3 Service, you need to have an EIDF account as described in [EIDF Accounts](../../access/project.md).

Project leads can request an EIDF S3 Service object store allocation for a project via a request to the [EIDF Helpdesk](https://portal.eidf.ac.uk/queries/submit).

## Information required to use the EIDF S3 Service

The EIDF S3 Service endpoint is https://s3.eidf.ac.uk.

You can get your EIDF S3 credentials from the [EIDF Portal](https://portal.eidf.ac.uk/) as follows:

1. On the [Your Projects](https://portal.eidf.ac.uk/project/) page, click your project.
1. Your select project's page will appear.
1. If using the portal's 'new project view', click **Your S3 Keys**.
1. Within the **S3 Access Keys** section, for each S3 account for that project you will see:
    * **Name**: Your S3 username.
    * **Quota**: Your S3 quota, the maximum amount of storage you have available.
    * **Buckets**: The number of S3 buckets you can create.
    * **Keys**: Your access key and, via the **Secret** drop-down menu, your key's associated secret.

![EIDF Portal S3 Access Keys](../../images/access/portal-s3-keys.png){: class="border-img"}

## Further information

[Tutorial](./tutorial.md): A hands-on introduction to S3 and the EIDF S3 Service.

[Using the EIDF S3 Browser](./s3browser.md): A guide to using the [EIDF S3 Browser](https://portal.eidf.ac.uk/project/s3browser/) which is part of the [EIDF S3 Service](./index.md) and offers a web-based user interface within the EIDF portal for creating and managing buckets and uploading, downloading and deleting files.

[Manage EIDF S3 Service access](./manage.md): A guide for project leads on managing accounts and access permissions for their projects' S3 allocations.

Amazon [Simple Storage Service (S3)](https://docs.aws.amazon.com/AmazonS3/latest/userguide/Welcome.html): Amazon's own S3 documentation.
