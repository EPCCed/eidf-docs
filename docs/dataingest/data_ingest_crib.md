# Data ingest crib sheet

**Version 0.3.11**

This document is evolving relatively quickly so keep your eye on the version number to see if it has changed since you last looked at it.

## Applying for a project

If you do not already have an EPCC SAFE account you will need to create one before proceeding:

* https://safe.epcc.ed.ac.uk/

Once you have a SAFE account, go to the EIDF portal and use your SAFE credentials to login.

* https://portal.eidf.ac.uk/

First apply for an EIDF project. 

* Press on the `Your project applications` link. 
* Press on the `New Application` link and put in an application for us to host your data. 

Currently, this process is orientated towards the EIDF compute resources which is where the focus has mainly been up to now. Be sure to describe the dataset(s) that you wish to ingest. Submit your application. Your application will be reviewed and you will be notified if your project is approved or rejected - someone may be in touch to clarify points in your application.

## Customising your entry in the EIDF Data Catalogue

When/if your project is approved an organisation will be created on the EIDF data catalogue (an instance of CKAN version 2.10.4 ([user documentation](https://docs.ckan.org/en/2.10/user-guide.html))). You can customise your organisation information (at the moment we are mapping an EIDF project to a CKAN organisation).

* https://catalogue.eidf.ac.uk/

Login using your SAFE credentials - there is a "Log in" on the top, towards the right.

**Note**

* Do NOT use the CKAN interface to create Datasets or resources (see below) - the data ingest process creates these for you and associates S3 links with your data. You can provide additional metadata once the Dataset/Resource records are in CKAN. Please do not add/remove resources or datasets through the CKAN interface. Contact us if would like anything removed.

There is some additional early documentation about the data ingest process at:

* https://github.com/EPCCed/eidf-docs/tree/data_ingest/docs/dataingest

This will be updated as the process evolves.

## Uploading your data

Once your project is approved go to the test portal at this link (only available on the EdLan network):

* https://projects.eidf.ac.uk/testportal/ingest/

Select the project which you want to use to ingest data. The list of `Ingest Datasets` will be empty unless you have already created Datasets.

* Create a Dataset by pressing on the `New` button. You will need to provide the following minimal bits of information:
  * **Name**: The name for your dataset.
  * **Bucket name**: this entry will automatically be populated from your dataset name to create your S3 bucket name. You can customise the name for yourself subject to the constraints specified below the text box by editing the link directly. Note though if you change the dataset name you will overwrite the S3 bucket name link if you have customised it.
  * **Description**: a description for your dataset.
  * **Link**: a link describing your group/contact information.
  * **Contact email**: a contact email to answer queries about your data set (this is optional).
  

Once you are happy with the content press on the `Create` button. This will be used to create your Dataset within your organisation (we are mapping EIDF projects to CKAN organisations) on the EIDF Data Catalogue and a data bucket in S3.

You should now be able to click on a link to your dataset to see a copy of the information that you provided, when the Dataset was created, a link to the catalogue entry you can go and peruse and a link to the S3 bucket where your data will live. You can supplement your Dataset in the EIDF catalogue with additional metadata through the CKAN interface once you login using your SAFE credentials.

To upload your data you will need to:

* Create a user account in the portal.
  * Go into your project on the EIDF portal
  * Scroll down to the project accounts segment
  * Manage -> Create User Account
  * Submit

Once you have created the user you can click on their linked username and give them access to the *Managed File Transfer* (MFT) service by checking the box labelled "eidf-MFT". After setting a password you can use this account to login to the MFT.

### Preprocessing uploaded data (optional)

If your data is not already in an *Analytics Ready Data* (ARD) format, the format which your end consumers will use then you can provide a link to a published docker image that will map your data to be ARD. If your data is already supplied in an ARD format you can ignore this step. To do this press on the `Configure` button and provide:

* A public  fully qualified link to your pre-processing container image that produces ARD from the raw data. It must be available in a public registry, e.g. Dockerhub `NAMESPACE/IMAGE_NAME:VERSION` or GitHub Container Registry `ghcr.io/NAMESPACE/IMAGE_NAME:VERSION`. Go to the [main documentation](https://github.com/marioa/eidf-docs/blob/data_ingest/docs/dataingest/PreprocessingContainer.md) to have more information on the container expectations. Note that the container also needs to also create the meadata (more information on the requirements below).
* A description of the process.

### Data format

The metadata file, `resources.json`, must be organised as follows:
* Data file name (any file names are given relative to the files that would be found in the `data` subdirectory, see below for examples)
  * `name`: resource name in the EIDF data catalogue.
  * `resource:identifier`: an identifier for the resource.
  * `resource:description`: a description of the resource.
  * `resource:format`: format description, for example `json` or `csv`.
  * `resource:licence`: licence under which the resource is published.

For example, for the data files:

* `dataset-name/data/file1.csv`
* `dataset-name/data/dir1/file2.csv`

Content of the metadata file named `dataset-name/resources.json` (above the `data` directory), the path of the files is relative to the `data` directory:
```json
{
  "file1.csv": {
    "name": "My Name",
    "resource:identifier": "my-name",
    "resource:description": "A very important data file",
    "resource:format": "CSV",
    "resource:licence": "CC-BY"
  },
  "dir1/file2.csv": {
    "name": "Another File",
    "resource:identifier": "another-file",
    "resource:description": "More details about the file",
    "resource:format": "CSV",
    "resource:licence": "CC-BY"
  }
}
```

It is also possible to add an entire directory tree as a single metadata resource, for example:
```json
{
  "dir/": {
    "name": "Many files",
    "resource:identifier": "many-files",
    "resource:description": "A collection of data files in one data resource",
    "resource:format": "CSV",
    "resource:licence": "CC-BY"
  }
}
```
This will create one resource in the catalogue with a link to all files in the S3 ARD bucket with the prefix `dir`, you do not have to use the forward slash to indicate a directory.

### Upload

Once you have your `resources.json` and your data ready, you now have a choice of how to do the upload. You can upload via the web interface at [https://eidf-mft.epcc.ed.ac.uk](https://eidf-mft.epcc.ed.ac.uk/) or you can use sftp. Note that if your data is hosted on Cirrus or ARCHER2, you will have to use sftp.

To upload via the web interface:

* Login to your account at [https://eidf-mft.epcc.ed.ac.uk](https://eidf-mft.epcc.ed.ac.uk/). You can only access this service within EdLan. Log in with the user account that you created before (remember to set a password).
* Navigate to the directory for your dataset `eidfnnn-your-data-set-name` and place your metadata and data there

To upload using `sftp`:

* From a shell running on the machine where your data is hosted, start an `sftp` session:

   ```bash
   sftp USERNAME@eidf-mft.epcc.ed.ac.uk
   USERNAME@eidf-mft.epcc.ed.ac.uk's password: xxxxx
   Connected to USERNAME@eidf-mft.epcc.ed.ac.uk.
   sftp> dir
   [eidfnnn-your-data-set-name]
   sftp> cd eidfnnn-your-data-set-name
   sftp> put resources.json
   ...
   sftp> [further lcd, put, mkdir, mput commands]
   ```

### Start ingest

When you the upload is complete and all files are present, open the dataset page in the EIDF Portal and press the `Trigger Ingest` button.

* We recommend no more than 100 data resources as CKAN does not present a large number of resources very well to consumers. You can publish as many files as you like as long as they are grouped together as only a few resources. For example, publish one data descriptor or index file as a resource, and a group of data files as another resource.

* Check progress in the list of processing runs on the dataset page (reload the page to refresh the list or turn on auto-refresh).

If you feel that the minimal metadata does not suffice for you dataset you can add your own fields. To do so, go to the EIDF data catalogue at:

* https://catalgoue.eidf.ac.uk/

Log in with your SAFE credentials, then click on `Datasets` and find your own dataset and click on that. If you click on the `Manage` you can edit existing metadata or add to the existing metadata. Similarly, if you have uploaded resources you can click on a resource link and then `Manage` and you will be able to update Metadata. You will not be able to edit the S3 links.

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

The presence of a `?` means we need to use quotes for the URL or escape the question mark when running within a shell. We can make the output human readable using `xmllint`, part of the libxml2-utils package, and reduce the amount of output using `head` to just the first record but if you don't have these utilities you can look at the output produced by clicking on the link above in the EIDF data catalogue. The `-s` argument tells `curl` not to produce additional content. Running this we get:

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

