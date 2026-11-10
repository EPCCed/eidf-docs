# Using S3 policies

S3 policies allow you to control who can use a bucket, or the files within the bucket, what they can do with these, and when. Rich, fine-grained, highly project-specific policies can be applied.

**Author's Note**: Commands and code on this page were checked using a EIDF VM, Ubuntu 24.04.4 LTS (noble) with AWS CLI 2.36.36, Python 3.12.3, Boto3 1.43.97.

---

## Introducing S3 policies

To introduce S3 policies, consider the following. Imagine a bucket, `mybucket`, has been created by project `eidfNNN` by their S3 account `someuser`. By default, this bucket can be accessed and used by any `eidfNNN` project member with the access key and secret key associated with `someuser`. Now, project `eidfNNN` wants to work with another project, `eidfABC`, and wants to grant that project read-write access to `mybucket`.

Here is a policy document which, when attached to `mybucket`, grants read-write access to `eidfNNN`'s bucket, `mybucket`, to an S3 account, `abcuser`, belonging to project, `eidfABC`.

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "ProjectListGetDelete",
      "Effect": "Allow",
      "Principal": {
          "AWS": [
            "arn:aws:iam::eidfABC:user/abcuser"
          ]
      },
      "Action": [
        "s3:ListBucket",
        "s3:GetObject",
        "s3:DeleteObject"
      ],
      "Resource": [
        "arn:aws:s3:::mybucket",
        "arn:aws:s3:::mybucket/*"
      ]
    },
    {
      "Sid": "ProjectPut",
      "Effect": "Allow",
      "Principal": {
          "AWS": [
            "arn:aws:iam::eidfABC:user/abcuser"
          ]
      },
      "Action": [
        "s3:PutObject"
      ],
      "Resource": [
        "arn:aws:s3:::mybucket",
        "arn:aws:s3:::mybucket/*"
      ],
      "Condition": {
        "StringEquals": {
          "s3:x-amz-acl": "bucket-owner-full-control"
        }
      }
    }
  ]
}
```

Essentially, what any S3 policy says is 'if a `Principal` makes a request to perform an `Action` on a `Resource`, then, taking into account any `Condition`s, the `Effect` is to either `Deny` or `Allow` the `Action`'.

More specifically, this example policy states that:

* S3 account `abcuser` of project `eidfABC` (`Principal`) is allowed to list the bucket contents, download files and delete files (`Action`) within the bucket `mybucket` (`Resource`).
* S3 account `abcuser` of project `eidfABC` (`Principal`) is allowed to upload files, (`Action`) within the bucket `mybucket` (`Resource`) but only if they grant the bucket owner full control over the uploaded file (`Condition`).

Anything not specifically allowed by a policy is denied. The exception is for the S3 account that created the bucket, who can create, list, download files from and upload files and delete files from the bucket, and delete the bucket itself.

S3 policies are defined as documents in [JSON](https://json.org) format. The key features of a policy document, as shown in the example above, are as follows:

* `Version`: Policy language syntax version. The current version is 2012-10-17.
* `Statement`: A single policy statement or list of policy statements. Here, the policy document includes two statements.
* `Sid`: An optional, human-readable, policy statement identifier.
* `Action`: A single S3 action or a list of S3 actions to which the policy statement applies.
* `Resource`: A single S3 resource or a list of S3 resources to which the policy statement applies.
    * A resource can be a bucket, or files in a bucket, or another resource. Here, both the bucket, `mybucket`, and all the files within the bucket, `mybucket/*`, are specified.
    * S3 resources are specified as Amazon Resource Name (ARN). Within the EIDF S3 Service, ARNs for buckets and objects have a prefix `arn:aws:s3:<region>:<project-name>:<bucket>`, where `<region>` is empty, and `<project-name>` is optional.
* `Principal`: A single principal or a list of principals to who permission being allowed or denied.
    * The `AWS` element is required and specifies the list of principals.
    * Each principal is specified as an Amazon Resorce Names (ARN). Within the EIDF S3 Service, ARNs for principals have form `arn:aws:iam:<region>:<project-name>:<account>`, where `<region>` is empty, `<project-name>` is an EIDF project name (e.g., `eidfABC`), and `<account>` is an S3 account in that project. `<project-name>` can be empty if the S3 account belongs to the same project as the bucket to which the policy is attached.
    * Either `"*"` or `{"AWS":"*"}` can be used to specify any principal, which allows for anonymous access to a bucket or its files.
* `Condition`: An optional element specifying any condition(s) affecting the policy.
    * `StringEquals` compares a value from a 'context variable', a variable provided by the principal when requesting the action, to an expected value. Here, it is expected that the context variable `s3:x-amz-acl`, which specifies a 'canned', or pre-defined, access control list (ACL), needs to be equal to `bucket-owner-full-control`.
* `Effect`: Whether the policy allows (`Allow`) or denies (`Deny`) the actions governed by the policy.
    * Explicit `Deny` statements override explicit `Allow` statements.

!!! Info "Ceph S3 support for Amazon S3 policies"

    Ceph S3 supports a subset of the Amazon S3 policy language. For information on what is, and is not, supported, see Ceph S3 [Bucket Policies](https://docs.ceph.com/en/latest/radosgw/bucketpolicy/).

---

## Manage bucket policies via the AWS CLI

### Set bucket policy via the AWS CLI

To set a policy, run:

```bash
aws s3api put-bucket-policy --bucket <bucket> --policy "$(cat <policy-file>)"
```

For example:

```bash
aws s3api put-bucket-policy --bucket mybucket --policy "$(cat grant-public-ro.json)"
```

### Get bucket policy via the AWS CLI

To get a policy, run:

```bash
aws s3api get-bucket-policy --bucket <bucket> --query Policy --output text > <local-file>
```

For example:

```bash
aws s3api get-bucket-policy --bucket mybucket --query Policy --output text > policy.json
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
aws s3api delete-bucket-policy --bucket mybucket
```

---

## Manage bucket policies via Python

### Set bucket policy via Python

Bucket policies can be defined in JSON files and loaded into Python as a JSON string. Alternatively, policies can be defined programmatically as a Python dictionary, then converted to a JSON string. In either case, the policy, as a JSON string, can be submitted to the EIDF S3 Service, for example using the Amazon Web Services Software Development Kit for Python, [Boto3](https://aws.amazon.com/sdk-for-python/).

Use Boto3's [put_bucket_policy](https://docs.aws.amazon.com/boto3/latest/reference/services/s3/client/put_bucket_policy.html) to set a policy. For example:

```python
import json
import boto3

bucket_name = 'mybucket'
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

bucket_name = 'mybucket'

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

bucket_name = 'mybucket'

s3client = boto3.client('s3', endpoint_url='https://s3.eidf.ac.uk')
response = s3client.delete_bucket_policy(Bucket=bucket_name)
```

---

## Grant public read-only access to a bucket

!!! Warning "Publicly readable buckets are anonymously readable by anyone"

    **Beware!** Making a bucket publicly readable allows **anyone** who knows the bucket URL to **anonymously** read the bucket and download its files.

Here is a policy document which grants public read-only access to a bucket, `mybucket`, allowing the bucket to be listed and its files read (downloaded):

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicListBucket",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:ListBucket",
      "Resource": "arn:aws:s3:::mybucket"
    },
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::mybucket/*"
    }
  ]
}
```

This policy is comparable to the policy set by the [EIDF S3 Browser](./s3browser.md) if you use it to [Make a bucket publicly readable](./s3browser.md#make-a-bucket-publicly-readable).

!!! Info "Project name in resource names"

    The policy set by the [EIDF S3 Browser](./s3browser.md) when used to [Make a bucket publicly readable](./s3browser.md#make-a-bucket-publicly-readable) has Amazon Resource Names of form:

    ```text
    "Resource": "arn:aws:s3::eidfNNN:<bucket>"
    "Resource": "arn:aws:s3::eidfNNN:<bucket>/*"
    ```

    The example above does not cite the project name, `eidfNNN`, i.e.,:

    ```text
    "Resource": "arn:aws:s3:::<bucket>"
    "Resource": "arn:aws:s3:::<bucket>/*"
    ```

    In this example, citing the project name, `eidfNNN`, in the S3 `Resource` values, is optional. Within the S3 service, the policy is attached to a specific bucket within a project, and the S3 service itself can infer from the bucket the associated project.

Here is the same policy document, defined programmatically in Python:

```python
bucket_name = 'mybucket'

# Define bucket policy with 'Resource' values defined using Python
# f-strings so that the value of 'bucket_name' is inserted.
bucket_policy = {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicListBucket",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:ListBucket",
            "Resource": f"arn:aws:s3:::{bucket_name}"
        },
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": f"arn:aws:s3:::{bucket_name}/*"
            }
        ]
    }
```

---

## Grant read-only access to another project's S3 account

Here is a policy document which grants read-only access to a bucket, `mybucket`, to an S3 account, `abcuser`, belonging to a project, `eidfABC`. Anyone with an access key and secret associated with the S3 account `abcuser` can read from the bucket.

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "ProjectReadOnlyBucket",
      "Effect": "Allow",
      "Principal": {
          "AWS": [
            "arn:aws:iam::eidfABC:user/abcuser"
          ]
      },
      "Action": [
        "s3:ListBucket",
        "s3:GetObject"
      ],
      "Resource": [
        "arn:aws:s3:::mybucket",
        "arn:aws:s3:::mybucket/*"
      ]
    }
  ]
}
```

Here is the same policy document, defined programmatically in Python:

```python
bucket_name = 'mybucket'
guest_project = 'eidfABC'
guest_account = 'abcuser'

# Define bucket policy with 'Principal' and 'Resource' values defined
# using Python f-strings so that the values of 'guest_project',
# 'guest_account' and 'bucket_name' are inserted.
bucket_policy = {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ProjectReadOnlyBucket",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    f"arn:aws:iam::{guest_project}:user/{guest_account}"
                ]
            },
            "Action": [
                "s3:ListBucket",
                "s3:GetObject"
            ],
            "Resource": [
                f"arn:aws:s3:::{bucket_name}",
                f"arn:aws:s3:::{bucket_name}/*"
            ]
        }
    ]
}
```

---

## Grant read-write access to another project's S3 account

Here is a policy document which grants read-write access to a bucket, `mybucket`, to an S3 account, `abcuser`, belonging to a project, `eidfABC`. Anyone with an access key and secret associated with the S3 account `abcuser` can read from or write to the bucket or delete files in it.

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
        "arn:aws:s3:::mybucket",
        "arn:aws:s3:::mybucket/*"
      ]
    }
  ]
}
```

Here is the same policy document, defined programmatically in Python:

```python
bucket_name = 'mybucket'
guest_project = 'eidfABC'
guest_account = 'abcuser'

# Define bucket policy with 'Principal' and 'Resource' values defined
# using Python f-strings so that the values of 'guest_project',
# 'guest_account' and 'bucket_name' are inserted.
bucket_policy = {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ProjectReadWriteBucket",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    f"arn:aws:iam::{guest_project}:user/{guest_account}"
                ]
            },
            "Action": [
                "s3:ListBucket",
                "s3:GetObject",
                "s3:PutObject",
                "s3:DeleteObject"
            ],
            "Resource": [
                f"arn:aws:s3:::{bucket_name}",
                f"arn:aws:s3:::{bucket_name}/*"
            ]
        }
    ]
}
```

### Require bucket owner to be given full control over uploaded files

The above policy is a copy of that for [Grant read-only access to another project's S3 account](#grant-read-only-access-to-another-projects-s3-account) with both `s3:PutObject` and `s3:DeleteObject` added to the `Action` list. However, it has a problem. in that, by default, when a file is uploaded, it is owned by the account of the uploader, in this example, the guest S3 account, `abcuser`.

A subsequent attempt by the bucket owner to read the uploaded file, which is in their own bucket, would then raise an error:

```text
An error occurred (403) when calling the HeadObject operation: Forbidden
```

While the bucket owner can delete the uploaded file from their bucket they cannot read it! To avoid this problem, the guest S3 account needs to grant the bucket owner full control over the uploaded file. In Python, this can done by passing an extra argument to [upload_file](https://docs.aws.amazon.com/boto3/latest/reference/services/s3/client/upload_file.html):

```python
s3client.upload_file(Filename=os.path.join(uploads, data),
                     Bucket=bucket,
                     Key=key,
                     ExtraArgs={'ACL': 'bucket-owner-full-control'})
```

This requests that the EIDF S3 service apply a 'canned', or pre-defined, access control list (ACL) called `bucket-owner-full-control` to the object once uploaded. Behind the scenes, when the EIDF S3 service is contacted, the request includes an S3 `x-amz-acl` parameter with value `bucket-owner-full-control`.

The requirement for this argument can be made mandatory by updating the policy to deny any upload request that does not include this argument. Here is the updated policy:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "ProjectListGetDelete",
      "Effect": "Allow",
      "Principal": {
          "AWS": [
            "arn:aws:iam::eidfABC:user/abcuser"
          ]
      },
      "Action": [
        "s3:ListBucket",
        "s3:GetObject",
        "s3:DeleteObject"
      ],
      "Resource": [
        "arn:aws:s3:::mybucket",
        "arn:aws:s3:::mybucket/*"
      ]
    },
    {
      "Sid": "ProjectPut",
      "Effect": "Allow",
      "Principal": {
          "AWS": [
            "arn:aws:iam::eidfABC:user/abcuser"
          ]
      },
      "Action": [
        "s3:PutObject"
      ],
      "Resource": [
        "arn:aws:s3:::mybucket",
        "arn:aws:s3:::mybucket/*"
      ],
      "Condition": {
        "StringEquals": {
          "s3:x-amz-acl": "bucket-owner-full-control"
        }
      }
    }
  ]
}
```

The first policy statement is as before, allowing the guest S3 account to list the bucket, download files and delete files. However, a new policy statement is introduced for file uploads, `s3:PutObject`, which requires any upload request to include the 'canned' ACL `s3:x-amz-acl` parameter with value `bucket-owner-full-control`.

If the guest S3 account attempts to upload a file without this argument, then their upload will be denied. For example:

```text
Failed to upload data/edinburgh.csv to eidf114:mybucket/scotland/lothian/edinburgh.csv: An error occurred (AccessDenied) when calling the PutObject operation: None"
```

Here is the same policy document, defined programmatically in Python:

```python
bucket_name = 'mybucket'
guest_project = 'eidfABC'
guest_account = 'abcuser'

# Define bucket policy with 'Principal' and 'Resource' values defined
# using Python f-strings so that the values of 'guest_project',
# 'guest_account' and 'bucket_name' are inserted.
bucket_policy = {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ProjectListGetDelete",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    f"arn:aws:iam::{guest_project}:user/{guest_account}"
                ]
            },
            "Action": [
                "s3:ListBucket",
                "s3:GetObject",
                "s3:DeleteObject"
                ],
            "Resource": [
                f"arn:aws:s3:::{bucket_name}",
                f"arn:aws:s3:::{bucket_name}/*"
            ]
        },
        {
            "Sid": "ProjectPut",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    f"arn:aws:iam::{guest_project}:user/{guest_account}"
                ]
            },
            "Action": [
                "s3:PutObject"
                ],
            "Resource": [
                f"arn:aws:s3:::{bucket_name}",
                f"arn:aws:s3:::{bucket_name}/*"
            ],
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
```

!!! Important "Let guest users know to grant the bucket owner full control over uploaded files"

    If using this policy, then you need to let guest S3 account users know that they need to request that the EIDF S3 service apply the 'canned' ACL `bucket-owner-full-control` to their object once uploaded.

    If using Python and Boto3 this can be done using an `ExtraArgs={'ACL': 'bucket-owner-full-control'}` argument to `upload_file`. Other S3 packages have their own approaches.

---

## Create an anonymous S3 download link for a project bucket

An S3 policy can be used to create anonymous S3 download links for files within a project bucket. Below is the source code for an example Python script, `create_anonymous_s3_download.py`, that uploads a file into a bucket, creates a key for the file, and applies an S3 policy to configure read-only access to the file within a specific time period and constrains access to clients from a specific range of IP addresses only. The script can be run as follows:

```bash
python create_anonymous_s3_download.py <bucket> <download-id> <file> \
    <valid-from> <valid-to> <ips>
```

where:

* `<file>` is uploaded into `<bucket>` with key `downloads/<download-id>/<file-name>`. If `<download-id>` has value `auto`, then a secure random ID is created, else `<download-id>` is used as-is.
* `<valid-from>` and `<valid-to>` are date-times of form `<YYYY>-<MM>-<DD>T<HH>:<MM>:<SS>Z` where `T` is the delimiter between date and time and `Z` denotes 'UTC' time.
* `<ips>` is a comma-delimited list of one or more IP addresses in CIDR notation i.e., of form `<ip-address>/<routing-prefix>`. Use a `<routing-prefix>` of `32` to specify a single IP address (e.g., `11.22.33.44/32`) or `24` to specify a range of 256 addresses (e.g., `11.22.33.0/24`).

A bucket policy is applied to allow anonymous downloads only of this file with this key. Downloads are only allowed between the `<valid-from>` and `<valid-to>` date-times and only from hosts in the list of `<ips>`.

For example, running:

```bash
python create_anonymous_s3_download.py mybucket auto data/edinburgh.csv \
    2026-11-09T15:30:00Z 2026-11-09T16:00:00Z 10.24.9.999/32
```

would upload `data/ediunburgh.csv` and assign it a key with a secure random ID. For example, `downloads/oImIs5K5AhTRP-lFB31upw/edinburgh.csv`. This file would be anonymously readable between 15:30 and 16:00 on 09-11-2026 only to a host with IP address 10.24.9.999. Any attempt to access any other file, to access the file outside of these times or from another host would give an error.

These constraints are enforced by the following S3 policy, created by the script:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowPublicGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::mybucket/downloads/oImIs5K5AhTRP-lFB31upw/edinburgh.csv",
      "Condition": {
        "DateGreaterThan": {
          "aws:CurrentTime": "2026-11-10T15:30:00Z"
        },
        "DateLessThan": {
          "aws:CurrentTime": "2026-11-10T16:00:00Z"
        }
      }
    },
    {
      "Sid": "DenyUnknownIPs",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::mybucket/downloads/oImIs5K5AhTRP-lFB31upw/edinburgh.csv",
      "Condition": {
        "NotIpAddress": {
          "aws:SourceIp": [
            "10.24.9.999/32"
          ]
        }
      }
    }
  ]
}
```

!!! Important "Explicit `Deny` statements override explicit `Allow` statements"

    In this policy there is both an `Allow` statement and a `Deny` statement. Within S3 policies, explicit `Deny` statements always override explicit `Allow` statements. So, for this example, even if a request is made to the bucket with the correct key and within the allowed times, if the host IP is not 10.24.9.999, then the request would be denied.

`create_anonymous_s3_download.py`:

```python
#!/usr/bin/env python

mport json
import os.path
import secrets
import sys
import boto3
from botocore.exceptions import ClientError

# Bucket in project
bucket_name = sys.argv[1]
# Download ID
download_id = sys.argv[2]
# Upload file path
upload_file = sys.argv[3]
# Downloads valid from time
valid_from = sys.argv[4]
# Downloads valid to time
valid_to = sys.argv[5]
# IPs
ips = sys.argv[6].split(",")

s3client = boto3.client('s3',
                        endpoint_url='https://s3.eidf.ac.uk')

if download_id == 'auto':
    download_id = secrets.token_urlsafe(16)
file_name = os.path.basename(upload_file)
key = f"downloads/{download_id}/{file_name}"

try:
    s3client.upload_file(upload_file,
                         Bucket=bucket_name,
                         Key=key)
except ClientError as e:
    print(str(e))
    sys.exit(1)
except boto3.exceptions.S3UploadFailedError as e:
    print(str(e))
    sys.exit(1)

bucket_policy = {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowPublicGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": f"arn:aws:s3:::{bucket_name}/{key}",
            "Condition": {
                "DateGreaterThan": {"aws:CurrentTime": valid_from},
                "DateLessThan": {"aws:CurrentTime": valid_to}
            }
        },
        {
            "Sid": "DenyUnknownIPs",
            "Effect": "Deny",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": f"arn:aws:s3:::{bucket_name}/{key}",
            "Condition": {
                "NotIpAddress": {
                    "aws:SourceIp": ips
                }
            }
        }
    ]
}

policy = json.dumps(bucket_policy)
response = s3client.put_bucket_policy(Bucket=bucket_name,
                                      Policy=policy)
print(key)
```

---

## More information on S3 policies

This page is a necessarily brief introduction to S3 policies. For more information, see, for example

* AWS [Policies and permissions in Amazon S3](https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-policy-language-overview.html)
* AWS [IAM JSON policy element reference](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_elements.html)
* AWS [Allows access based on date and time](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_examples_aws-dates.html)
* AWS: [Denies access to AWS based on the source IP](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_examples_aws_deny-ip.html)
