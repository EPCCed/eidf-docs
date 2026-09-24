# Using the EIDF S3 Service via Python

## Introduction

This page provides examples of how to use the EIDF S3 Service via Python and the Amazon Web Services Software Development Kit for Python, [Boto3](https://aws.amazon.com/sdk-for-python/). These examples assume you are familiar with the content of [Getting started with S3 and the EIDF S3 Service](./getting-started.md).

The tutorial was developed under an EIDF VM, Ubuntu 24.04.4 LTS (noble) with AWS CLI 2.36.36, Python 3.12.3, Boto3 1.43.97.

---

## Install Boto3

There are a number of options for installing the Boto3 package. Here, Boto3 is installed into a new Python virtual environment using 'pip'. Alternatively, you can used your preferred means of managing Python packages.

```bash
sudo apt install -y python3-venv
python3 -m venv s3-venv
source s3-venv/bin/activate
```

Install Boto3:

```bash
python -m pip install boto3
```

---

## Create an S3 client

To interact with the EIDF S3 Service within Python, you can create a [client](https://docs.aws.amazon.com/boto3/latest/guide/clients.html) service interface.

!!! Note "Boto3 'resource' versus 'client' service interfaces"

    Boto3 provides both an object-oriented [Resources](https://docs.aws.amazon.com/boto3/latest/guide/resources.html) service interface and a [Low-level clients](https://docs.aws.amazon.com/boto3/latest/guide/clients.html) service interface, which maps more closely to S3 service APIs. On the 'Resources' page, the AWS Python SDK team advise that the interface is feature-frozen and recommend the use of the 'client' service interface. For this reason, the client interface is used in these examples.

### Create an S3 client to interact with your project's S3 endpoint

The client needs to know the S3 endpoint URL, an access key, the access key's associated secret, and the service region. The client can be configured in various ways:

* Create AWS CLI configuration within `~/.aws/config` and `~/.aws/credentials` files.
    * Either, [Set AWS CLI configuration via the command-line](./getting-started.md#set-aws-cli-configuration-via-the-command-line).
    * Or, [Create AWS CLI configuration files](./getting-started.md#create-aws-cli-configuration-files).
* [Set AWS CLI environment variables](./getting-started.md#set-aws-cli-environment-variables).
* In-code parameters, as shown below.

AWS CLI configuration files, environment variables and in-code parameters can be used together. If this is the case, then the in-code parameters have highest precedence, followed by the environment variables, and, then, the configuration files.

A minimal S3 client, if using AWS CLI configuration or environment variables, can be created as follows:

```python
import boto3

s3client = boto3.client('s3')
```

An S3 client, using in-code parameters, can be created as follows:

```python
import boto3

s3client = boto3.client(
    's3',
    endpoint_url='https://s3.eidf.ac.uk',
    region_name='us-east-1',
    aws_access_key_id='<access-key>',
    aws_secret_access_key='<secret>'
)
```

If you are using the EIDF S3 Service from within an [EIDF Confidential Data Workspace](../confidentialdataworkspace/index.md), then add a `verify` parameter to `boto3.client` with the path to the web proxy certificate bundle:

```python
s3client = boto3.client(
    's3',
    endpoint_url='https://s3.eidf.ac.uk',
    region_name='us-east-1',
    aws_access_key_id='<access-key>',
    aws_secret_access_key='<secret>',
    verify='/usr/local/share/ca-certificates/extra/squid_proxyCA.crt'
)
```

Boto3 [Session](https://docs.aws.amazon.com/boto3/latest/reference/core/session.html) provides information on the parameters supported by `boto3.client` (`boto3.client` creates a `boto3.session.Session` behind the scenes).

!!! Tip "Troubleshooting: `botocore.exceptions.ClientError: An error occurred (XAmzContentSHA256Mismatch) when calling the PutObject operation: None`"

    In Boto3 version 1.36 a breaking change was introduced that adopts new default integrity protections which is not currently supported by EIDF S3 (see Boto3 GitHub issue [boto/boto#4392](https://github.com/boto/boto3/issues/4392)). If you see this error, then:

    * Either, add the following to your AWS CLI configuration file (~/.aws/config`):

        ```ini
        # Required for Python Boto3 version 1.36 and later which
        # introduced a breaking change that adopts new default
        # integrity protections not currently supported by EIDF S3.
        request_checksum_calculation=when_required
        response_checksum_validation=when_required
        ```

    * Or, update your Boto3 S3 client creation code as follows:

        ```python
        from botocore.config import Config

        config = Config(
            request_checksum_calculation="when_required",
            response_checksum_validation="when_required",
        )
        ```

        Then, add `config=config` to your `boto3.client` call. For example:

        ```python
        s3client = boto3.client('s3', config=config)
        ```

### Create an S3 client to use buckets within other projects

Bucket names of form `<project-name>:<bucket-name>` need to be used for public buckets within a project, if accessing anonymously, or public or private buckets within a project, for which access has been granted to you, when using an access key.

But, be aware that, as described in [Public project buckets or buckets within other projects](./getting-started.md#public-project-buckets-or-buckets-within-other-projects) such bucket names are strictly invalid and some S3 tools do not allow such bucket names to be used. By default, Boto3 validates bucket names, and so disallows these, but the validation can be turned off.

This can be turned off as follows, after creating the S3 client, `s3client` in this example:

```python
from botocore.handlers import validate_bucket_name

s3client.meta.events.unregister('before-parameter-build.s3',
                                validate_bucket_name)
```

### Create an S3 client to read from a public project bucket

Disabling bucket name validation as described in the previous section is required to anonymously read from a public project bucket. However, there is no need for any AWS CLI configuration nor environment variables nor authentication.

An S3 client that meets these requirements can be created as follows:

```python
import boto3
from botocore import UNSIGNED
from botocore.client import Config
from botocore.handlers import validate_bucket_name

s3client = boto3.client('s3',
                        endpoint_url='https://s3.eidf.ac.uk',
                        config=Config(signature_version=UNSIGNED))
s3client.meta.events.unregister('before-parameter-build.s3',
                                validate_bucket_name)
```

### Create an S3 client to interact with the EIDF Data Publishing Service

Bucket names of form `<project-name>-<bucket-name>` need to be used to anonymously read from public buckets within the [EIDF Data Publishing Service](../datapublishing/service.md). As these are valid bucket names, so Boto3's bucket validation does not need to be turned off. There is no need for any AWS CLI configuration nor environment variables nor authentication.

An S3 client that meets these requirements can be created as follows:

```python
import boto3
from botocore import UNSIGNED
from botocore.handlers import validate_bucket_name

s3client = boto3.client('s3',
                        endpoint_url='https://s3.eidf.ac.uk',
                        config=Config(signature_version=UNSIGNED))
```

---

## List buckets

[list_buckets](https://docs.aws.amazon.com/boto3/latest/reference/services/s3/client/list_buckets.html) lists the buckets at the S3 endpoint URL. For example, get a list of buckets, and print their names:

```python
response = s3client.list_buckets()
# Get 'Buckets' list from 'response' dict.
buckets = response['Buckets']
# For each bucket's dict, print bucket 'Name'.
for bucket in buckets:
    print(f'{bucket['Name']}')
```

The `response` from `list_buckets` includes information about the buckets.

---

## Create buckets

[create_bucket](https://docs.aws.amazon.com/boto3/latest/reference/services/s3/client/create_bucket.html) creates a bucket. For example:

```python
response = s3client.create_bucket(Bucket='mybucket')
```

The `response` from `create_bucket` includes information about the new bucket.

!!! Tip "Troubleshooting: `botocore.exceptions.ClientError: An error occurred (InvalidBucket-Name) when calling the CreateBucket operation: None`"

    This error can occur if a bucket name does not conform to the naming requirements.

!!! Tip "Troubleshooting: `botocore.exceptions.ParamValidationError: Parameter validation failed: Invalid bucket name'"

    This error can occur if a bucket name does not conform to the naming requirements, specifically if it has a colon `:`.

---

## List files in a bucket

[list_objects_v2](https://docs.aws.amazon.com/boto3/latest/reference/services/s3/client/list_objects_v2.html) lists the files (objects) in a bucket. For example, get a list of files, and print their keys:

```python
response = s3client.list_objects_v2(Bucket='mybucket')
# Get 'Contents'  list from 'response' dict, but only if 'Contents' is
# present i.e., bucket has one or more files.
if 'Contents' in response:
    # For each file's dict, print file 'Key'.
    for f in response['Contents']:
        print(f'{f['Key']}')
```

!!! Warning "`list_objects_v2` returns maximum of 1000 objects per call"

    `list_objects_v2` returns maximum of 1000 objects per call, even if there are more than 1000 objects matching the request. See the Boto3 documentation on [Paginators](https://docs.aws.amazon.com/boto3/latest/guide/paginators.html) for information on how to handle buckets with more than 1000 objects.

---

## Upload file

[upload_file](https://docs.aws.amazon.com/boto3/latest/reference/services/s3/client/upload_file.html) uploads a file to a bucket. For example:

```python
s3client.upload_file(Filename='edinburgh.csv',
                      Bucket='mybucket',
                      Key='scotland/lothian/edinburgh.csv')
```

!!! Tip "Upload multiple files"

    Multiple files can be uploaded by calling `upload_file` on each file in turn.

!!! Warning "A trailing slash in a key is part of the key name"

    If a key has a trailing slash then the trailing slash becomes part of the key name. For example,

    ```python
    s3client.upload_file(Filename='edinburgh.csv',
                         Bucket='mybucket',
                         Key='scotland/lothian/')
    ```

    will upload the file and give it the key `scotland/lothian/`. This is different from how the AWS CLI behaves, where uploading the file` to `s3://mybucket/scotland/lothian/` will upload the file and give it the key `scotland/lothian/edinburgh.csv`'. AWS CLI adds `edinburgh.csv` to the path before contacting the S3 service. Boto3 does not.

    However, both Boto3 and the AWS CLI allow for files whose keys have trailing slashes to be downloaded.

---

## Download file

[download_file](https://docs.aws.amazon.com/boto3/latest/reference/services/s3/client/download_file.html) downloads a file from a bucket. For example:

```python
s3client.download_file(Filename='edinburgh.csv',
                       Bucket='mybucket',
                       Key='scotland/lothian/edinburgh.csv')
```

!!! Tip "Download multiple files"

    Multiple files can be downloaded by calling `download_file` on each file in turn.

---

## List files and sizes

The `response` from `list_objects_v2` includes information about each file. This includes each file's size, keyed by `Size`. This can be used to calculate the total number of objects in the bucket and their total size. For example:

```python
response = s3client.list_objects_v2(Bucket='mybucket')
total_size = 0
num_files = 0
if 'Contents' in response:
    for f in response['Contents']:
        # For each file's dict, print file 'Key' and 'Size'.
        print(f'{f['Key']}: {f['Size']} bytes')
        total_size += f['Size']
    num_files = len(response['Contents'])
print(f"Number of files: {num_files}. Total size: {total_size}")
```

---

## List files with a prefix

`list_object_v2` has a `Prefix` parameter allowing for files whose keys have a specific prefix to be listed. For example:

```python
response = s3client.list_objects_v2(Bucket='mybucket',
                                    Prefix='scotland')
```

```python
response = s3client.list_objects_v2(Bucket='mybucket',
                                    Prefix='scotland/lothian/ed')
```

---

## Delete file

[delete_object](https://docs.aws.amazon.com/boto3/latest/reference/services/s3/client/delete_object.html) allows for a file to be deleted. For example:

```python
response = s3client.delete_object(Bucket='mybucket',
                                  Key='scotland/lothian/edinburgh.csv')
```

The `response` from `delete_object` includes information about the deletion.

---

## Delete multiple files

Multiple files can be deleted by calling `delete_file` on each file in turn. Alternatively, [delete_objects](https://docs.aws.amazon.com/boto3/latest/reference/services/s3/client/delete_objects.html) allows for multiple files to be deleted, given a list of the file keys. For example:

```python
response = s3client.delete_objects(
        Bucket='mybucket',
        Delete={
            'Objects':
                [
                    {'Key': 'scotland/lothian/edinburgh.csv'},
                    {'Key': 'scotland/strathclyde/glasgow.csv'},
                    {'Key': 'scotland/grampian/aberdeen.csv'}
                ]
        }
)
```

The `response` from `delete_objects` includes information about the deletion.

The list of keys could be created programmatically from a query to `list_objects_v2`. For example:

```python
response = s3client.list_objects_v2(Bucket='mybucket')
file_keys = None
if 'Contents' in response:
    # Create list of keys compatible with that expected by
    # 'delete_objects'.
    file_keys = [{'Key': obj['Key']} for obj in response['Contents']]

response = s3client.delete_objects(Bucket='mybucket',
                                   Delete={'Objects': file_keys})
```

---

## Delete bucket

[delete_bucket](https://docs.aws.amazon.com/boto3/latest/reference/services/s3/client/delete_bucket.html) allows for a bucket to be deleted. For example:

```python
response = s3client.delete_bucket(Bucket='mybucket')
```

The `response` from `delete_bucket` includes information about the deletion.

!!! Tip "Troubleshooting: `botocore.exceptions.ClientError: An error occurred (BucketNotEmpty) when calling the DeleteBucket operation: None'"

    This error can occur if an attempt is made to delete a bucket that is not empty.
