# Using S3 policies

Bucket permissions use IAM (Identity Access Management) policies. You can grant other accounts (within the same project or from other projects) read or write access to your buckets.

---

## Bucket naming in policies

Use bucket names of form `<project-name>:<bucket-name>` within policies. For example, `eidfNNN:somebucket`.

---

## Example: Grant public read access to a bucket

Here is an example policy document to grant public anonymous read access to a bucket, `mybucket`, in project `eidfNNN`, allowing the files in the bucket to be both listed and read (downloaded):

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicListBucket",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:ListBucket",
      "Resource": "arn:aws:s3::eidfNNN:mybucket"
    },
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3::eidfNNN:mybucket/*"
    }
  ]
}
```

The policy document consists of two policies, chained together in the `Statement` list.

This is the policy applied by the [EIDF S3 Browser](./s3browser.md) if you use it to [Make a bucket public](./s3browser.md#make-a-bucket-public).

!!! Warning "Publicly-readable buckets are available to all"

    Making a bucket publicly-readable allows anyone who knows the bucket URL to anonymously read the bucket, and the files within.

### Set and get a bucket policy via the AWS CLI

To set the bucket policy using the AWS CLI, run, for example:

```bash
aws s3api put-bucket-policy --bucket mybucket --policy "$(cat read-only-bucket-policy.json)"
```

To get the bucket policy using the AWS CLI, run, for example:

```bash
aws s3api get-bucket-policy --bucket mybucket  --query Policy --output text > policy.json
```

### Set and get a bucket policy via Python

An policy can be defined programatically, for example:

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

## Example: Grant permissions to put, get and list objects

An example policy document to grant permissions to list objects in a bucket, `ListBucket`, download objects, `GetObject`, upload objects, `PutObject`, and delete objects, `DeleteObject`,  in EIDF project `eidfXX1`'s bucket `eidfXX1:somebucket` to the account `account2` in EIDF project `eidfXX2`:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowAccessToBucket",
            "Principal": {
              "AWS": [
                "arn:aws:iam::eidfXX2:user/account2",
              ]
            },
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:ListBucket",
                "s3:DeleteObject",
            ],
            "Resource": [
                "arn:aws:s3:::/*",
                "arn:aws:s3::eidfXX1:somebucket"
            ]
        }
    ]
}
```

TODO: What is `Sid`?

TODO: What does this _really_ do? esp. `/*` and the bucket bit?

---

### Another example

TODO:

... replacing `<project-name>` with your EIDF project name 'eidfNNNN' ... `<bucket-name>` ...

An example policy document to grant permissions to list objects in a bucket, `ListBucket`, download objects, `GetObject`,  in EIDF project `eidfXX1`'s bucket `eidfXX1:somebucket` to the accounts `account1` in EIDF project `eidfXX1` and the account `account2` in EIDF project `eidfXX2`:

TODO: Why is '{bucket_name}' used? Because there should be format strings if in Python!

TODO: Why the `/*` too?

```python
import json

bucket_policy = {
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "arn:aws:iam::eidfXX1:user/account1",
          "arn:aws:iam::eidfXX2:user/account2",
        ]
      },
      "Action": [
          "s3:ListBucket",
          "s3:GetObject"
      ],
      "Resource": [
        "arn:aws:s3::eidfXX1:{bucket_name}"
        "arn:aws:s3::eidfXX1:{bucket_name}/*"
      ]
    }
  ]
}

policy = bucket.Policy()
policy.put(Policy=json.dumps(bucket_policy))
```
