# S3 Service

Some *Safe Havens* provide access to large collections of files via a S3 service.
If this applies to your project, your Research Coordinator will provide you with an access key.
This document will guide you through getting access to the data from a terminal as well as programmatically via R and Python.

Unlike the [EIDF S3 service](../services/s3/) this is not a storage solution for users wanting to create their own files;
all files are read-only.

**Important** - if you need to modify the files you will need to download them to your project space, but such space is necessarily limited so only download what you need and delete it as soon as no longer needed. Below you will see how to process data without keeping a local copy.

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

**Important** your project may have access to other resources, such as R and Python package, via a web proxy.
In this case you will need to disable your proxy access whilst accessing S3.
This can be done temporarily by changing an environment variable `http_proxy`; see below.

## How to use the service

The access keys and other details can be configured in several ways:
* directly coding them into your scripts
* set in environment variables
* saved in a configuration file

Many S3 tools will read environment variables so this can be a convenient way to provide the details.

|Environment variable   |Value                 |
|-----------------------|----------------------|
| AWS_DEFAULT_REGION    | us-east-1            |
| AWS_ENDPOINT_URL      | http://nsh-fs02:7070 |
| AWS_S3_ENDPOINT       | same (for R aws.s3)  |
| AWS_ACCESS_KEY_ID     | as provided by RC    |
| AWS_SECRET_ACCESS_KEY | as provided by RC    |
| http_proxy            | no value             |

For example, in your Terminal window (or in your login script such as `.bashrc`)
```
export AWS_DEFAULT_REGION=us-east-1
export AWS_ENDPOINT_URL=http://nsh-fs02:7070
export AWS_S3_ENDPOINT=http://nsh-fs02:7070
export AWS_ACCESS_KEY_ID=put_your_key_here
export AWS_SECRET_ACCESS_KEY=put_your_secret_here
export http_proxy=
```

The above could be added to your login script (e.g. `.bashrc`)
but do not change `http_proxy` there as it will prevent access to R/Python packages.

## Use from the command line

First, install the `aws` command:
```
pip install awscli
```

Check this is installed by running `aws`. This should show the command's help documentation.
If you get `command not found` then run it as `~/.local/bin/aws`
and consider adding `~/.local/bin` to your `PATH` environment variable.

Make sure your proxy configuration is not applied to the aws command by temporarily disabling it:
```
export http_proxy=
```

Now you can list the contents of a bucket and download a file, for example:
```
aws s3  ls  s3://bucket_name
aws s3  cp  s3://bucket_name/filename.dcm  copy_of_filename.dcm
```

At this point it will probably complain that it can't locate your credentials.
There are two ways to supply the information: in environment variables,
or in a configuration file.

Environment variables can be set using the commmands in the previous section.

Credentials can be stored in a configuration file by running
```
aws configure
```
and providing the access key, secret key and region (ignore the output format).
You should also set the endpoint URL, e.g.
```
aws configure set --endpoint-url http://nsh-fs02:7070
```

## Performance tips

* consume the file directly in memory if possible. Saving to disk is not recommended; it wastes disk space and will take 3 times longer to do your processing. See the example code below.
* If you need to save into a file temporarily (e.g. whilst converting to NIFTI) then save into a RAM disk in `/run/user/$(id -u)/` but delete it straight after use to recover then memory.
* If it's too large for RAM then save into a file on the system disk, not in your home directory, in `/tmp/$(id)/` but check the disk has space first (using `df -h /tmp/`) and delete it straight after use to recover the disk space.

## Python

### Setup

First, install the `boto3` package:
```console
python3 -m virtualenv venv
source venv/bin/activate
pip install boto3
```

Ensure your environment variables are set, as described above.
The examples below also set `http_proxy` explicitly.

### Download an object

```py
import boto3
import os
os.environ["AWS_ENDPOINT_URL"] = "http://nsh-fs02:7070"
os.environ["AWS_DEFAULT_REGION"] = "us-east-1"
os.environ["AWS_ACCESS_KEY_ID"] = "dummydata"
os.environ["AWS_SECRET_ACCESS_KEY"] = "put_your_secret_here"
os.environ["http_proxy"] = ""
resource = boto3.resource("s3")
bucket = resource.Bucket("dummydata")
bucket.download_file("326834963428524640226726425259803542053/249177910747091225438117569123869339900/MR.304084489533501143843524990882920225135-an.dcm", "downloaded.dcm")
```

### Load object into pydicom dataset

```console
pip install pydicom
```

This will load the data into a pydicom dataset without actually storing a file on disk:
```py
import boto3
import io
import os
import pydicom

os.environ["http_proxy"] = ""

resource = boto3.resource("s3")
bucket = resource.Bucket("dummydata")
obj = bucket.Object("326834963428524640226726425259803542053/249177910747091225438117569123869339900/MR.304084489533501143843524990882920225135-an.dcm")
dcm_bytes = io.BytesIO(obj.get()["Body"].read())
ds = pydicom.dcmread(dcm_bytes)

print(ds["StudyInstanceUID"])
# (0020,000D) Study Instance UID                  UI: 1.2.840.113619.2.411.3.4077533701.216.1476084945.95
```

## R Usage

There are three different packages for R, you can install `s3` or `aws.s3` or `paws`, but `aws.s3` is recommended and documented here.

You should have the environment variables set, either in your terminal (see above), or in your `.Renviron` file, or explicitly in your R script.

Note! `aws.s3` uses a different name `AWS_S3_ENDPOINT`.

To set environment variables in your `.Renviron` file:
```
AWS_ACCESS_KEY_ID=<my access key id>
AWS_SECRET_ACCESS_KEY=<my secret key>
AWS_ENDPOINT_URL="http://nsh-fs02:7070"
AWS_S3_ENDPOINT="http://nsh-fs02:7070"
AWS_DEFAULT_REGION="us-east-1"
```

To set environment variables in your script:
```
Sys.setenv( AWS_ENDPOINT_URL="http://nsh-fs02:7070" )
Sys.setenv( AWS_S3_ENDPOINT="http://nsh-fs02:7070" )
Sys.setenv( AWS_DEFAULT_REGION="us-east-1" )
```

Note! Only *after* you have installed packages with `install.packages()` you should use
```
Sys.setenv( http_proxy="" )
```

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

Note! You need to have the region set in the environment variable and pass `region=""` to the functions, otherwise you get a `cannot resolve host` error. The `base_url` is just the host and port, no `http://` prefix, and `use_https` is false.

See also the `s3read_using` function to consume data via a temporary file.

To consume data without using any files, use `rawConnection` with the data from `get_object`.
```
obj = get_object( my_object_path, bucket = my_bucket, base_url=my_endpoint_host, region="", use_https=FALSE, key = my_access_key, secret = my_secret_key )
con = rawConnection(obj, "r")
dicom_processing_function(con)
```
