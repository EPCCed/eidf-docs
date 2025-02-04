# Data Publishing

## Uploading your data

Once you have created your S3 bucket. We will provide you with credentials for uploading your data to the EIDF S3 bucket. You will need an AWS client to upload your data.

### Data upload

We provide an S3 account with write permissions to the dataset buckets.
As a project manager or Principal Investigator (PI), you can view the access credentials for your S3 account on the project details page. You can also grant other members of your project permission to be able to view these access credentials.

You can use the [`aws` command line client](https://aws.amazon.com/cli/) to upload your data to the bucket. For instance,

```bash
$ aws s3 cp ./jobs s3://mario-test1 --recursive --exclude "*" \
            --include "AI*" --endpoint-url https://s3.eidf.ac.uk
```

The `$` indicates the bash shell prompt. The command will recursively copy the contents of the `jobs` directory to the `s3://mario-test1` bucket excluding all files other than those that start with AI. The explicit end point is also specified.  The backslash at the end of the first line is just a line continuation token (no spaces after the backslash) purely to make the content easier to see.

You will want to create a credentials  `~/.aws/credentials` (the `~` signifies your home directory and the `.aws` is a directory) file:

```ini
[default]
aws_access_key_id=<key>
aws_secret_access_key=<secret>
endpoint_url=https://s3.eidf.ac.uk
```

The `endpoint_url` means that you do not have to explicitly specify the URL every time after the `--endpoint-url` flag, you can just miss that ifnormation out. You will also have to provide your access key id (`<key>`) and your access key (`<secret>`) - we will provide you with these.

You can use an environment variable to specify the AWS end point instead:

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

You can list the configuration settings to check that you have set these up correctly - make sure the `access_key` and the `secret_key` have been added:

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

Remember to replace the `s3://mario-test1/` with your own S3 bucket name.

If you do:

```bash
$ aws s3 help
```

you will get an overview of the s3 commands available or if you want more information for a particular command you can do:

```bash
$ aws s3 ls help
```

Alternatively, there are many graphical clients that act as a file browser for S3, for example [Cyberduck](https://cyberduck.io) or if you want to view programming language [Ceph S3 API](https://docs.ceph.com/en/latest/radosgw/s3/) interfaces (Ceph is the underlying platform used).

### Downloading URLs for files in S3

Each file in S3 can be directly accessed and downloaded via a URL. If you open this URL in a browser it will download the file or display the contents, depending on the format (and the configuration of your browser).

So from an S3 link:

```text
s3://eidfXXX-my-dataset/mydatafile.csv
```

You can construct an https link to the data file for the EIDF S3 that would look like:

```
https://s3.eidf.ac.uk/eidfXXX-my-dataset/mydatafile.csv
```

You can also link to a set of files that have a common prefix:

```
https://s3.eidf.ac.uk/eidfXXX-my-dataset?prefix=January2024/
```

This lists all the file names that start with `January2024/`. This way you can collect files together in "folders" and link to a collection rather than individual files.

Or if you wanted to download someone else's S3 bucket, say the s3 bucket:

```text
s3://eidf158-walkingtraveltimemaps/
```

Then you can use the aws client to download the whole dataset to your current directory:

```bash
$ aws s3 cp --recursive s3://eidf158-walkingtraveltimemaps/ . \
            --endpoint-url https://s3.eidf.ac.uk \
            --no-sign-request
```

Note that if you want to to view data that are in other people's buckets you need to add the `--no-sign-request` flag.

### Testing your s3 links and downloading

Analytics-ready datasets in EIDF S3 are public and can be viewed in a browser at the links displayed in the catalogue. With an S3 client of your choice you can list and download objects as with any S3 client, and there are no credentials required.

For example, using the [AWS CLI](https://aws.amazon.com/cli/), the following command lists the objects and prefixes in the bucket `<BUCKET_NAME>`, for instance: 

```bash
aws s3 ls s3://eidf158-walkingtraveltimemaps --no-sign-request \
          --endpoint-url https://s3.eidf.ac.uk
```

or using `curl` you can get the bucket listing using:

```bash
curl -X GET "https://s3.eidf.ac.uk/eidf158-walkingtraveltimemaps"
```

You will need the quotes or may have to explicitly escape certain characters if present, e.g. `?` -> `\?`, etc.

### More on using aws

If you want to look at someone else's bucket contents you need to add the `--no-sign-request` otherwise it will not work. For instance, if you want to use the content that Henry Thompson has [published](https://catalogue.eidf.ac.uk/dataset/eidf125-common-crawl-url-index-for-august-2019-with-last-modified-timestamps/resource/7e485f0c-d480-43e9-8cb7-9540a3d3dbc9) in the data catalogue we have the access point:

* https://s3.eidf.ac.uk/eidf125-cc-main-2019-35-augmented-index?prefix=idx

From this we get the end-point https://s3.eidf.ac.uk and the bucket s3://eidf125-cc-main-2019-35-augmented-index so to list the contents we can do:

```bash
$ aws s3 ls --recursive s3://eidf125-cc-main-2019-35-augmented-index \
            --endpoint https://s3.eidf.ac.uk --no-sign-request
```

or you can add the prefix explicitly:

```bash
$aws s3 ls s3://eidf125-cc-main-2019-35-augmented-index/idx/ \
        --endpoint https://s3.eidf.ac.uk --no-sign-request
```

Note that if you do not terminate with the forward slash you will not get the listing of the contents.

### Downloading data with curl

As a concrete example if we look at an existing dataset in the EIDF Data Catalogue:

* https://catalogue.eidf.ac.uk/dataset/eidf125-common-crawl-url-index-for-august-2019-with-last-modified-timestamps

Looking at the `Index shards directory` resource record we get the access/download URL:

* https://s3.eidf.ac.uk/eidf125-cc-main-2019-35-augmented-index?prefix=idx

The presence of a `?` means we need to use quotes for the URL or escape the question mark when running within a shell. We can make the output human-readable using `xmllint`, part of the libxml2-utils package, and reduce the amount of output using `head` to just the first record but if you don't have these utilities you can look at the output produced by clicking on the link above in the EIDF data catalogue. The `-s` argument tells `curl` not to produce additional content. Running this we get:

```bash
curl -sX GET "https://s3.eidf.ac.uk/eidf125-cc-main-2019-35-augmented-index?prefix=idx"\
| xmllint --format - |head -18

<?xml version="1.0" encoding="UTF-8"?>
<ListBucketResult xmlns="http://s3.amazonaws.com/doc/2006-03-01/">
  <Name>eidf125-cc-main-2019-35-augmented-index</Name>
  <Prefix>idx</Prefix>
  <MaxKeys>1000</MaxKeys>
  <IsTruncated>false</IsTruncated>
  <Contents>
    <Key>idx/cdx-00000.gz</Key>
    <LastModified>2024-04-30T15:41:18.976Z</LastModified>
    <ETag>"9df7647798430d78db71afd3ae8c51b5-112"</ETag>
    <Size>938001370</Size>
    <StorageClass>STANDARD</StorageClass>
    <Owner>
      <ID>eidfarch_ard</ID>
      <DisplayName>EIDF Archival ARD owner</DisplayName>
    </Owner>
    <Type>Normal</Type>
  </Contents>
```

So, if we want to download the first file we look in the `Contents` section and the key is `idx/cdx-00000.gz`. In this instance downloading the first file would be done using:

```bash
curl -sX GET \
https://s3.eidf.ac.uk/eidf125-cc-main-2019-35-augmented-index/idx/cdx-00000.gz \
-o cdx-00000.gz
```

The `-o` will write the output to a named file. You can use the above pattern to download content. In this instance this will be `cdx-00000.gz` and you can then start playing with the data.

