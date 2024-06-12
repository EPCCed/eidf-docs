# Tutorial

Buckets owned by an EIDF project are placed in a tenancy in the EIDF S3 Service.
The project code is a prefix on the bucket name, separated by a colon (`:`), for example `eidfXX1:somebucket`.
Note that some S3 client libraries do not accept bucket names in this format.

## AWS CLI

The following examples use the AWS Command Line Interface (AWS CLI) to connect to EIDF S3.

### Setup

Install with pip

```bash
python -m pip install awscli
```

Installers are available for various platforms if you are not using Python: see [https://aws.amazon.com/cli/](https://aws.amazon.com/cli/)

### Configure

Set your access key and secret as environment variables or configure a credentials file at `~/.aws/credentials` on Linux or `%USERPROFILE%\.aws\credentials` on Windows.

Credentials file:

```ini
[default]
aws_access_key_id=<key>
aws_secret_access_key=<secret>
```

Environment variables:

```bash
export AWS_ACCESS_KEY_ID=<key>
export AWS_SECRET_ACCESS_KEY=<secret>
```

The parameter `--endpoint-url https://s3.eidf.ac.uk` must always be set when calling a command.

### Commands

List the buckets in your account:

```bash
aws s3 ls --endpoint-url https://s3.eidf.ac.uk
```

Create a bucket:

```bash
aws s3api create-bucket --bucket <bucketname> --endpoint-url https://s3.eidf.ac.uk
```

Upload a file:

```bash
aws s3 cp <filename> s3://<bucketname> --endpoint-url https://s3.eidf.ac.uk
```

Check that the file above was uploaded successfully by listing objects in the bucket:

```bash
aws s3 ls s3://<bucketname> --endpoint-url https://s3.eidf.ac.uk
```

To read from a public bucket without providing credentials, add the option `--no-sign-request` to the call:

```bash
aws s3 ls s3://<bucketname> --no-sign-request --endpoint-url https://s3.eidf.ac.uk
```

## Python using `boto3`

The following examples use the Python library `boto3`.

### Install

Installation:

```bash
python -m pip install boto3
```

### Usage

By default, the `boto3` Python library raises an error that bucket names with a colon `:` (as used by the EIDF S3 Service) are invalid, so we have to switch off the bucket name validation:

```python
import boto3
from botocore.handlers import validate_bucket_name

s3 = boto3.resource('s3', endpoint_url='https://s3.eidf.ac.uk')
s3.meta.client.meta.events.unregister('before-parameter-build.s3', validate_bucket_name)
```

List buckets:

```python
for bucket in s3.buckets.all():
    print(f'{bucket.name}')
```

List objects in a bucket:

```python
project_code = 'eidfXXX'
bucketname = 'somebucket'
bucket = s3.Bucket(f'{project_code}:{bucket_name}')
for obj in bucket.objects.all():
    print(f'{obj.key}')
```

Upload a file to a bucket:

```python
bucket = s3.Bucket(f'{project_code}:{bucket_name}')
bucket.upload_file('./somedata.csv', 'somedata.csv')
```

## Access policies

Bucket permissions use IAM policies. You can grant other accounts (within the same project or from other projects) read or write access to your buckets.
For example to grant permissions to put, get, delete and list objects in bucket `eidfXX1:somebucket` to the account `account2` in project `eidfXX2`:

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

You can chain multiple policies in the statement array:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Principal": { ... }
            "Effect": "Allow",
            "Action": [ ... ],
            "Resource": [ ... ]
        },
        {
            "Principal": { ... }
            "Effect": "Allow",
            "Action": [ ... ],
            "Resource": [ ... ]
        }
    ]
}
```

Give public read access to a bucket (listing and downloading files):

```json
{
 "Version": "2012-10-17",
 "Statement": [
  {
    "Effect": "Allow",
    "Principal": "*",
    "Action": ["s3:ListBucket"],
    "Resource": [
      f"arn:aws:s3::eidfXX1:somebucket"
    ]
  },
  {
    "Effect": "Allow",
    "Principal": "*",
    "Action": ["s3:GetObject"],
    "Resource": [
      f"arn:aws:s3::eidfXX1:somebucket/*"
    ]
   }
 ]
}
```

### Set policy using AWS CLI

Grant permissions stored in an IAM policy file:

```bash
aws put-bucket-policy --bucket <bucketname> --policy "$(cat bucket-policy.json)"
```

### Set policy using Python `boto3`

Grant permissions to another account: In this example we grant `ListBucket` and `GetObject` permissions to account `account1` in project `eidfXX1` and `account2` in project `eidfXX2`.

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
      f"arn:aws:s3::eidfXX1:{bucket_name}"
      f"arn:aws:s3::eidfXX1:{bucket_name}/*"
    ]
  }
 ]
}

policy = bucket.Policy()
policy.put(Policy=json.dumps(bucket_policy))
```
