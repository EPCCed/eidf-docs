# Using S3 policies

Identity Access Management (IAM) policies can be applied to buckets. For example, you can grant other accounts (within the same project or from other EIDF projects) read or write access to your buckets, or grant public anonymous read access.

Policies are defined as S3 policy documents, in JSON format.

**Author's Note**: Commands and code on this page were checked using a EIDF VM, Ubuntu 24.04.4 LTS (noble) with AWS CLI 2.36.36, Python 3.12.3, Boto3 1.43.97.

---

## Bucket naming in policies

Use bucket names of form `<project-name>:<bucket-name>` within policies. For example, `eidfNNN:somebucket`.

---

## Manage bucket policies via the AWS CLI

### Set bucket policy via the AWS CLI

To set a policy, run:

```bash
aws s3api put-bucket-policy --bucket <bucket> --policy "$(cat <policy-file>)"
```

For example:

```bash
aws s3api put-bucket-policy --bucket somebucket --policy "$(cat grant-public-ro.json)"
```

### Get bucket policy via the AWS CLI

To get a policy, run:

```bash
aws s3api get-bucket-policy --bucket <bucket> --query Policy --output text > <local-file>
```

For example:

```bash
aws s3api get-bucket-policy --bucket somebucket --query Policy --output text > policy.json
```

If you have the [jq](https://jqlang.org/) JSON query tool installed, then you can pretty-print the policy as follows:

```bash
aws s3api get-bucket-policy --bucket <bucket> --query Policy --output text | jq > <local-file>
```

### Delete bucket policy via the AWS CLI

To delete a policy, run:

```bash
aws s3api delete-bucket-policy --bucket <bucket>
```

For example:

```bash
aws s3api delete-bucket-policy --bucket somebucket
```

---

## Manage bucket policies via Python

### Set bucket policy via Python

Bucket policies can be defined in JSON files and loaded into Python for submission via Boto3. Alternatively, policies can be defined programmatically within Python as a Python dict, then converted to JSON. This is shown in the example policies below.

Use Boto3's [put_bucket_policy](https://docs.aws.amazon.com/boto3/latest/reference/services/s3/client/put_bucket_policy.html) to set a policy. For example:

```python
import json
import boto3

bucket_name = 'somebucket'
# Bucket policy defined as a dict.
bucket_policy = { ... }

s3client = boto3.client('s3', endpoint_url='https://s3.eidf.ac.uk')
# Convert 'bucket_policy' dict to JSON string.
policy = json.dumps(bucket_policy)
response = s3client.put_bucket_policy(Bucket=bucket_name,
                                      Policy=policy)
```

### Get bucket policy via Python

Use Boto3's [get_bucket_policy](https://docs.aws.amazon.com/boto3/latest/reference/services/s3/client/get_bucket_policy.html) to get a policy. For example:

```python
import json
import boto3

bucket_name = 'somebucket'

s3client = boto3.client('s3', endpoint_url='https://s3.eidf.ac.uk')
response = s3client.get_bucket_policy(Bucket=bucket_name)
# Get 'Policy' string from 'response' dict and convert to dict.
policy_string = response['Policy']
policy_data = json.loads(policy_string)
```

### Delete bucket policy via Python

Use Boto3's [delete_bucket_policy](https://docs.aws.amazon.com/boto3/latest/reference/services/s3/client/delete_bucket_policy.html) to delete a policy. For example:

```python
import boto3

bucket_name = 'somebucket'

s3client = boto3.client('s3', endpoint_url='https://s3.eidf.ac.uk')
response = s3client.delete_bucket_policy(Bucket=bucket_name)
```

---

## Example: Grant public anonymous read-only access to a bucket

!!! Warning "Publicly-readable buckets are anonymously readable by anyone"

    **Beware!** Making a bucket publicly-readable allows **anyone** who knows the bucket URL to **anonymously** read the bucket and download its files.

Here is an example JSON policy document for a project, `eidfNNN`, which grants public anonymous read-only access to their bucket, `somebucket`, allowing the the bucket to be listed and the files read (downloaded):

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicListBucket",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:ListBucket",
      "Resource": "arn:aws:s3::eidfNNN:somebucket"
    },
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3::eidfNNN:somebucket/*"
    }
  ]
}
```

This is the policy set by the [EIDF S3 Browser](./s3browser.md) if you use it to [Make a bucket public](./s3browser.md#make-a-bucket-public).

Here is the same policy, defined programmatically in Python. Python f-strings are for values in the policy to allow for it to be more easily customised for different projects and buckets:

```python
project = 'eidfNNN'
bucket_name = 'somebucket'

# Within policies for buckets within the EIDF S3 Service, the project
# name needs to prefix the bucket name.
bucket = f"{project}:{bucket_name}"

# Define bucket policy with 'Resource' values defined using Python
# f-strings so that the value of 'bucket' is inserted.
bucket_policy = {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicListBucket",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:ListBucket",
            "Resource": f"arn:aws:s3::{bucket}"
        },
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": f"arn:aws:s3::{bucket}/*"
            }
        ]
    }
```

---

## Example: Grant read-only access to another project's user

Here is an example JSON policy document for a project, `eidfNNN`, which grants read-only access to their bucket, `somebucket`, to both their own user, `nnnuser`, and a user, `abcuser`, from another project, `eidfABC`. Anyone with an access key and secret associated with the S3 user accounts `nnnuser` or `abcuser` can read from the bucket.

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "ProjectReadOnlyBucket",
      "Effect": "Allow",
      "Principal": {
          "AWS": [
            "arn:aws:iam::eidfNNN:user/nnnuser",
            "arn:aws:iam::eidfABC:user/abcuser"
          ]
      },
      "Action": [
        "s3:ListBucket",
        "s3:GetObject"
      ],
      "Resource": [
        "arn:aws:s3::eidfNNN:somebucket",
        "arn:aws:s3::eidfNNN:somebucket/*"
      ]
    }
  ]
}
```

Here is the same policy, defined programmatically in Python. Python f-strings are for values in the policy to allow for it to be more easily customised for different projects, buckets and users:

```python
project = 'eidfNNN'
bucket_name = 'somebucket'
project_user = 'nnnuser'
guest_project = 'eidfABC'
guest_user = 'abcuser'

# Within policies for buckets within the EIDF S3 Service, the project
# name needs to prefix the bucket name.
bucket = f"{project}:{bucket_name}"

# Define bucket policy with 'Principal' and 'Resource' values defined
# using Python f-strings so that the values of 'project', 'bucket',
# 'project_user', and 'guest_user' are inserted.
bucket_policy = {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ProjectReadOnlyBucket",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    f"arn:aws:iam::{project}:user/{project_user}",
                    f"arn:aws:iam::{guest_project}:user/{guest_user}"
                ]
            },
            "Action": [
                "s3:ListBucket",
                "s3:GetObject"
            ],
            "Resource": [
                f"arn:aws:s3::{bucket}",
                f"arn:aws:s3::{bucket}/*"
            ]
        }
    ]
}
```

---

## Example: Grant read-write access to another project's user

Here is an example JSON policy document for a project, `eidfNNN`, which grants read-write access to their bucket, `somebucket`, to a user, `abcuser`, from another project, `eidfABC`. Anyone with an access key and secret associated with the S3 user account `abcuser` can read from or write to the bucket or delete files in it.

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "ProjectReadWriteBucket",
      "Effect": "Allow",
      "Principal": {
          "AWS": [
            "arn:aws:iam::eidfABC:user/abcuser"
          ]
      },
      "Action": [
        "s3:ListBucket",
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject"
      ],
      "Resource": [
        "arn:aws:s3::eidfNNN:somebucket",
        "arn:aws:s3::eidfNNN:somebucket/*"
      ]
    }
  ]
}
```

Here is the same policy, defined programmatically in Python. Python f-strings are for values in the policy to allow for it to be more easily customised for different projects, buckets and users:

```python
project = 'eidfNNN'
bucket_name = 'somebucket'
guest_project = 'eidfABC'
guest_user = 'abcuser'

# Within policies for buckets within the EIDF S3 Service, the project
# name needs to prefix the bucket name.
bucket = f"{project}:{bucket_name}"

# Define bucket policy with 'Principal' and 'Resource' values defined
# using Python f-strings so that the values of 'project', 'bucket',
# and 'guest_user' are inserted.
bucket_policy = {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ProjectReadWriteBucket",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    f"arn:aws:iam::{guest_project}:user/{guest_user}"
                ]
            },
            "Action": [
                "s3:ListBucket",
                "s3:GetObject",
                "s3:PutObject",
                "s3:DeleteObject"
            ],
            "Resource": [
                f"arn:aws:s3::{bucket}",
                f"arn:aws:s3::{bucket}/*"
            ]
        }
    ]
}
```
