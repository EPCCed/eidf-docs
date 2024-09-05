# Data ingest crib sheet

**Version 0.4.6**

This document is evolving fairly quickly so please keep an eye on the version number to see if it has changed since you last looked at it.

## Applying for a project

If you do not already have an EPCC SAFE account you will need to create one before proceeding:

* https://safe.epcc.ed.ac.uk/

Once you have a SAFE account, go to the EIDF portal and use your SAFE credentials to login.

* https://portal.eidf.ac.uk/

First, apply for an EIDF project. If you already have an existing EIDF project from which you want to do the data ingest/publishing you do not need to apply for a new project. Instead put in a query to *eidf@epcc.ed.ac.uk* saying that you would like to publish your data from your existing project and give your project identifier, e.g. eidfNNN. Also, be aware that the data publishing is free subject to your data being under a given threshold - however, associated services have a [cost](https://edinburgh-international-data-facility.ed.ac.uk/access) so if you add these a charge will be imposed. If you do not have an existing EIDF project, in the EIDF portal:

* Press on the `Your project applications` link. 
* Press on the `New Application` link and put in an application for us to host your data. 

Currently, this process is orientated towards the EIDF compute resources which is where the focus has mainly been up to now. Be sure to describe the dataset(s) that you wish to ingest. Submit your application. Your application will be reviewed and you will be notified if your project is approved or rejected - someone may be in touch to clarify points in your application.

## Customising your entry in the EIDF Data Catalogue

When/if your project is approved an organisation will be created on the EIDF data catalogue (an instance of CKAN version 2.10.4 ([user documentation](https://docs.ckan.org/en/2.10/user-guide.html))). You can customise your organisation information (at the moment we are mapping an EIDF project to a CKAN organisation).

* https://catalogue.eidf.ac.uk/

Login using your SAFE credentials - there is a "Log in" on the top, towards the right.

**Note**

* **Do NOT use the CKAN interface to create Datasets** (see below) - the data ingest process creates these for you and associates S3 links with your data. You can provide additional metadata once the Dataset records are in CKAN. Please do not add/remove resources or datasets through the CKAN interface either. Contact us if would like anything removed.

There is additional early documentation about the data ingest process at:

* https://github.com/EPCCed/eidf-docs/tree/data_ingest/docs/dataingest

This will be updated as the process evolves but for now this version is the canonical version so use this version.

## Creating a dataset

Once your project is approved go to the test portal at this link (only available on the EdLan network):

* https://projects.eidf.ac.uk/testportal/ingest/

Select the project which you want to use to ingest data. The list of `Ingest Datasets` will be empty unless you have already created Datasets.

* Create a Dataset by pressing on the `New` button. You will need to provide the following minimal bits of information:
  * **Name**: The name for your dataset.
  * **S3 Bucket name**: this entry will automatically be populated from your dataset name to create your S3 bucket name. You can customise the name for yourself subject to the constraints specified below the text box by editing the link directly. Note though if you change the dataset name you will overwrite the S3 bucket name link if you have customised it. Your project id at the start you will not be able to change.
  * **Number of buckets**: you may want to distribute your data over a number of S3 buckets if your dataset is big.
  * **Description**: a description of your dataset.
  * **Link**: a link describing your group/contact information.
  * **Contact email**: a contact email to answer queries about your data set (this is optional).

![The form to create a dataset](imgs/CreateDataset.png)

Once you are happy with the content press on the `Create` button. This will be used to create your Dataset within your organisation (we are mapping EIDF projects to CKAN organisations) on the EIDF Data Catalogue and the data buckets in S3.

You should now be able to click on a link to your dataset to see a copy of the information that you provided, when the Dataset was created, a link to the catalogue entry you can go and peruse and a link to the S3 buckets where your data will live. You can supplement your Dataset in the EIDF catalogue with additional metadata through the CKAN interface once you login using your SAFE credentials.

## Uploading your data

Once this is done please contact us and we will provide credentials for uploading your data to EIDF S3. You need an AWS client to upload data.

### Data upload

We provide an S3 acccount with write permissions to the dataset buckets.
As a project manager or Principal Investigator (PI), you can view the access credentials for your S3 account on the project details page. You can also grant other members of your project permission to view these access credentials.

You can use the [`aws` command line client](https://aws.amazon.com/cli/) to upload data to the bucket. For instance,

```bash
$ aws s3 cp ./jobs s3://mario-test1 --recursive --exclude "*" \
--include "AI*" --endpoint-url https://s3.eidf.ac.uk
```

Will recursively copy files in the `jobs` directory to the `s3://mario-test1` bucket excluding all files other than those that start with AI with the explicit end point.  You may want to create credentials  `~/.aws/credentials`:

```ini
[default]
aws_access_key_id=<key>
aws_secret_access_key=<secret>
endpoint_url=https://s3.eidf.ac.uk
```

The `endpoint_url` means that you do not have to explicitly specify the URL every time or you can use an environment variable:

```bash
$ export AWS_ENDPOINT_URL=https://s3.eidf.ac.uk
```

You can list the configuration settings - only make sure the `access_key` and the `secret_key`:

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

or if you want more information for a particular command you can do:

```bash
aws s3 ls help
```

you will get an overview of the commands available.

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

Alternatively, there are many graphical clients that act as a file browser for S3, for example [Cyberduck](https://cyberduck.io).

### Metadata format

Metadata for resources in your dataset are added via forms in the EIDF data catalogue.

Make sure you're logged in to the [EIDF Data Catalogue](https://catalogue.eidf.ac.uk). Open the page of your dataset and click on "Manage" at the top right. Open the tab "Resources" and press the button "+ Add new resource". Now you can fill in the form and describe your data as you wish. Some entries are required and these are marked with a red \*:
* Name
* Access URL: This is a link to a file in S3 or a set of files with a common prefix.
* Description
* Unique Identifier
* Licence

A link to a data file in EIDF S3 looks like this:
```
https://s3.eidf.ac.uk/eidfXXX-my-dataset/mydatafile.csv
```
where `eidfXXX-my-dataset` is the dataset bucket name and `mydatafile.csv` is the name of the uploaded file.

You can also link to a set of files with a common prefix:
```
https://s3.eidf.ac.uk/eidfXXX-my-dataset?prefix=January2024/
```

This lists all the file names that start with `January2024/`. This way you can collect files together in "folders" and link to a collection rather than individual files.

### Preprocessing uploaded data (optional)

If your data is not already in an *Analytics Ready Data* (ARD) format, the format that your end consumers will use then you can provide a link to a published docker image that will map your data to be ARD. If your data is already supplied in an ARD format you can ignore this step. To do this press on the `Configure` button and provide:

* A public  fully qualified link to your pre-processing container image that produces ARD from the raw data. It must be available in a public registry, e.g. Dockerhub `NAMESPACE/IMAGE_NAME:VERSION` or GitHub Container Registry `ghcr.io/NAMESPACE/IMAGE_NAME:VERSION`. Go to the [main documentation](https://github.com/marioa/eidf-docs/blob/data_ingest/docs/dataingest/PreprocessingContainer.md) to have more information on the container expectations. Note that the container also needs to also create the metadata (more information on the requirements below).
* A description of the process.

### Start ingest

When you the upload is complete and all files are present, open the dataset page in the EIDF Portal and press the `Trigger Ingest` button.

* We recommend no more than 100 data resources as CKAN does not present a large number of resources very well to consumers. You can publish as many files as you like as long as they are grouped together as only a few resources. For example, publish one data descriptor or index file as a resource, and a group of data files as another resource.

* Check progress in the list of processing runs on the dataset page (reload the page to refresh the list or turn on auto-refresh).

If you feel that the minimal metadata does not suffice for you dataset you can add your own fields. To do so, go to the EIDF data catalogue at:

* https://catalogue.eidf.ac.uk/

Log in with your SAFE credentials, then click on `Datasets` and find your own dataset and click on that. If you click on `Manage` you can edit existing metadata or add to the existing metadata. Similarly, if you have uploaded resources you can click on a resource link and then `Manage` and you will be able to update Metadata. You will not be able to edit the S3 links.

## Testing your s3 links and downloading

Analytics-ready datasets in EIDF S3 are public and can be viewed in a browser at the links displayed in the catalogue. With an S3 client of your choice you can list and download objects as with any S3 client, and there are no credentials required.

For example, using the [AWS CLI](https://aws.amazon.com/cli/), the following command lists the objects and prefixes in the bucket `<BUCKET_NAME>`: 

```bash
aws s3 ls s3://<BUCKET_NAME> --no-sign-request --endpoint-url https://s3.eidf.ac.uk
```

or using `curl` you can get the bucket listing using:

```bash
curl -X GET "https://s3.eidf.ac.uk/eidf..."
```

You will need the quotes or may have to explicitly escape certain characters if present, e.g. `?` -> `\?`, etc.

### Downloading data, an example using curl

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

### Inspecting data, an example using Python

```python
import boto3
import pandas
import matplotlib

from botocore import UNSIGNED
from botocore.config import Config
from botocore.session import Session

# Get the data
session = Session()
config = Config(signature_version=UNSIGNED)
s3 = boto3.client(service_name='s3',config=config,endpoint_url = 'https://s3.eidf.ac.uk/')
response = s3.get_object(Bucket="eidf125-cc-main-2019-35-augmented-index", Key="cluster.idx")

# Describe the data
df = pandas.read_csv(response["Body"], sep='\t', header=None)
df.describe(include="all")
print(df[0].head())

# Plot the data
df[2].hist(bins=100)
```

