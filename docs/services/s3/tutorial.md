# Tutorial

## AWS CLI

The following examples use the AWS CLI (command line interface) to connect to EIDF S3.

### Setup

Set your access key and secret as environment variables or configure a credentials file.

Credentials file:
```
[default]
aws_access_key_id=<key>
aws_secret_access_key=<secret>
```

Environment variables:
```
export AWS_ACCESS_KEY_ID=<key>
export AWS_SECRET_ACCESS_KEY=<secret>
```

The parameter `--endpoint-url https://s3.eidf.ac.uk` must always be set when running a command.

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

Grant access to another account

Make a bucket public

## Python