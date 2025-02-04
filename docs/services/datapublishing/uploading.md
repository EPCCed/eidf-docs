# Data Publishing

## Uploading your data

Once you have created your S3 bucket. We will provide credentials for uploading your data to the EIDF S3 bucket. You need an AWS client to upload data.

### Data upload

We provide an S3 account with write permissions to the dataset buckets.
As a project manager or Principal Investigator (PI), you can view the access credentials for your S3 account on the project details page. You can also grant other members of your project permission to be able to view these access credentials.

You can use the [`aws` command line client](https://aws.amazon.com/cli/) to upload your data to the bucket. For instance,

```bash
$ aws s3 cp ./jobs s3://mario-test1 --recursive --exclude "*" \
            --include "AI*" --endpoint-url https://s3.eidf.ac.uk
```

The `$` indicates the shell prompt. The command will recursively copy the contents of the `jobs` directory to the `s3://mario-test1` bucket excluding all files other than those that start with AI. The explicit end point is also specified.  

You may want to create a credentials  `~/.aws/credentials` file:

```ini
[default]
aws_access_key_id=<key>
aws_secret_access_key=<secret>
endpoint_url=https://s3.eidf.ac.uk
```

The `endpoint_url` means that you do not have to explicitly specify the URL every time. You will also have to provide your access keys.

You can use an environment variable to specify the end point instead:

```bash
$ export AWS_ENDPOINT_URL=https://s3.eidf.ac.uk
```

or if you are using the windows command prompt use:

```cmd
C:\> set AWS_ENDPOINT_URL=https://s3.eidf.ac.uk
```

or powershell:

```powershell
PS C:\> $Env:AWS_ENDPOINT_URL="https://s3.eidf.ac.uk"
```

You can list the configuration settings - make sure the `access_key` and the `secret_key` have been added:

```bash
$ aws configure list
      Name                    Value             Type    Location
      ----                    -----             ----    --------
   profile                <not set>             None    None
access_key     ****************GF61 shared-credentials-file
secret_key     ****************oPm8 shared-credentials-file
    region                <not set>             None    None
```

You can test your upload (remembering to change the bucket name):

```bash
$ aws s3 ls --summarize --human-readable --recursive s3://mario-test1/
2024-06-13 15:57:00    8.6 KiB AIY369
2024-06-13 15:57:00    8.5 KiB AIY372
...
2024-06-13 15:57:00    9.9 KiB AIY827
2024-06-13 15:57:00    9.0 KiB AIY841

Total Objects: 100
   Total Size: 895.8 KiB
```

If you do:

```bash
$ aws s3 help
```

you will get an overview of the s3 commands available or if you want more information for a particular command you can do:

```bash
$ aws s3 ls help
```

Alternatively, there are many graphical clients that act as a file browser for S3, for example [Cyberduck](https://cyberduck.io) or if you want to view programming language [Ceph S3 API](https://docs.ceph.com/en/latest/radosgw/s3/) interfaces (Ceph is the underlying platform used).
