# S3 Service

Some *Safe Havens* may provide you with access to large collections of files via an S3 service. If this applies to your project, your Research Coordinator will provide you with the information you need to connect to the S3 service. This documentation guides you through how to get access to the data from a terminal as well as programmatically via Python and R.

!!! Important

    Unlike the [EIDF S3 service](../services/s3/index.md), Safe Haven S3 services are not a storage solution for users wanting to create or update their own files; all files are **read-only**.

!!! Important

    If you need to modify the files you will need to download them to your project space, but such space is necessarily limited so only download what you need and delete it as soon as no longer needed. Below you will see how to process data without keeping a local copy.

## Access arrangements

To access files you need to know:

* An "endpoint URL" (e.g., for the National Safe Haven, this is `http://nsh-fs02:7070`)
* The "Region" of the service (e.g., for the National Safe Haven this is `us-east-1`)
* A "bucket" name (similar to a folder name)
* An "access key" (similar to a username)
* A "private key" (similar to a password)

All of the above will be supplied to you by your Research Coordinator. S3 access and secret key details are confidential and must never be shared or allowed to be seen by others.

All file accesses are logged.

## How to configure access to the service

The access keys and other details can be configured in several ways. For example:

* directly coding them into your scripts
* set in environment variables
* saved in a configuration file

Many S3 tools will read environment variables so these can be a convenient way to provide the details. A selection of environment variables is as follows:

| Setting        | Environment variable  | Value                               |
|----------------|-----------------------|-------------------------------------|
| Region         | AWS_DEFAULT_REGION    | us-east-1                           |
| Server address | AWS_ENDPOINT_URL      | http://nsh-fs02:7070                |
| (or Endpoint)  | AWS_S3_ENDPOINT       | same (for R aws.s3)                 |
| Access key     | AWS_ACCESS_KEY_ID     | as provided by Research Coordinator |
| Secret key     | AWS_SECRET_ACCESS_KEY | as provided by Research Coordinator |

!!! Important

    If your account has access to Python/R packages via a web proxy, then you need to temporarily disable it whilst using the S3 service. This is shown in the examples below.

## Performance tips

Consume any file directly in memory if possible. Saving to disk is not recommended; it wastes disk space and it will take 3 times longer to do your processing.

If you need to save into a file temporarily (e.g., whilst converting to NIFTI), then save the file into a RAM disk in `/run/user/$(id -u)/`, but delete it straight after use to recover the memory.

## Example using the command-line in the Terminal window

First, install the AWS CLI tool, `aws`, via the [awscli](https://pypi.org/project/awscli/) Python package:

```console
pip install awscli
```

Check that `aws` is now installed:

```console
aws --version
```

The `aws` version should be displayed.

If you get `command not found`, then run `aws` via `~/.local/bin/aws`. Alternatively, add `~/.local/bin` to your `PATH` environment variable:

```console
export PATH="~/.local/bin:$PATH"
```

Now, define environment variables to make sure that your web proxy configuration is not applied to the `aws` command, and that requests to the S3 service go straight to the service. For example:

```console
export NO_PROXY=nsh-fs02
export no_proxy=nsh-fs02
```

You now need to configure `aws` with information about the S3 endpoint, access key and secret. There are three ways that this can be done:

1. Set environment variables. For example:

    ```console
    export AWS_DEFAULT_REGION=us-east-1
    export AWS_ENDPOINT_URL=http://nsh-fs02:7070
    export AWS_S3_ENDPOINT=http://nsh-fs02:7070
    export AWS_ACCESS_KEY_ID=put_your_key_here
    export AWS_SECRET_ACCESS_KEY=put_your_secret_here
    ```

    For more information, see the AWS documentation about [environment variables](https://docs.aws.amazon.com/cli/v1/userguide/cli-configure-envvars.html).

    !!! Note

        Both `AWS_ENDPOINT_URL` and `AWS_S3_ENDPOINT` are defined as the former is a standard Amazon environment variable, but the latter is often used by S3-specific tools.

1. Set `aws` configuration parameters:

    First, interactively provide the access key, secret and region:

    ```console
    aws configure
    ```

    You will be prompted for each in turn. You will also be prompted for an output format, for which you can press return, leaving the value undefined. For example:

    ```console
    AWS Access Key ID [None]: put_your_key_here
    AWS Secret Access Key [None]: put_your_secret_here
    Default region name [None]: us-east-1
    Default output format [None]:
    ```

    Set the endpoint URL. For example:

    ```console
    aws configure set endpoint-url http://nsh-fs02:7070
    ```

    For more information, see the AWS documentation about [configuration variables](https://docs.aws.amazon.com/cli/latest/topic/config-vars.html).

    !!! Note

        `aws configure` writes credentials values to `~/aws/credentials` and endpoint and region information to `~/aws/config`.

1. Manually create AWS credentials and configuration files with these settings. See the AWS documentation about [configuration and credential files](https://docs.aws.amazon.com/cli/v1/userguide/cli-configure-files.html).

Now, you can list the contents of a bucket. For example:

```console
aws s3 ls s3://bucket_name
```

You can download a file. For example:

```console
aws s3 cp s3://bucket_name/filename.dcm copy_of_filename.dcm
```

## Example using Python

### Setup Python

Create a virtual environment and install the Amazon Web Services Software Development Kit for Python, [boto3](https://pypi.org/project/boto3/), into it:

```console
python3 -m virtualenv venv
source venv/bin/activate
pip install boto3
```

Credentials can be passed in as parameters to the functions, as shown below, or as environment variables, as described above. Alternatively, you can set environment variables from within Python using `os.environ`.

### Download an object using boto3

The following Python code downloads an object from a bucket:

```py
import os
import boto3
os.environ["http_proxy"] = ""
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

### Download an object into a pydicom dataset

Install the [pydicom](https://pypi.org/project/pydicom/) package:

```console
pip install pydicom
```

The following Python code downloads an object from a bucket into a pydicom dataset without actually storing a corresponding file on disk:

```py
import io
import os
import boto3
import pydicom
os.environ["http_proxy"] = ""
resource = boto3.resource(
    "s3",
    region_name = "us-east-1",
    endpoint_url = "http://nsh-fs02:7070",
    aws_access_key_id = "put_your_key_here",
    aws_secret_access_key = "put_your_secret_here")
bucket = resource.Bucket("bucket_name")
obj = bucket.Object("326834963428524640226726425259803542053/249177910747091225438117569123869339900/MR.304084489533501143843524990882920225135-an.dcm")
dcm_bytes = io.BytesIO(obj.get()["Body"].read())
ds = pydicom.dcmread(dcm_bytes)
print(ds["StudyInstanceUID"])
```

An example output from the `print` statement might be:

```text
# (0020,000D) Study Instance UID                  UI: 1.2.840.113619.2.411.3.4077533701.216.1476084945.95
```

## Example using R

### Setup R

There are three different packages for R that you could install:

* [aws.s3](https://cran.r-project.org/web/packages/aws.s3/)
* [s3](https://cran.r-project.org/web/packages/s3/)
* [paws](https://cran.r-project.org/web/packages/paws/)

`aws.s3` is recommended and documented here.

Credentials can be passed in as environment variables, as described above. Alternatively, you can set environment variables within your `.Renviron` file or from within R using `Sys.setenv`.

!!! Important

    For the endpoint, `aws.s3` uses environment variable `AWS_S3_ENDPOINT`, not `AWS_ENDPOINT_URL`.

### Download an object using aws.cli

The following R code downloads an object from a bucket:

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

### Download an object into a DICOM dataset

To consume data via a temporary file, see the `aws.s3` function [s3read_using](https://rdrr.io/cran/aws.s3/man/s3read_using.html).

To consume data without using any files, use the R [rawConnection](https://www.rdocumentation.org/packages/base/versions/3.6.2/topics/rawConnection) object to stream data from [get_object](https://rdrr.io/cran/aws.s3/man/get_object.html) function, then stream this in turn into a function that can create a DICOM object (represented in the following by `dicom_processing_function`). For example:

```r
obj = get_object( my_object_path,
                  bucket = my_bucket,
                  base_url = my_endpoint_host,
                  region = "",
                  use_https = FALSE,
                  key = my_access_key,
                  secret = my_secret_key )
con = rawConnection(obj, "r")
dicom_processing_function(con)
```

Examples of such functions are [oro.dicom](https://cran.r-project.org/web/packages/oro.dicom/)'s `parseDICOMHeader()` or [espadon::dicom.browser()](https://rdrr.io/cran/espadon/man/dicom.browser.html).

## Example using a GUI program to view DICOM files

This example uses a customised program that can view and download DICOM files from the S3 service. It is not installed in any Safe Haven but you can import it as a container image.

You will need the following to be provided by your Research Coordinator:

* A CSV file within a bucket which contains a list of `StudyInstanceUID` and `SeriesInstanceUID`.
* A GitHub token to download the container image, ghcr.io/howff/dcmaudit:cpu.

In a terminal window, run the following command to obtain the container image, replacing `TOKEN` with the GitHub token you were given:

```console
ces-pull podman howff TOKEN ghcr.io/howff/dcmaudit:cpu
```

List the Podman container images:

```console
podman images
```

You will see the container image listed. For example:

```console
REPOSITORY                TAG    IMAGE ID      CREATED       SIZE
ghcr.io/howff/dcmaudit    cpu    4f994194efa8  11 days ago   2.67 GB
```

Now, create an `s3` directory in your home directory:

```console
mkdir ~/s3
```

Now you can run the container:

```console
ces-pm-run --opt-file <(echo -v $HOME/.dcmaudit:/root/.dcmaudit -v $HOME/s3:/root/s3 --http-proxy=false) ghcr.io/howff/dcmaudit:cpu
```

The GUI viewer should appear.

!!! Tip

    As running this command can be difficult to type every time you need it, you can create a script:

    ```console
    echo '#!/bin/bash' > ~/dcmaudit.sh
    echo 'ces-pm-run --opt-file <(echo -v $HOME/.dcmaudit:/root/.dcmaudit -v $HOME/s3:/root/s3 --http-proxy=false) ghcr.io/howff/dcmaudit:cpu' >> ~/dcmaudit.sh
    chmod +x ~/dcmaudit.sh
    ```

    Now, you can run the container via:

    ```console
    `~/dcmaudit.sh
    ```

    Alternatively, you can double-click `dcmaudit.sh` from within a file browser.
