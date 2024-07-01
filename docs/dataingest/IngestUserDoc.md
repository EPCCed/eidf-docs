# Data Ingest

The _Edinburgh International Data Facility_ (EIDF) can host your **Analytics-Ready Data** (ARD) for the lifetime of the EIDF service. ARD is data that is ready, i.e. the data has been cleaned, has the correct data elements, is in a suitable format, has suitable metadata to make your data findable, etc., for your end users to use out of the box. This documentation describes the data ingest process.

## Overview

The metadata of the ARD hosted by the EIDF is indexed and searchable on the EIDF Data Catalogue, a CKAN instance - see [using CKAN as the EIDF Data Catalogue](eidf-ckan.md) if you want to know more, which makes your data discoverable and available, through S3 links, to your community as well as other world-wide interested parties. The ARD is also made available to EIDF *Data Science Cloud* users. 

In the following text, a dataset is a collection of data resources (e.g. files), together with a description and other information about the data (i.e. metadata).

To set up an automated data ingestion:

1. You need to create an empty dataset in the EIDF portal.
1. An ingest workflow is set up for the dataset.

Automated ingestion of each batch of data then proceeds as follows:
1. You upload a batch of data files (_raw data_ or ARD) and the corresponding _metadata_ to a "landing zone" for this dataset, accessed via the *Managed File Transfer* (MFT) service.
1. The raw data may be processed and transformed to ARD format, if requested by the data provider.
1. The analytics ready data is published on the ARD service.
1. The uploaded metadata is updated with download links and is published in the EIDF Data Catalogue.
1. A report is created and dispatched back to you.

## Application

In order to ingest data into the EIDF, you need to apply for a data ingest project to publish analytics ready data in the EIDF. A data ingest project may contain one or more datasets. Please follow the workflow below:

1. If you do not already have an [EPCC SAFE account](https://safe.epcc.ed.ac.uk/) you will need to create one.
1. Once you have an EPCC SAFE account use this to login to the [EIDF portal](https://portal.eidf.ac.uk/).
1. Apply for a project: https://portal.eidf.ac.uk/proposal/new
   * Fill in a project application and submit it for review.
   * If your application is successful, a project will be created for you.

## Preparation of ingest

### Project accounts and datasets

Create accounts for data providers to have access to the MFT service.

### CKAN organisation

The [EIDF Data Catalogue](https://catalogue.eidf.ac.uk/) is a CKAN instance.

We map an EIDF project to a CKAN organisation.

A CKAN organisation will be created for your EIDF project if your application is successful. The title of your organisation will be the same as the title of your EIDF project. You may also provide a description. You will be given editing rights to your organisation so you can customise your CKAN organisations look and feel and later edit/add metadata but please do not use the CKAN interface to create or delete datasets.

### Ingest dataset

An EIDF dataset consists of descriptive metadata to allow researchers to find your dataset information via a free text search, and a set of resources which link to the actual data files held within EIDF. Each dataset resource itself consists of searchable metadata, and a link to the data file location within the EIDF service.

You will need to create an ingest dataset for each dataset that you wish to publish or archive and provide the necessary metadata, by filling in a form in the EIDF Portal.

1. Select the project which you want to use to ingest data. The list of `Ingest Datasets` will be empty unless you have already created Datasets.
1. Create a Dataset by pressing on the `New` button. You will need to provide the following minimal bits of information:
    * **Name**: The name for your dataset.
    * **Bucket name**: this entry will automatically be populated from your dataset name to create your S3 bucket name. You can costumise the name for yourself subject to the constraints specified below the text box by editing the link directly. Note though if you change the dataset name you will overwrite the S3 bucket name link if you have customised it.
    * **Description**: a description for your dataset.
   * **Link**: a link describing your group/contact information.
   * **Contact email**: a contact email to answer queries about your data set (this is optional).
   

Once you are happy with the content press on the `Create` button. This will be used to create your Dataset within your organisation (we are mapping EIDF projects to CKAN organisations) on the EIDF Data Catalogue and a data bucket in S3. You can supplement your Dataset with additional metadata through the CKAN interface once you login using your SAFE credentials.

### Pre-processing container

Unless the data that you are providing is already in ARD format, you will need to provide a public link to a container image that transforms your raw data to ARD (you will still need to produce resource metadata, metadata about the downloadable elements in your dataset).

Press the button "Configure" on the dataset page and provide the fully qualified name of your pre-processing container image that produces ARD from the raw data. It must be available in a public registry, e.g. Dockerhub `NAMESPACE/IMAGE_NAME:VERSION` or GitHub Container Registry `ghcr.io/NAMESPACE/IMAGE_NAME:VERSION`. You can also provide a description.

See the page [Pre-processing Container](./PreprocessingContainer.md) for guidance on how to create the preprocessing container image.

### Data granularity and metadata format

**Data**

A data file can be in any format, for example CSV, JSON, or even in a raw binary format (such as raw data or it could be a zip file of CSV or JSON files). We recommend limiting the number of resources within a dataset to less than 100 to keep the data catalogue entries manageable. For example, when publishing timeseries data, a file resource may be a week's worth of data and a dataset contains 52 resources, i.e. 1 year.

It is also possible to add an entire directory tree as a single metadata resource.

**Metadata**

You need to provide metadata for your data in JSON format. For each data file the required metadata fields listed below must be provided, and optionally other fields may be populated.
* **Name**: The name of your resource. 
* **Identifier**: An identifier that is relevant to your domain (this does not need to be unique within the dataset).
* **Description**: Additional description of your data.
* **Licence**: Licence under which you make this data available.
* **Resource format**: e.g. JSON, CSV, or a domain specific binary format.

Providing detailed metadata will make it easier for researchers to discover and use your data. Additional metadata may be provided in the metadata file, if available for your data. Please see the following page for more information about optional metadata and detailed examples: [Resource Metdata](https://git.ecdf.ed.ac.uk/wcdi/eidf_metadata/-/blob/main/ResourceMetaDataUserDoc.md).

## Data upload

The data ingestion process starts with a data upload. Please do the following:

1. Open the upload link that was provided for your dataset.
1. Log in with the upload account that was created in your ingest project.
1. Upload the data files and a corresponding metadata file.

A metadata file must be uploaded along with the data and named `metadata.json` unless you provide a custom pre-processing container (see above).
If metadata for a file is missing, the ingest will fail.

When the upload is complete, launch the ingest process.

If the processing fails a report will be created.

If the processing is successful:
* the data will be available in the ARD service
* the metadata will be available in the EIDF data catalogue
* the raw data will be removed from the MFT service
* the raw data will be archived if you asked for this service
* a report with the metadata and data locations will be provided to you

## EIDF Data Catalogue

Users of the EIDF Data Science Cloud (DSC) can view and search the ARD metadata in the EIDF Data Catalogue.
Each organisation has a number of datasets.
Each dataset lists the data resources (files) available and provides a download link.

## Data access

Users of the DSC have anonymous access to public ARD datasets in EIDF S3, using the download link from the EIDF data catalogue.

Access permissions for non-public ARD datasets may be managed by granting access to a set of projects using the SAFE. It is implemented using S3 policies on buckets. The EIDF supports UK government policy positions on Open Data, and encourages its users to provide access to data sets under the most open (unencumbered) licences legally and ethically possible. 

