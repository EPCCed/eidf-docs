# Tutorial introduction to the EIDF S3 Service

---

## Introduction

This tutorial provides a hands-on introduction to S3 and the EIDF S3 Service.

The tutorial assumes you have been granted access to the EIDF S3 Service or, for using public buckets only, have been given appropriate EIDF S3 credentials.

The tutorial has been checked using the following platforms and packages as follows:

* EIDF VM, Ubuntu 24.04.4 LTS (noble), AWS CLI 2.36.36.

---

## About S3

TODO:

Amazon S3 (Simple Storage Service) Amazon Web Services

'S3' as Amazon product vs. 'S3' as defacto API standard implemented by others, offering S3-compatible APIs.

Aside: 'S3' is a a 'proprietary metonym' like 'Post-It' for 'sticky notes',  'Hoover' for 'vacuum cleaner' or 'Google' for 'online search'!

The EIDF S3 Service is an S3 object store. S3 means 'Simple Storage Service'.

'flat', key-value (hashtable, associative array, Python dict, R list in general concept, but storage, not in-memory!)

Endpoints

Buckets:

* Contain objects each of which has a key.
* Names unique across all S3 users, alphanumeric characters plus dot and dash.
* DNS and FQDN bucket names e.g. 's3://my-bucket.s3tools.org' are recommended.
* Cannot be nested.

Files vs. objects (file content + metadata), here we use files to keep it simple, unless we need to refer to objects.

Objects:

* Names, UTF-8, up to 1024 bytes long.
* Public, accessible via HTTP.
* Private
* Access Control Lists (ACL)

Naming

Prefix, virtual folder/directory

---

## About the EIDF S3 Service

The EIDF S3 Service is an S3 object store. S3 means 'Simple Storage Service'.

Whether some operations fail or do nothing depends on both S3 client and S3 Service.

S3 products differ in S3 capabilities.

EIDF S3 uses Ceph S3.

Subset of Amazon S3 REST API

---

## Get information to use the EIDF S3 Service

To use an S3 Service, you will need the S3 Service endpoint URL, an access key and secret.

The EIDF S3 Service endpoint is https://s3.eidf.ac.uk.

To view S3 account names, access keys, secrets, and storage and bucket quotas:

1. On the [Your Projects](https://portal.eidf.ac.uk/project/) page within the EIDF Portal, click your project.
1. Your select project's page will appear.
1. If using the portal's new project view, click **Your S3 Keys**.
1. The 'S3 Access Keys' section will show a table where each row shoes:
    * **Name**: S3 account name.
    * **Quota**: Maximum amount of storage available to the account.
    * **Buckets**: Maximum number of buckets the account can create.
    * **Keys**: Access keys associated with this account, and, via the **Secret** drop-down menu, each key's associated secret.

![EIDF Portal S3 Access Keys](../../images/access/portal-s3-keys.png){: class="border-img"}

!!! Note "S3 access keys and permissions"

    You will only see those access keys, and associated S3 accounts, which your project lead has granted you permission to view.

    If you are a project lead, then you will see all the access keys, for all S3 accounts, for your project.

!!! Note "S3 Service region"

    In the following, there are references to a region, `us-east-1`. This is a default, it does **not** mean that the EIDF S3 Service is hosted in the US, it is not!

---

## Use EIDF S3 via the command-line

This section describes how to use the EIDF S3 Service via the command-line, using the [AWS Command Line Interface](https://aws.amazon.com/cli/) (AWS CLI). Other S3 clients are available, a selection is listed in [Other S3 Clients](#other-s3-clients) below.

### Install the AWS CLI

Install the AWS CLI:

```bash
curl -fsSL https://awscli.amazonaws.com/v2/install.sh | bash
```

TODO: Windows|Mac install, paths etc.

!!! Note "AWS CLI install location"

    On EIDF VMs, the AWS CLI is installed into `$HOME/.local/share/aws-cli` with a symbolic link in `$HOME/.local/bin`. Your EIDF `.profile` ensures that `$HOME/.local/bin` is on your `PATH`.

Check version:

```bash
aws --version
```

The version will be shown.

!!! Tip "Troubleshooting: `command not found`"

    If you get `command not found`, then add `~/.local/bin` to your `PATH` environment variable:

    ```bash
    export PATH="~/.local/bin:$PATH"
    ```

The AWS CLI S3 commands are of form:

```bash
aws s3 <command>
```

To get help on the AWS CLI options for any S3 command, run:

```bash
aws s3 help
```

For a particular command, run:

```bash
aws s3 <command> help
```

For example, for help on the AWS CLI S3 `ls` command, run:

```bash
aws s3 ls help
```

### Configure the AWS CLI

To interact with the EIDF S3 Service, the AWS CLI needs to know the S3 endpoint URL, an access key and the access key's associated secret. This can be configured in one of three ways: via an AWS CLI configuration command, manually writing configuration and credentials files, or defining via environment variables.

#### Set endpoint and credentials configuration

Interactively set access key and secret.

```bash
aws configure
```

You will be prompted for the access key and secret and region name. You will also be prompted for an output format, for which you can accept the default:

```text
AWS Access Key ID [None]: <access_key>
AWS Secret Access Key [None]: <secret>
Default region name [None]: us-east-1
Default output format [None]:
```

Set the endpoint:

```bash
aws configure set endpoint_url https://s3.eidf.ac.uk
```

If you are using the EIDF S3 Service from within an [EIDF Confidential Data Workspace](../confidentialdataworkspace/index.md), then add the path to the web proxy certificate bundle:

```bash
aws configure set ca_bundle /usr/local/share/ca-certificates/extra/squid_proxyCA.crt
```

#### Create configuration and credentials files manually

Create a configuration file, `~/.aws/config` on Linux or `%USERPROFILE%\.aws\config` on Windows, with content:

```ini
[default]
endpoint_url = https://s3.eidf.ac.uk
region = us-east-1
```

Create a credentials file, `~/.aws/credentials` on Linux or `%USERPROFILE%\.aws\credentials` on Windows, with content:

```ini
[default]
aws_access_key_id = <access_key>
aws_secret_access_key = <secret>
```

Set the credentials file to be readable by you only (Linux users only):

```bash
chmod go-rwx .aws/credentials
```

If you are using the EIDF S3 Service from within an [EIDF Confidential Data Workspace](../confidentialdataworkspace/index.md), then add the path to web proxy certificate bundle to `.aws/config`:

```ini
ca_bundle = /usr/local/share/ca-certificates/extra/squid_proxyCA.crt
```

#### Set AWS CLI environment variables

Set the following environment variables:

```bash
export AWS_ACCESS_KEY_ID=<access_key>
export AWS_SECRET_ACCESS_KEY=<secret>
export AWS_ENDPOINT_URL=https://s3.eidf.ac.uk
export AWS_ENDPOINT_URL_S3=${AWS_ENDPOINT_URL}
export AWS_S3_ENDPOINT=${AWS_ENDPOINT_URL}
export AWS_DEFAULT_REGION=us-east-1
```

If you are using the EIDF S3 Service from within an [EIDF Confidential Data Workspace](../confidentialdataworkspace/index.md), define the following environment variable with the path to the web proxy certificate bundle:

```bash
export AWS_CA_BUNDLE=/usr/local/share/ca-certificates/extra/squid_proxyCA.crt
```

!!! Note "`AWS_ENDPOINT_URL` vs. `AWS_ENDPOINT_URL_S3` vs. `AWS_S3_ENDPOINT`"

    `AWS_ENDPOINT_URL` is a URL for any services accessed via the AWS CLI, including S3. It is recognised by the AWS CLI.

    `AWS_ENDPOINT_URL_S3` is a URL for S3 Services accessed via the AWS CLI. It too is recognised by the AWS CLI.

    `AWS_S3_ENDPOINT` is a URL for legacy or custom packages that interact with S3 Services. It is not recognised by the AWS CLI.

    All three are defined here to cover all possible tools you may use in this tutorial.

#### Further information on AWS CLI configuration

For further information on AWS CLI configuration, see the AWS CLI documentation on:

* [AWS CLI Configuration Variables](https://docs.aws.amazon.com/cli/latest/topic/config-vars.html).
* [Configuration and credential file settings in the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html).
* [Configuring environment variables for the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html).
* [aws configure set](https://docs.aws.amazon.com/cli/latest/reference/configure/set.html).

### List and create buckets

List the buckets in your account:

```bash
aws s3 ls
```

If you are using a newly-created EIDF S3 Service for your project, then there will be no buckets shown.

!!! Tip "Troubleshooting `SSL validation failed for https://s3.eidf.ac.uk/`"

    If you are using the EIDF S3 Service from within an [EIDF Confidential Data Workspace](../confidentialdataworkspace/index.md), and you see an error like:

    ```text
    SSL validation failed for https://s3.eidf.ac.uk/ [SSL: CERTIFICATE_VERIFY_FAILED] certificate verify failed: self signed certificate in certificate chain (_ssl.c:1032)
    ```

    then you need to configure the path to the web proxy certificate bundle. This can be done as described earlier, either using a ` ca_bundle` configuration value or an `AWS_CA_BUNDLE` environment variable.

Create a bucket, 'mybucket':

```bash
aws s3 mb s3://mybucket
```

`s3://mybucket` is an S3 URI. S3 URIs are a standard way of referencing buckets, and files, available at S3 endpoints.

!!! Important "Bucket names"

    Bucket names must be between 3-63 characters in length, and must contain only lower case letters, numbers, hyphens `-`, or full stops `.`. See the AWS S3 documentation on [General purpose bucket naming rules](https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html).

A message will be displayed:

```text
make_bucket: mybucket
```

!!! Tip "Troubleshooting: `make_bucket failed: s3://<bucketname> argument of type 'NoneType' is not a container or iterable`"

    This error can occur if a bucket name does not conform to the naming requirements.

!!! Tip "Troubleshooting: `make_bucket failed: s3://<bucketname> Parameter validation failed`"

    This error can also occur if a bucket name does not conform to the naming requirements, specifically if it has a colon `:`.

Now, list the buckets again:

```bash
aws s3 ls
```

The new bucket will be listed:

```text
2026-09-04 09:18:35 mybucket
```

List the files in the bucket, prefixing the bucket name with `s3://` so that the AWS CLI knows that the bucket on the S3 Service is being referred to:

```bash
aws s3 ls s3://mybucket
```

The new bucket will be empty.

!!! Note "Bucket ownership within the EIDF S3 Service"

    Within the EIDF S3 Service, buckets are owned by the S3 account associated with the access key used to create the bucket.

### Upload and download a file

Create a file, `unis.csv`, with content:

```csv
name,postcode
The University of Edinburgh,EH8 9YL
Edinburgh Napier University,EH14 1DJ
Heriot-Watt University,EH14 4AS
Queen Margaret University,EH21 6UU
```

Upload the file into the bucket:

```bash
aws s3 cp unis.csv s3://mybucket
```

The file will be listed as it is uploaded:

```text
upload: ./unis.csv to s3://mybucket/unis.csv
```

!!! Tip "Troubleshooting: `aws: [ERROR]: An error occurred (ParamValidation): usage: aws s3 cp <LocalPath> <S3Uri> or <S3Uri> <LocalPath> or <S3Uri> <S3Uri>`

    This error can arise if the bucket name does not have the `s3` prefix.

Now, list the contents of the bucket:

```bash
aws s3 ls s3://mybucket
```

The listing will now include the file:

```text
2026-09-04 09:18:40        154 unis.csv
```

The key of the file in the bucket is `unis.csv` i.e., the file name itself.

Now, download this file. First, move `unis.csv` out of the way:

```bash
mv unis.csv unis.csv.bak
```

Download the file into the current directory, specifying the file's key within the bucket:

```bash
aws s3 cp s3://mybucket/unis.csv .
```

The file will be downloaded:

```text
download: s3://mybucket/unis.csv to ./unis.csv
```

Now compare the downloaded file to the original file that you backed up:

```bash
cmp unis.csv unis.csv.bak
```

No differences should be reported, thereby showing that `unis.csv` was both uploaded into and downloaded from the bucket successfully.

### Upload and download multiple files

Multiple files can be both uploaded to and downloaded from an S3 bucket.

Create a `data` directory and add 6 data files, 3 with suffix `.dat` and 3 with suffix `.txt`, and each with 1000 random characters:

```bash
mkdir -p data
for i in 1 2 3; do
    base64 /dev/urandom | head -c 1000 > data/data$i.dat
    base64 /dev/urandom | head -c 1000 > data/data$i.txt
done
```

Now, upload all `.dat` files, and only `.dat` files, from `data` into the bucket:

```bash
aws s3 cp data s3://mybucket --recursive --exclude "*" --include "*.dat"
```

Only the 3 `.dat` files will be uploaded:

```text
upload: data/data2.dat to s3://mybucket/data2.dat
upload: data/data1.dat to s3://mybucket/data1.dat
upload: data/data3.dat to s3://mybucket/data3.dat
```

List the bucket to see the uploaded files:

```bash
aws s3 ls s3://mybucket
```

The listing will include the uploaded files:

```text
2026-09-04 09:18:45       1000 data1.dat
2026-09-04 09:18:45       1000 data2.dat
2026-09-04 09:18:45       1000 data3.dat
2026-09-04 09:18:40        154 unis.csv
```

Now, download all `.dat` files from the bucket into a new local `downloaded` directory, ignoring any other files (for example, `unis.csv`), then list its contents:

```bash
aws s3 cp s3://mybucket downloaded --recursive --exclude "*" --include "*.dat"
ls -1 downloaded
```

The files will be listed as they are downloaded:

```text
download: s3://mybucket/data1.dat to downloaded/data1.dat
download: s3://mybucket/data3.dat to downloaded/data3.dat
download: s3://mybucket/data2.dat to downloaded/data2.dat
```

The `downloaded` directory will contain the downloaded files:

```text
data1.dat
data2.dat
data3.dat
data4.dat
data5.dat
```

### Delete files

Delete each data file in turn:

```bash
aws s3 rm s3://mybucket/data1.dat
aws s3 rm s3://mybucket/data2.dat
aws s3 rm s3://mybucket/data3.dat
aws s3 rm s3://mybucket/data4.dat
aws s3 rm s3://mybucket/data5.dat
```

List the files in the bucket that are left:

```bash
aws s3 ls s3://mybucket
```

```text
2026-09-04 09:18:40        154 unis.csv
```

### Prefixes and virtual directories

So far, all the file uploads and downloads that have been done have used the file name as a key name for the files object within the S3 Service.

Run the following to upload `unis.csv` into the bucket:

```bash
aws s3 cp unis.csv s3://mybucket/lothian/edunis
```

The upload message is:

```text
upload: ./unis.csv to s3://mybucket/lothian/edunis
```

When the file is uploaded using path `s3://mybucket/lothian/edunis`, the S3 Service interprets this as 'upload `unis.csv` to `mybucket` and give it the key `lothian/edunis`'.

Now, rerun the command, but this time add a trailing slash to `edinburgh`:

```bash
aws s3 cp unis.csv s3://mybucket/lothian/edinburgh/
```

The upload message is now:

```text
upload: ./unis.csv to s3://mybucket/lothian/edinburgh/unis.csv
```

When the file is uploaded using path `s3://mybucket/lothian/edinburgh/`, the S3 Service interprets this as 'upload `unis.csv` to `mybucket` and give it the key `lothian/edinburgh/unis.csv`'.

The absence of a trailing slash is interpreted to mean that the is to be given the key name specified in the path e.g., `lothian/edunis`. In contrast, the presence of a trailing slash is interpreted to mean that the file is to be given the key name specified in the path plus the filename itself e.g., `lothian/edinburgh/unis.csv`.

Both these file's keys share a common prefix, `lothian/edinburgh/`. This can be seen by listing the files in the bucket:

```bash
aws s3 ls s3://mybucket
```

```text
                           PRE lothian/
2026-09-04 09:18:40        154 unis.csv
```

`PRE` indicates that `lothian/` is a prefix and that there are files in the bucket whose keys have prefix `lothian/`. However, by default, these files are not listed.

Rerun the command, adding a `--recursive` option to request that these files be listed with their keys:

```bash
aws s3 ls s3://mybucket --recursive
```

```text
2026-09-04 09:18:58        154 lothian/edinburgh/unis.csv
2026-09-04 09:18:56        154 lothian/edunis
2026-09-04 09:18:40        154 unis.csv
```

Now, list those files with the prefix `lothian/` as follows, by adding the prefix to the bucket name:

```bash
aws s3 ls s3://mybucket/lothian/
```

```text
                           PRE edinburgh/
2026-09-04 09:18:56        154 edunis
```

`PRE` indicates that `edinburgh/` is a prefix and that there are files in the bucket whose keys have prefix `lothian/edinburgh/`. `edunis` is also shown without its prefix.

List these files, again using the `--recursive` option:

```bash
aws s3 ls s3://mybucket/lothian/ --recursive
```

Now all the files with prefix `lothian/` are shown with their full keys:

```text
2026-09-04 09:18:58        154 lothian/edinburgh/unis.csv
2026-09-04 09:18:56        154 lothian/edunis
```

Now, list the files with prefix `lothian/edinburgh/`:

```bash
aws s3 ls s3://mybucket/lothian/edinburgh/
```

```text
2026-09-04 09:18:58        154 unis.csv
```

And, again, requesting that the full keys be shown:

```bash
aws s3 ls s3://mybucket/lothian/edinburgh/ --recursive
```

```text
2026-09-04 09:11:28        154 lothian/edinburgh/unis.csv
```

Prefixes relate to the concept of 'virtual directories'. Each prefix is akin to a virtual directory. Here, the bucket has a virtual directory `lothian/` which, in turn, has a virtual directory, `edinburgh/`. Running `aws s3 ls` and citing `lothian/` or `edinburgh/` or `lothian/edinburgh/` is akin to listing the contents of these virtual directories including their files and any virtual directories, therein.

Adding the `--recursive` option is akin to a recursive listing of these virtual directories and their subdirectories.

!!! Important "Virtual directories are virtual!"

    Keep in mind that an S3 Service offers 'flat' object store with each bucket holding objects each with a unique key. This is why the term 'virtual directories' is used, the use of prefixes mimic directories but are not actual directories!

Run the following commands, but omit the trailing slashes:

```bash
aws s3 ls s3://mybucket/lothian
aws s3 ls s3://mybucket/lothian/edinburgh
```

```text
                           PRE lothian/

                           PRE edinburgh/
```

Since there are no trailing slashes, both `lothian` and `lothian/edinburgh` are not treated as prefixes but rather as queries to show all files whose keys start with `lothian` and `lothian/edinburgh` respectively. That this is the case can be seen by running the following commands, listing all files whose keys start with `u`, `lothian/e` and `lothian/edu` respectively:

```bash
aws s3 ls s3://mybucket/u
aws s3 ls s3://mybucket/lothian/e
aws s3 ls s3://mybucket/lothian/edu
```

```text
2026-09-04 09:18:40        154 unis.csv

                           PRE edinburgh/
2026-09-04 09:18:56        154 edunis

2026-09-04 09:18:56        154 edunis
```

Again, note the presence of `PRE` for the prefix `edinburgh/`. `--recursive` can be used to list all the files with their full keys:

```bash
aws s3 ls s3://mybucket/lothian/e --recursive
```

```text
2026-09-04 09:18:58        154 lothian/edinburgh/unis.csv
2026-09-04 09:18:56        154 lothian/edunis
```

In terms of virtual directories, these queries can be viewed as akin to using wildcards to list matching virtual directories and files within these.

!!! Warning "Trailing slashes are significant"

    When uploading or downloading files, a trailing slash is significant. A reference to `s3://mybucket/a/b/c/` is **not** the same as a reference to `s3://mybucket/a/b/c`.

    Uploading a file to `s3://mybucket/a/b/c/` results in a file with key `a/b/c//<filename>`. In contrast, uploading a file to `s3://mybucket/a/b/c` results in a file with key `a/b/c`.

    Downloading a file from `s3://mybucket/a/b/c/` will fail unless the `--recursive` option is used as it is a request to download all files whose key has prefix `a/b/c/`. In contrast, downloading a file from `s3://mybucket/a/b/c` will succeed if there is a file with key `a/b/c`, otherwise it will fail.

### List files and file sizes

List the files in a bucket and the total number of files (objects) and their total size. For example:

```bash
aws s3 ls s3://mybucket --summarize --human-readable
```

This lists information on files (objects) in the bucket only, not any whose keys have prefixes (i.e., not any in a virtual directory):

```text
                           PRE lothian/
2026-09-04 09:18:40  154 Bytes unis.csv

Total Objects: 1
   Total Size: 154 Bytes
```

As done previously, use the `--recursive` option to list information on all files:

```bash
aws s3 ls s3://mybucket --summarize --human-readable --recursive
```

```text
2026-09-04 09:18:58  154 Bytes lothian/edinburgh/unis.csv
2026-09-04 09:18:56  154 Bytes lothian/edunis
2026-09-04 09:18:40  154 Bytes unis.csv

Total Objects: 3
   Total Size: 462 Bytes
```

### Delete files and buckets

Delete a file:

```bash
aws s3 rm s3://mybucket/lothian/edunis
```

The file being deleted will be shown:

```text
delete: s3://mybucket/lothian/edunis
```

!!! Note

    If the file's key is unknown then this command does nothing, but the above message will still be printed.

Delete all files with prefix `lothian/edinburgh/`:

```bash
aws s3 rm s3://mybucket/lothian/edinburgh/ --recursive
```

```text
delete: s3://mybucket/lothian/edinburgh/unis.csv
```

!!! Warning "Trailing slashes are significant"

    When deleting files, a trailing slash is significant. A reference to `s3://mybucket/a/b/c/` is **not** the same as a reference to `s3://mybucket/a/b/c`.

    Deleting files using reference `s3://mybucket/a/b/c/` will do nothing unless the `--recursive` option is used. If used, then **all** files with prefix `a/b/c/` will be deleted. If no such files exist, then deletion does nothing.

    Deleting files using reference `s3://mybucket/a/b/c` will succeed if there is a file with key `a/b/c` and will do nothing otherwise. If the `--recursive` option is used, then **all** files whose key starts with `a/b/c` will be deleted (e.g., if there were files `a/b/cookie`, `a/b/c/dough`, then these would both be deleted).

!!! Tip "Dry run file deletions"

    `aws s3 rm` supports a `--dryrun` option, which, if used, will list the files that will be deleted without deleting them.

Delete all files in a bucket:

```bash
aws s3 rm s3://mybucket --recursive
```

```text
delete: s3://mybucket/unis.csv
```

Delete an empty bucket:

```bash
aws s3 rb s3://mybucket
```

!!! Troubleshooting "`remove_bucket failed: s3://<bucketname> argument of type 'NoneType' is not a container or iterable`"

    This error can occur if an attempt is made to delete a bucket that is not empty.

---

## Other S3 clients

There are many other S3 clients available.

The [EIDF S3 Browser](https://portal.eidf.ac.uk/project/s3browser/) is part of the EIDF S3 Service and offers a web-based user interface within the EIDF Portal for creating and managing buckets and uploading, downloading and deleting files. See [Using the EIDF S3 Browser](./s3browser.md).

Another command-line client is [s3cmd](https://s3tools.org/s3cmd).

A client offering a graphical user interface is [Cyberduck](https://cyberduck.io). If using Cyberduck, you may need to [Connect using Deprecated Path Style Requests](https://docs.cyberduck.io/protocols/s3/#connecting-using-deprecated-path-style-requests) otherwise you may have problems listing the contents of a bucket. For more information, see the [Cyberduck documentation](https://docs.cyberduck.io/cyberduck/).

These, and other, clients may each have client-specific ways of configuring the clients to interact with S3 Services. Consult the relevant client's documentation for details.

---

## Use EIDF S3 via Python

This section describes how to use the EIDF S3 Service via Python and the Amazon Web Services Software Development Kit for Python, [boto3](https://aws.amazon.com/sdk-for-python/).

The example tasks covered are comparable to those described in [Use EIDF S3 via the command-line](#use-eidf-s3-via-the-command-line).

TODO: Use comparable examples from the foregoing, with a different bucket name.

### Install boto3

Here, we install 'boto3' into a new Python virtual environment. Alternatively, use your preferred means of managing and installing Python packages.

```bash
sudo apt install -y python3.12-venv
python3 -m venv s3-venv
source s3-venv/bin/activate
```

Install boto3:

```bash
python -m pip install boto3
```

### Configure Python to connect to the EIDF S3 Service

TODO: Does boto3 use '.aws'? Which environment variables does boto3 use? Which Python `botocore.config` parameters? Where best to put all this? Clean this up!

Credentials can be passed in as parameters to the functions, as shown below, or as environment variables, as described earlier. Alternatively, you can set environment variables from within Python using `os.environ`.

Update `.aws/config`:

```ini
# The following two lines are required for Python boto3 version 1.36
# and later which introduced a breaking change that adopts new default
# integrity protections not currently supported by EIDF S3.
request_checksum_calculation=when_required
response_checksum_validation=when_required
```

!!! Note

    The last two lines are required since boto3 version 1.36 when a breaking change was introduced that adopts new default integrity protections which is not currently supported by EIDF S3 (see boto3 GitHub issue [boto/boto#4392](https://github.com/boto/boto3/issues/4392)) If you see this error:

    ```text
    botocore.exceptions.ClientError: An error occurred (XAmzContentSHA256Mismatch) when calling the PutObject operation: None
    ```

    then add the following Python code to your script:

    ```python
    from botocore.config import Config
    config = Config(
        request_checksum_calculation="when_required",
        response_checksum_validation="when_required",
    )
    s3 = boto3.resource('s3', config=config)
    ```

### Interact with the EIDF S3 Service using Python

TODO: Check, edit, run.

Connect, create an S3 client resource:

```python
import boto3
s3 = boto3.resource('s3')
```

List buckets:

```python
for bucket in s3.buckets.all():
    print(f'{bucket.name}')
```

List files in a bucket:

```python
bucket_name = 'somebucket'
bucket = s3.Bucket(bucket_name)
for obj in bucket.objects.all():
    print(f'{obj.key}')
```

Upload files to a bucket:

```python
bucket = s3.Bucket(bucket_name)
bucket.upload_file('./somedata.csv', 'somedata.csv')
```

Download file a bucket:

```py
import os
resource = boto3.resource(
    "s3",
    region_name = "us-east-1",
    endpoint_url = "http://nsh-fs02:7070",
    aws_access_key_id = "put_your_key_here",
    aws_secret_access_key = "put_your_secret_here")
bucket = resource.Bucket("bucket_name")
bucket.download_file(
    "326834963428524640226726425259803542053/249177910747091225438117569123869339900/MR.304084489533501143843524990882920225135-an.dcm",
    "downloaded.dcm")
```

---

## Use EIDF S3 via R

This section describes how to use the EIDF S3 Service via R and the [TODO](TODO) package.

The example tasks covered are comparable to those described in [Use EIDF S3 via the command-line](#use-eidf-s3-via-the-command-line).

TODO: Use comparable examples from the foregoing, with a different bucket name.

There are three different packages for R that you could install:

* [aws.s3](https://cran.r-project.org/web/packages/aws.s3/)
* [s3](https://cran.r-project.org/web/packages/s3/)
* [paws](https://cran.r-project.org/web/packages/paws/)

`aws.s3` is recommended and documented here.

TODO: Above is from `docs/safe-haven-services/s3-service.md` pull request. Why is aws.cli recommended and not Amazon's own paws?

### Configure R to connect to the EIDF S3 Service

TODO: Does aws.s3|paws use '.aws'? Which environment variables does boto3 use? Which Python `botocore.config` parameters? Where best to put all this? Clean this up!

Credentials can be passed in as environment variables, as described earlier. Alternatively, you can set environment variables within your `.Renviron` file or from within R using `Sys.setenv`.

!!! Important

    For the endpoint, `aws.s3` uses environment variable `AWS_S3_ENDPOINT`, not `AWS_ENDPOINT_URL`.

### Interact with the EIDF S3 Service using R

TODO: Use comparable examples to those used for Python.

TODO: Check, edit, run.

```r
library(aws.s3)
my_bucket <- "bucket_name"
my_access_key <- "put_your_key_here"
my_secret_key <- "put_your_secret_here"
my_region <- "us-east-1"
my_endpoint <- "http://nsh-fs02:7070"
my_endpoint_host <- "nsh-fs02:7070"
my_object_path <- "326834963428524640226726425259803542053/249177910747091225438117569123869339900/MR.304084489533501143843524990882920225135-an.dcm"
Sys.setenv( AWS_ENDPOINT_URL="http://nsh-fs02:7070" )
Sys.setenv( AWS_S3_ENDPOINT="http://nsh-fs02:7070" )
Sys.setenv( AWS_DEFAULT_REGION="us-east-1" )
Sys.setenv( http_proxy="" )
save_object( my_object_path,
             file = "downloaded.dcm",
             bucket = my_bucket,
             base_url = my_endpoint_host,
             region = "",
             use_https = FALSE,
             key = my_access_key,
             secret = my_secret_key )
```

!!! Important

    `install.packages()` must be called **before** `Sys.setenv( http_proxy="" )`, so that any packages are downloaded via the web proxy otherwise R won't be able to access the packages.

    You need to have the region set in the environment variable `AWS_DEFAULT_REGION` and pass `region=""` to `save_object`, otherwise you will get a `cannot resolve host` error.

    The `base_url` argument to `save_object` is the host and port only with no `http://` prefix.

    `use_https` must be `FALSE`.

---

## Use the EIDF S3 Service via other programming languages

TODO: Check, edit for consistency with foregoing.

If you want to use another programming language have a look at the [Ceph S3 API](https://docs.ceph.com/en/latest/radosgw/s3/) interfaces (Ceph is the underlying platform used).

---

## EIDF S3 bucket URIs and URLs

There are subtleties around how to refer to EIDF S3 Service buckets and files in both S3 bucket URIs and URLs, depending on both how the bucket is being accessed and where within the EIDF S3 Service it is hosted.

### Private buckets

To refer to private buckets and files within a project, when using an access key for that project, use S3 URIs of form `s3://<bucket-name>`. For example:

```text
s3://mybucket
s3://mybucket/my-data-file.csv
```

### Private buckets in other projects or public project buckets

To refer to private buckets and files within a project when using an access key for another project that has been granted access to that project, or to refer to public project buckets and files in such projects, use S3 bucket URIs of form `s3://<project-name>:<bucket-name>`, where the bucket name is prefixed by its project name and delimited by a colon `:`. For example:

```text
s3://eidfNNN:mybucket
s3://eidfNNN:mybucket/my-data-file.csv
```

!!! Note "Projects, buckets and tenancies"

    Each project has its own tenancy within the EIDF S3 Service. The tenancy holds the buckets for that project. Tenancies allow for different projects to have buckets with the same name without any ambiguity.

    The project name specified within S3 URIs allows for the project tenancy to be identified, before identifying the bucket within that project's tenancy.

    A project prefix is not required when accessing buckets within a project using an access key for that project as the access key itself identifies the project's tenancy.

!!! Warning "Project identification and S3 tools"

    S3 URIs of form `s3://<project-name>:<bucket-name>` are strictly invalid as their specification does not include the concept of tenancies, so `<project-name>:<bucket-name>` is viewed as an invalid bucket name due to the presence of the colon.

    Some S3 tools do not allow such S3 URIs to be used, for example the AWS CLI. Others, however, will, including the Python and R packages already described.

TODO: Revisit once you've actually checked this for Python and R!

### Public buckets within the EIDF Data Publishing Service

To refer to public buckets and files within the [EIDF Data Publishing Service](../datapublishing/service.md), use S3 bucket URIs of form `s3://<project-name>-<bucket-name>`, where the bucket name is prefixed by its project name and delimited by a dash `-`. For example:

```text
s3://eidfNNN-mybucket
s3://eidfNNN-mybucket/my-data-file.csv
```

!!! Note "Projects, buckets and tenancies and the EIDF Data Publishing Service"

    The EIDF Data Publishing Service uses a single tenancy within the EIDF S3 Service for all the buckets for all the projects that publish data using the service. This shared tenancy is distinct from the project-specific tenancies used for project-specific buckets.

    Prefixing the bucket names with the project names allows for different projects to have buckets with the same name within the EIDF Data Publishing Service without ambiguity.

### Public buckets and URLs

To access public project buckets and files for a project via a URL, use a URL of form `https://s3.eidf.ac.uk/<project-name>:<bucket-name>`. For example:

```text
https://s3.eidf.ac.uk/eidfNNN:mybucket
https://s3.eidf.ac.uk/eidfNNN:mybucket/my-data-file.csv
```

To access public buckets and files within the [EIDF Data Publishing Service](../datapublishing/service.md) via a URL, use a URL of form `https://s3.eidf.ac.uk/<project-name>-<bucket-name>`. For example:

```text
https://s3.eidf.ac.uk/eidfNNN-mybucket
https://s3.eidf.ac.uk/eidfNNN-mybucket/my-data-file.csv
```

---

## Read from public buckets

Public buckets, and their files, can be read anonymously i.e., they do not require credentials such as an access key to be provided.

In this section, you'll use a public project bucket that you create.

!!! Tip "Read from public buckets in the EIDF Data Publishing Service"

    Instead of creating your own public bucket, the examples in this section can also be tried using public buckets within the [EIDF Data Publishing Service](../datapublishing/service.md). Remember that, as described in [EIDF S3 bucket URIs and URLs](#eidf-s3-bucket-uris-and-urls), within the EIDF Data Publishing Service URIs and URLs use `<project-name>-<bucket-name>`, not `<project-name>:<bucket-name>`.

### Create a public bucket

To create a public bucket, using the AWS CLI, first recreate the 'mybucket' bucket and add the 'unis.csv' data file to it:

```bash
aws s3 mb s3://mybucket
aws s3 cp unis.csv s3://mybucket/lothian/edinburgh/
```

Now, use the [EIDF S3 Browser](https://portal.eidf.ac.uk/project/s3browser/) to make 'mybucket' public, by following the instructions to [Make a bucket public](./s3browser.md#make-a-bucket-public).

!!! Note "Making a bucket public"

    Here, the EIDF S3 Browser is used to make a bucket public. In [Access policies](#access-policies), you will see how to make a bucket public using the AWS CLI, Python and R.

### Read from public buckets via a browser

To access information about your bucket, enter the URL `https://s3.eidf.ac.uk/<project-name>:mybucket` into your browser.

A new browser tab will open, showing an XML document with information about the bucket and all the files it contains including their metadata.

To download file `lothian/edinburgh/unis.csv`, enter the URL `https://s3.eidf.ac.uk/<project-name>:mybucket/lothian/edinburgh/unis.csv` into your browser.

Depending on both your browser and the file type, the file will either be opened in a new browser tab or downloaded.

### Read from public buckets via 'curl'

A popular Linux command-line utilities for accessing public URLs are is 'curl'. 'curl' can be used as follows to access your bucket.

In the following, replace `<project-name>` with your EIDF project name 'eidfNNN'.

Download information about your bucket contents (`-o` names the downloaded file):

```bash
curl -o mybucket.xml https://s3.eidf.ac.uk/<project-name>:mybucket
```

`mybucket.xml` will be an XML document with information about the bucket and all the files it contains including their metadata.

Download file `lothian/edinburgh/unis.csv` (`-O` uses the remote file name as the downloaded file name):

```bash
curl -O https://s3.eidf.ac.uk/<project-name>:mybucket/lothian/edinburgh/unis.csv
```

`lothian/edinburgh/unis.csv` will be downloaded and saved as `unis.csv`.

### Read from public buckets using the AWS CLI

To read data from our public bucket using the AWS CLI requires the use of an S3 URI of form `s3://<project-name>:mybucket/lothian/edinburgh/unis.csv`. However, as described in [Private buckets in other projects or public buckets](#private-buckets-in-other-projects-or-public-buckets) earlier, S3 URIs of form `s3://<project-name>:<bucket-name>` are strictly invalid and some S3 tools do not allow such S3 URIs to be used. The AWS CLI is one such tool.

You can see what the AWS CLI does when given such a S3 URI, by running the following, replacing `<project-name>` with your EIDF project name 'eidfNNN' (`--no-sign-request` tells the AWS CLI to not use any configured credentials):

```bash
aws s3 cp s3://<project-name>:mybucket/lothian/edinburgh/unis.csv . --no-sign-request
```

The AWS CLI will raise an error as it interprets `<project-name>:<bucket-name>` as a bucket name, having no knowledge of the concept of tenancies:

```text
fatal error: Parameter validation failed:
Invalid bucket name "<project-name>:mybucket": Bucket name must match the regex "^[a-zA-Z0-9.\-_]{1,255}$" or be an ARN matching the regex "^arn:(aws).*:(s3|s3-object-lambda):[a-z\-0-9]*:[0-9]{12}:accesspoint[/:][a-zA-Z0-9\-.]{1,63}$|^arn:(aws).*:s3-outposts:[a-z\-0-9]+:[0-9]{12}:outpost[/:][a-zA-Z0-9\-]{1,63}[/:]accesspoint[/:][a-zA-Z0-9\-]{1,63}$"
```

So, instead, to show a working example, let's use a dataset from the [EIDF Data Publishing Service](../datapublishing/service.md), specifically [High-resolution snapshots of the viscous sublayer from direct numerical simulation of a turbulent boundary layer](https://catalogue.eidf.ac.uk/dataset/eidf198-high-resolution-snapshots-of-the-viscous-sublayer-from-direct-numerical-simulation-of-a-turb), published by the Turbulence Simulation Group of Imperial College London.

List the bucket's files:

```bash
aws s3 ls s3://eidf198-highres-snapshots-sublayer-dns-tbl-re2400 --no-sign-request
```

```text
                           PRE data.zarr/
                           PRE examples/
2025-08-05 13:00:55      18657 LICENSE
2026-04-30 11:09:15       8630 README.md
```

List the bucket's files, now requesting that all files be listed:

```bash
aws s3 ls s3://eidf198-highres-snapshots-sublayer-dns-tbl-re2400 --no-sign-request --recursive
```

```text
2025-08-05 13:00:55      18657 LICENSE
2026-04-30 11:09:15       8630 README.md
2025-07-23 16:16:02  223392171 data.zarr/snapshots/p/c/0/0/0/0
2025-07-23 16:16:02  222867280 data.zarr/snapshots/p/c/0/1/0/0
2025-07-23 16:16:02  221594924 data.zarr/snapshots/p/c/0/10/0/0
2025-07-23 16:16:02  219647578 data.zarr/snapshots/p/c/0/100/0/0
2025-07-23 16:16:02  220032475 data.zarr/snapshots/p/c/0/101/0/0
2025-07-23 16:16:02  219736029 data.zarr/snapshots/p/c/0/102/0/0
2025-07-23 16:16:02  219222531 data.zarr/snapshots/p/c/0/103/0/0
2025-07-23 16:16:03  218831210 data.zarr/snapshots/p/c/0/104/0/0
...
```

Now, list a subset of the files, for example those with prefix `data.zarr/statistics/ww/c/9/`:

```bash
aws s3 ls s3://eidf198-highres-snapshots-sublayer-dns-tbl-re2400/data.zarr/statistics/ww/c/9/ --no-sign-request --recursive
```

```text
2025-07-24 05:02:41   17904692 data.zarr/statistics/ww/c/9/0/0
2025-07-24 05:02:41   17617793 data.zarr/statistics/ww/c/9/1/0
2025-07-24 05:02:41   17099519 data.zarr/statistics/ww/c/9/10/0
2025-07-24 05:02:41   17321505 data.zarr/statistics/ww/c/9/11/0
2025-07-24 05:02:41   17735846 data.zarr/statistics/ww/c/9/12/0
2025-07-24 05:02:41   15056303 data.zarr/statistics/ww/c/9/13/0
2025-07-24 05:02:41   17365366 data.zarr/statistics/ww/c/9/2/0
2025-07-24 05:02:41   17301940 data.zarr/statistics/ww/c/9/3/0
2025-07-24 05:02:41   17208233 data.zarr/statistics/ww/c/9/4/0
2025-07-24 05:02:41   17216908 data.zarr/statistics/ww/c/9/5/0
2025-07-24 05:02:41   17193874 data.zarr/statistics/ww/c/9/6/0
2025-07-24 05:02:41   17100098 data.zarr/statistics/ww/c/9/7/0
2025-07-24 05:02:41   17240933 data.zarr/statistics/ww/c/9/8/0
2025-07-24 05:02:41   17167142 data.zarr/statistics/ww/c/9/9/0
```

Now download those files into a directory:

```bash
mkdir -p stats
aws s3 cp 's3://eidf198-highres-snapshots-sublayer-dns-tbl-re2400/data.zarr/statistics/ww/c/9/' stats --no-sign-request --recursive
```

```text
download: s3://eidf198-highres-snapshots-sublayer-dns-tbl-re2400/data.zarr/statistics/ww/c/9/11/0 to stats/11/0
download: s3://eidf198-highres-snapshots-sublayer-dns-tbl-re2400/data.zarr/statistics/ww/c/9/12/0 to stats/12/0
download: s3://eidf198-highres-snapshots-sublayer-dns-tbl-re2400/data.zarr/statistics/ww/c/9/0/0 to stats/0/0
download: s3://eidf198-highres-snapshots-sublayer-dns-tbl-re2400/data.zarr/statistics/ww/c/9/10/0 to stats/10/0
download: s3://eidf198-highres-snapshots-sublayer-dns-tbl-re2400/data.zarr/statistics/ww/c/9/1/0 to stats/1/0
download: s3://eidf198-highres-snapshots-sublayer-dns-tbl-re2400/data.zarr/statistics/ww/c/9/2/0 to stats/2/0
download: s3://eidf198-highres-snapshots-sublayer-dns-tbl-re2400/data.zarr/statistics/ww/c/9/4/0 to stats/4/0
download: s3://eidf198-highres-snapshots-sublayer-dns-tbl-re2400/data.zarr/statistics/ww/c/9/5/0 to stats/5/0
download: s3://eidf198-highres-snapshots-sublayer-dns-tbl-re2400/data.zarr/statistics/ww/c/9/13/0 to stats/13/0
download: s3://eidf198-highres-snapshots-sublayer-dns-tbl-re2400/data.zarr/statistics/ww/c/9/7/0 to stats/7/0
download: s3://eidf198-highres-snapshots-sublayer-dns-tbl-re2400/data.zarr/statistics/ww/c/9/6/0 to stats/6/0
download: s3://eidf198-highres-snapshots-sublayer-dns-tbl-re2400/data.zarr/statistics/ww/c/9/3/0 to stats/3/0
download: s3://eidf198-highres-snapshots-sublayer-dns-tbl-re2400/data.zarr/statistics/ww/c/9/8/0 to stats/8/0
download: s3://eidf198-highres-snapshots-sublayer-dns-tbl-re2400/data.zarr/statistics/ww/c/9/9/0 to stats/9/0
```

!!! Tip "Specifying a different endpoint URL"

    To specify an S3 endpoint that differs from the default S3 endpoint in your AWS CLI configuration, use the option `--endpoint-url`. For example:

    ```bash
    aws s3 ls s3://eidf198-highres-snapshots-sublayer-dns-tbl-re2400 --no-sign-request  --endpoint-url https://s3.eidf.ac.uk
    ```

### Read from public buckets using Python

TODO: Python

By default, the `boto3` Python library raises an error that bucket names with a colon `:` (as used by the EIDF S3 Service) are invalid.

When accessing a bucket with the project code prefix, switch off the bucket name validation:

```python
import boto3
from botocore.handlers import validate_bucket_name

s3 = boto3.resource('s3', endpoint_url='https://s3.eidf.ac.uk')
s3.meta.client.meta.events.unregister('before-parameter-build.s3', validate_bucket_name)
```

### Read from public buckets using R

TODO: R

When accessing a bucket with the project code prefix, switch off the bucket name validation:

TODO: aws.s3 seemingly allows colon-delimitation. paws allows it to be disabled.

---

## Access buckets in other EIDF projects

If you have been granted access to buckets in other projects, either to private buckets, or write access to public buckets, then you can access these using the same techniques as described for your own bucket and for public buckets.

TODO: Check, edit for consistency with foregoing. How can this be checked? Does the user use their own project's access key and secret?

### Access buckets in other EIDF projects the AWS CLI

To read data from public buckets in other using the AWS CLI requires the use of an S3 URI of form `s3://<project-name>:mybucket/lothian/edinburgh/unis.csv`. However, as described in [Private buckets in other projects or public buckets](#private-buckets-in-other-projects-or-public-buckets) earlier, S3 URIs of form `s3://<project-name>:<bucket-name>` are strictly invalid and some S3 tools do not allow such S3 URIs to be used. The AWS CLI is one such tool.

### Access buckets in other EIDF projects using Python

TODO: Copy blurb from [Read from public buckets using Python](#read-from-public-buckets-using-python).

### Access buckets in other EIDF projects using R

TODO: Copy blurb from [Read from public buckets using R](#read-from-public-buckets-using-r).

---

## Access policies

TODO: Introduce policies.

TODO: What are IAM policies as opposed to other policies?

Buckets owned by an EIDF project are placed in a tenancy in the EIDF S3 Service.
The project code is a prefix on the bucket name, separated by a colon (`:`), for example `eidfXX1:somebucket`.

Note that some S3 client libraries do not accept bucket names in this format.

TODO: Name some of these libraries.

Bucket permissions use IAM (Identity Access Management) policies. You can grant other accounts (within the same project or from other projects) read or write access to your buckets.

### Set policy using the AWS CLI

TODO: Check, edit for consistency with foregoing.

Grant permissions stored in an IAM policy file:

```bash
aws put-bucket-policy --bucket <bucketname> --policy "$(cat bucket-policy.json)"
```

TODO: Julien's pull request has the following. Which is correct?

```bash
aws s3api put-bucket-policy --bucket <bucketname> --policy "$(cat bucket-policy.json)"
```

### Example bucket permission policies

TODO: Check, edit for consistency with foregoing.

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

### Set policy using Python

TODO: Check, edit for consistency with foregoing.

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
      "arn:aws:s3::eidfXX1:{bucket_name}"
      "arn:aws:s3::eidfXX1:{bucket_name}/*"
    ]
  }
 ]
}

policy = bucket.Policy()
policy.put(Policy=json.dumps(bucket_policy))
```

### Set policy using R

TODO: Add comparable code for R.

---
