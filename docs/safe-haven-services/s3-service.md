# S3 Service

Some *Safe Havens* provide access to large collections of files via a S3 service.
If this applies to your project, your Research Coordinator will provide you with an access key.
This document will guide you through getting access to the data from a terminal as well as programmatically via R and Python.

Unlike the [EIDF S3 service](../services/s3/) this is not a storage solution for users wanting to create their own files;
all files are read-only.

> [!NOTE]
> If you need to modify the files you will need to download them to your project space, but such space is necessarily limited so only download what you need and delete it as soon as no longer needed. Below you will see how to process data without keeping a local copy.

## Access arrangements

To access files you need to know:
* An "endpoint URL" (for the NSH this is `http://nsh-fs02:7070`)
* The "Region" of the service (for the NSH this is `us-east-1`)
* A "bucket" name (similar to a folder name)
* An "access key" (similar to a username)
* A "private key" (similar to a password)

All of the above will be supplied to you by your Research Coordinator.
It should go without saying that the access key details are confidential and must never be shared or allowed to be seen by others.
Note that all file accesses are logged.

## How to use the service

The access keys and other details can be configured in several ways:
* directly coding them into your scripts
* set in environment variables
* saved in a configuration file

Many S3 tools will read environment variables so this can be a convenient way to provide the details.

|Setting         |Environment variable   |Value                 |
|----------------|-----------------------|----------------------|
| Region         | AWS_DEFAULT_REGION    | us-east-1            |
| Server address | AWS_ENDPOINT_URL      | http://nsh-fs02:7070 |
| (or Endpoint)  | AWS_S3_ENDPOINT       | same (for R aws.s3)  |
| Access key     | AWS_ACCESS_KEY_ID     | as provided by RC    |
| Secret key     | AWS_SECRET_ACCESS_KEY | as provided by RC    |


> [!NOTE]
> If your account has access to R/Python packages via a web proxy then you
> need to temporarily disable it whilst using the S3 service. This is shown
> in the examples below.

## Performance tips

* consume the file directly in memory if possible. Saving to disk is not recommended; it wastes disk space and will take 3 times longer to do your processing. See the example code below.
* If you need to save into a file temporarily (e.g. whilst converting to NIFTI) then save into a RAM disk in `/run/user/$(id -u)/` but delete it straight after use to recover then memory.
* If it's too large for RAM then save into a file on the system disk, not in your home directory, in `/tmp/$(id)/` but check the disk has space first (using `df -h /tmp/`) and delete it straight after use to recover the disk space.

## Example using the command-line in the Terminal window

First, install the `aws` command:
```
pip install awscli
```

Check this is installed by running `aws`. This should show the command's help documentation.
If you get `command not found` then run it as `~/.local/bin/aws`
and consider adding `~/.local/bin` to your `PATH` environment variable.

Make sure your proxy configuration is not applied to the aws command:
```
export NO_PROXY=nsh-fs02
export no_proxy=nsh-fs02
```

Now you can list the contents of a bucket and download a file, for example:
```
aws s3  ls  s3://bucket_name
aws s3  cp  s3://bucket_name/filename.dcm  copy_of_filename.dcm
```

At this point it will complain that it can't locate your credentials.
There are two ways to supply the information: in environment variables, or
in a configuration file.

Environment variables can be set:
```
export AWS_DEFAULT_REGION=us-east-1
export AWS_ENDPOINT_URL=http://nsh-fs02:7070
export AWS_S3_ENDPOINT=http://nsh-fs02:7070
export AWS_ACCESS_KEY_ID=put_your_key_here
export AWS_SECRET_ACCESS_KEY=put_your_secret_here
```
(See the AWS documentation about [env vars](https://docs.aws.amazon.com/cli/v1/userguide/cli-configure-envvars.html)
and [credentials](https://docs.aws.amazon.com/cli/latest/topic/config-vars.html#credentials).)

Credentials can be stored in a configuration file
manually (see the [AWS docs](https://docs.aws.amazon.com/cli/v1/userguide/cli-configure-files.html)),
or with a command (see the [AWS docs](https://docs.aws.amazon.com/cli/latest/reference/configure/set.html)):
```
aws configure
```
and providing the access key, secret key and region (ignore the output format).
You should also set the endpoint URL, e.g.
```
aws configure set --endpoint-url http://nsh-fs02:7070
```

The above commands for copying files can now be used.


## Example using Python

### Setup

First, install the `boto3` package:
```console
python3 -m virtualenv venv
source venv/bin/activate
pip install boto3
```

Credentials can be passed in as parameters to the functions, as shown below,
or as environment variables. The latter can be set externally (see the examples
above) or in your script using `os.environ`.

### Download an object using boto3

```py
import os
import boto3
os.environ["http_proxy"] = ""
resource = boto3.resource("s3",
    region_name = "us-east-1",
    endpoint_url = "http://nsh-fs02:7070",
    aws_access_key_id = "dummydata",
    aws_secret_access_key = "put_your_secret_here")
bucket = resource.Bucket("dummydata")
bucket.download_file("326834963428524640226726425259803542053/249177910747091225438117569123869339900/MR.304084489533501143843524990882920225135-an.dcm", "downloaded.dcm")
```

### Load object into pydicom dataset

```console
pip install pydicom
```

This will load the data into a pydicom dataset without actually storing a file on disk:
```py
import io
import os
import boto3
import pydicom
os.environ["http_proxy"] = ""
resource = boto3.resource("s3",
    region_name = "us-east-1",
    endpoint_url = "http://nsh-fs02:7070",
    aws_access_key_id = "dummydata",
    aws_secret_access_key = "put_your_secret_here")
bucket = resource.Bucket("dummydata")
obj = bucket.Object("326834963428524640226726425259803542053/249177910747091225438117569123869339900/MR.304084489533501143843524990882920225135-an.dcm")
dcm_bytes = io.BytesIO(obj.get()["Body"].read())
ds = pydicom.dcmread(dcm_bytes)
print(ds["StudyInstanceUID"])
# (0020,000D) Study Instance UID                  UI: 1.2.840.113619.2.411.3.4077533701.216.1476084945.95
```

## Example using R

There are three different packages for R, you can install `s3` or `aws.s3` or `paws`, but `aws.s3` is recommended and documented here.

You should have the environment variables set, either in your terminal (see above), or in your `.Renviron` file, or explicitly in your R script using `Sys.setenv`.

> [!NOTE]
> For the endpoint, `aws.s3` uses a different name `AWS_S3_ENDPOINT`.

> [!NOTE]
> Only *after* you have installed packages with `install.packages()` you should use `Sys.setenv( http_proxy="" )`

An example R script to download a file from S3:
```
library(aws.s3)
my_bucket <- "dummydata"
my_access_key <- "dummydata"
my_secret_key <- "abigsecretkey"
my_region <- "us-east-1"
my_endpoint <- "http://nsh-fs02:7070"
my_endpoint_host <- "nsh-fs02:7070"
my_object_path <- "326834963428524640226726425259803542053/249177910747091225438117569123869339900/MR.304084489533501143843524990882920225135-an.dcm"
Sys.setenv( AWS_ENDPOINT_URL="http://nsh-fs02:7070" )
Sys.setenv( AWS_S3_ENDPOINT="http://nsh-fs02:7070" )
Sys.setenv( AWS_DEFAULT_REGION="us-east-1" )
Sys.setenv( http_proxy="" )
save_object( my_object_path, file = "downloaded.dcm", bucket = my_bucket, base_url=my_endpoint_host, region="", use_https=FALSE, key = my_access_key, secret = my_secret_key )
```

> [!NOTE]
> You need to have the region set in the environment variable and pass `region=""` to the functions,
> otherwise you get a `cannot resolve host` error.
> The `base_url` is just the host and port, no `http://` prefix, and `use_https` is false.

### Advanced R usage

To consume data via a temporary file see the function [s3read_using](https://rdrr.io/cran/aws.s3/man/s3read_using.html).

To consume data without using any files, use [rawConnection](https://www.rdocumentation.org/packages/base/versions/3.6.2/topics/rawConnection) with the data from [get_object](https://www.rdocumentation.org/packages/aws.s3/versions/0.3.21/topics/get_object).
```
obj = get_object( my_object_path, bucket = my_bucket, base_url=my_endpoint_host, region="", use_https=FALSE, key = my_access_key, secret = my_secret_key )
con = rawConnection(obj, "r")
dicom_processing_function(con)
```

Examples of such functions are `oro.dicom::parseDICOMHeader()` and `espadon::dicom.browser()`
