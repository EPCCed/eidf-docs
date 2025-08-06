# S3 Service

There is no general-purpose S3 service within Safe Haven Services, unlike the [EIDF S3 service](../services/s3/).

However there is a S3 service in SHS with the following caveats:
* it is only available to the Scottish National Safe Haven, other tenants by arrangement
* it is a read-only service, as a way of providing access to large collections of files
* it is not a storage solution for users wanting to create their own files

## Access arrangements

Access to buckets is via keys (Access Key and Secret Access Key) provided to the user by the Research Coordinator.

## How to use the service

To access files you need the following information:

* Region is "us-east-1"
* Endpoint URL is "http://nsh-fs02:7070"
* Access key
* Secret access key
* The web proxy variables must be empty

For example when using a command-line or script:

|Environment variable   |Value                 |
|-----------------------|----------------------|
| AWS_DEFAULT_REGION    | us-east-1            |
| AWS_ENDPOINT_URL      | http://nsh-fs02:7070 |
| AWS_ACCESS_KEY_ID     | as provided by RC    |
| AWS_SECRET_ACCESS_KEY | as provided by RC    |
| http_proxy            | no value             |

```
export AWS_DEFAULT_REGION=us-east-1
export AWS_ENDPOINT_URL=http://nsh-fs02:7070
export AWS_ACCESS_KEY_ID=put_your_key_here
export AWS_SECRET_ACCESS_KEY=put_your_secret_here
export http_proxy=
```

## Use from the command line

First, install the `aws` command:
```
pip install aws
```

Check it's installed, run `aws` and it will show some help. If you get `command not found` then run it as `~/.local/bin/aws`.

The general syntax is `aws s3 cp s3://bucket/filename localfilename`, for example:
```
aws s3 cp  s3://extraction_5_CT/123/456/789.dcm  copy_of_789.dcm
```

If this command fails it might be due to a proxy configuration in your environment. To temporarily turn off the proxy in the current window use this first:
```
export http_proxy=
```

At this point it will probably complain that it can't locate your credentials. In fact it requires a bit more information in order to find the bucket: the region, endpoint, access key and secret key:
```
export AWS_DEFAULT_REGION=us-east-1
export AWS_ENDPOINT_URL=http://nsh-fs02:7070
export AWS_ACCESS_KEY_ID=put_your_key_here
export AWS_SECRET_ACCESS_KEY=put_your_secret_here
export http_proxy=
aws s3 cp  s3://extraction_5_CT/123/456/789.dcm  copy_of_789.dcm
```

It should go without saying that the access key details are confidential and must never be shared or allowed to be seen by others. Note that all file accesses are logged.

## Performance tips

* consume the file directly in memory if possible, don't save it to disk. Saving to disk will waste disk space and it will take 3 times longer to do your processing. See the example code below.
* If you need to save into a file temporarily (e.g. whilst converting to NIFTI) then save into a RAM disk in `/run/user/$(id -u)/` but delete it straight after use to recover then memory.
* If it's too large for RAM then save into a file on the system disk, not in your home directory, in `/tmp/$(id)/` but check the disk has space first (using `df -h /tmp/`) and delete it straight after use to recover the disk space.

## Python Usage

### Setup

```console
python3 -m virtualenv venv
. venv/bin/activate
pip install boto3
```

### Download an object

```py
import boto3
resource = boto3.resource("s3")
bucket = resource.Bucket("epcc-test")
bucket.download_file("test.txt", "copy_of_test.txt")
```

### Load object into pydicom dataset

```console
pip install pydicom
```

```py
import boto3
import io
import pydicom

resource = boto3.resource("s3")
bucket = resource.Bucket("Request4_CT")
obj = bucket.Object("1.2.840.113619.2.411.3.4077533701.216.1476084945.95/1.2.840.113619.2.411.3.4077533701.216.1476084945.102/CT.1.2.840.113619.2.411.3.4077533701.216.1476084945.104.99-an.dcm")
dcm_bytes = io.BytesIO(obj.get()["Body"].read())
ds = pydicom.dcmread(dcm_bytes)

print(ds["StudyInstanceUID"])
# (0020,000D) Study Instance UID                  UI: 1.2.840.113619.2.411.3.4077533701.216.1476084945.95
```

## R Usage

There are three different packages for R, you can install `s3` or `aws.s3` or `paws`.

If they use the environment variables shown above
(aws.s3 seems to use slightly different ones, or ignore them)
you may wish to add the details to your `.Renviron` file, e.g.
```
AWS_ACCESS_KEY_ID=<my access key id>
AWS_SECRET_ACCESS_KEY=<my secret key>
AWS_ENDPOINT_URL=http://nsh-fs02:7070
AWS_DEFAULT_REGION=us-east-1
```

The `paws` package is very comprehensive but slow to install and difficult to use.

The simpler `aws.s3` package can be used like this:
```
library(aws.s3)
my_bucket <- "the bucket name"
my_access_key <- "an access key
my_secret_key <- "abigsecretkey"
my_region <- "us-east-1"
my_endpoint_host <- "nsh-fs02:7070"
my_object_path <- "studyid/seriesid/instanceid-an.dcm"
save_object( my_object_path, file = "output.dcm", bucket = my_bucket, base_url=my_endpoint_host, region="", use_https=FALSE, key = my_access_key, secret = my_secret_key )
```
