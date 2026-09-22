# Using S3 policies

Bucket permissions use IAM (Identity Access Management) policies. You can grant other accounts (within the same project or from other projects) read or write access to your buckets.

---

## Example: Grant permissions to put, get and list objects

An example policy document to grant permissions to put, get, delete and list objects in bucket `eidfXX1:somebucket` to the account `account2` in project `eidfXX2`, is:

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

---

## Example: Give public read access to a bucket

An example policy document to give public read access to a bucket (listing and downloading files) is:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3::eidf114:mybucket/*"
    },
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:ListBucket",
      "Resource": "arn:aws:s3::eidf114:mybucket/*"
    }
  ]
}
```

Here, two policies have been chained together in the `Statement` array.

TODO: Above is from portal. Current example is as follows. Try above. If OK, then delete below. Then templatise bucket and project in above.

... replacing `<project-name>` with your EIDF project name 'eidfNNN' ... `<bucket-name>` ...

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": ["s3:ListBucket"],
      "Resource": [
        "arn:aws:s3::eidfXX1:somebucket"
      ]
    },
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": ["s3:GetObject"],
      "Resource": [
        "arn:aws:s3::eidfXX1:somebucket/*"
      ]
    }
  ]
}
```

---

## Set policy using the AWS CLI

Grant permissions stored in an IAM policy file:

```bash
aws put-bucket-policy --bucket <bucket-name> --policy "$(cat bucket-policy.json)"
```

TODO: Julien's pull request has the following. Which is correct?

```bash
aws s3api put-bucket-policy --bucket <bucket-name> --policy "$(cat bucket-policy.json)"
```

---

## Set policy using Python

Frant permissions to get and list objects in bucket `eidfXX1:somebucket` to the account `account2` in project `eidfXX2`, is:

Grant permissions to another account: In this example we grant `ListBucket` and `GetObject` permissions to account `account1` in project `eidfXX1` and `account2` in project `eidfXX2`.

TODO: Why is '{bucket_name}' used?

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
