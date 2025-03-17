# Tutorial

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
endpoint_url=https://s3.eidf.ac.uk
```

Environment variables:

```bash
export AWS_ACCESS_KEY_ID=<key>
export AWS_SECRET_ACCESS_KEY=<secret>
export AWS_ENDPOINT_URL=https://s3.eidf.ac.uk
```

### Commands

List the buckets in your account:

```bash
aws s3 ls
```

Create a bucket:

```bash
aws s3api create-bucket --bucket <bucketname>
```

Upload a file:

```bash
aws s3 cp <filename> s3://<bucketname>
```

Check that the file above was uploaded successfully by listing objects in the bucket:

```bash
aws s3 ls s3://<bucketname>
```

To read from a public bucket without providing credentials, add the option `--no-sign-request` to the call:

```bash
aws s3 ls s3://<bucketname> --no-sign-request
```

You can get help on the options for any command using:

```bash
aws s3 help
```

or for particular commands

```bash
aws s3 ls help
```

### Examples

You want to upload all the files in a subdirectory to your S3 bucket

```bash
aws s3 cp ./mydir s3://mybucket --recursive --exclude "*" --include "*.dat" 
```

Here all `*.dat`  files only in `mydir` will be uploaded to `s3://mybucket`.

You can check your upload using:

```bash
aws s3 ls --summarize --human-readable --recursive s3://mybucket/
```

For public S3 buckets, such as those provided for the data publishing service,  you can construct a downloadable https link  to download files from an S3 link, e.g. taking:

```text
s3://eidfXXX-my-dataset/mydatafile.csv
```

and by making the following transformation:

```
https://s3.eidf.ac.uk/eidfXXX-my-dataset/mydatafile.csv
```

Now you can open this link in a browser to download the file.

Alternatively, you can use the aws client to download an entire data set:

```bash
aws s3 cp --recursive s3://eidfXXX-my-dataset/ ./mydataset --no-sign-request
```

will copy the entire content of the S3 bucket to your `mydataset` subdirectory. Note that you must use `--no-sign-request` when accessing public buckets.

## Python using `boto3`

The following examples use the Python library `boto3`.

### Install

Installation:

```bash
python -m pip install boto3
```

### Usage

#### Connect

Create an S3 client resource:

```python
import boto3
s3 = boto3.resource('s3')
```

#### List buckets

```python
for bucket in s3.buckets.all():
    print(f'{bucket.name}')
```

#### List objects in a bucket

```python
bucket_name = 'somebucket'
bucket = s3.Bucket(bucket_name)
for obj in bucket.objects.all():
    print(f'{obj.key}')
```

#### Uploading files to a bucket

```python
bucket = s3.Bucket(bucket_name)
bucket.upload_file('./somedata.csv', 'somedata.csv')
```

In boto3 version 1.36, a breaking change was introduced that adopts new default integrity protections which is not currently supported by EIDF S3
(see [https://github.com/boto/boto3/issues/4392](https://github.com/boto/boto3/issues/4392)). If you see this error

```text
botocore.exceptions.ClientError: An error occurred (XAmzContentSHA256Mismatch) when calling the PutObject operation: None
```

use the following configuration for your client:

```python
from botocore.config import Config
config = Config(
    request_checksum_calculation="when_required",
    response_checksum_validation="when_required",
)
s3 = boto3.resource('s3', config=config)
```

Then upload your files as shown above.

### Accessing buckets in other projects

Buckets owned by an EIDF project are placed in a tenancy in the EIDF S3 Service.
The project code is a prefix on the bucket name, separated by a colon (`:`), for example `eidfXX1:somebucket`.

This is only relevant when accessing buckets outside your project tenancy - if you access buckets in your own project you can ignore this section.

By default, the `boto3` Python library raises an error that bucket names with a colon `:` (as used by the EIDF S3 Service) are invalid.

When accessing a bucket with the project code prefix, switch off the bucket name validation:

```python
import boto3
from botocore.handlers import validate_bucket_name

s3 = boto3.resource('s3', endpoint_url='https://s3.eidf.ac.uk')
s3.meta.client.meta.events.unregister('before-parameter-build.s3', validate_bucket_name)
```

## Access policies

Buckets owned by an EIDF project are placed in a tenancy in the EIDF S3 Service.
The project code is a prefix on the bucket name, separated by a colon (`:`), for example `eidfXX1:somebucket`.
Note that some S3 client libraries do not accept bucket names in this format.

Bucket permissions use IAM (Identity Access Management) policies. You can grant other accounts (within the same project or from other projects) read or write access to your buckets.

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
