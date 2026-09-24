# Using S3 policies

Identity Access Management (IAM) policies can be applied to buckets. For example, you can grant other accounts (within the same project or from other EIDF projects) read or write access to your buckets, or grant public anonymous read access.

Policies are defined as S3 policy documents, in JSON format.

**Author's Note**: Commands and code on this page were checked using a EIDF VM, Ubuntu 24.04.4 LTS (noble) with AWS CLI 2.36.36, Python 3.12.3, Boto3 1.43.97.

---

## Bucket naming in policies

Use bucket names of form `<project-name>:<bucket-name>` within policies. For example, `eidfNNN:somebucket`.

---

## Example: Grant public anonymous read-only access to a bucket

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

Here, the policy document consists of two policies, chained together in the `Statement` list.

This is the policy applied by the [EIDF S3 Browser](./s3browser.md) if you use it to [Make a bucket public](./s3browser.md#make-a-bucket-public).

!!! Warning "Publicly-readable buckets are available to all"

    Making a bucket publicly-readable allows anyone who knows the bucket URL to anonymously read the bucket, and the files within.

---

## Set and get a bucket policy via the AWS CLI

To set the bucket policy using the AWS CLI, run:

```bash
aws s3api put-bucket-policy --bucket <bucket> --policy "$(cat <policy-file>)"
```

For example:

```bash
aws s3api put-bucket-policy --bucket mybucket --policy "$(cat grant-public-ro.json)"
```

To get the bucket policy using the AWS CLI, run:

```bash
aws s3api get-bucket-policy --bucket <bucket> --query Policy --output text > <local-file>
```

For example:

```bash
aws s3api get-bucket-policy --bucket mybucket --query Policy --output text > policy.json
```

---

## Set and get a bucket policy via Python

A policy can be defined programmatically within Python using Boto3. For example:

```python
project = 'eidfNNN'
bucket_name = 'mybucket'

# Policies require project name to prefix bucket name.
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

This can be converted to a JSON string and then set on a bucket using Boto3's [put_bucket_policy](https://docs.aws.amazon.com/boto3/latest/reference/services/s3/client/put_bucket_policy.html). For example:

```python
# Convert 'bucket_policy' dict to JSON string.
policy = json.dumps(bucket_policy)
response = s3client.put_bucket_policy(Bucket=bucket,
                                      Policy=policy)
```

Boto3's [get_bucket_policy](https://docs.aws.amazon.com/boto3/latest/reference/services/s3/client/get_bucket_policy.html) can be used to get a policy. For example:

```python
response = s3client.get_bucket_policy(Bucket=bucket_name)
# Get 'Policy' string from 'response' dict and convert to dict.
policy_string = response['Policy']
policy_data = json.loads(policy_string)
```

---

## Example: Grant read-only access to another project's user

Here is an example JSON policy document for a project, `eidfNNN`, which grants read-only access to their bucket, `somebucket`, to both their own user, `nnnuser`, and a user, `abcuser`, from another project, `eidfABC`. Anyone with an access key and secret associated with `nnnuser` or `abcuser` can read from the bucket.

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

---

## Example: Grant read-write access to another project's user

Here is an example JSON policy document for a project, `eidfNNN`, which grants read-write access to their bucket, `somebucket`, to a user, `abcuser`, from another project, `eidfABC`. Anyone with an access key and secret associated with `abcuser` can read from or write to the bucket.

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
