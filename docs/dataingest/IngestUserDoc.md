# Data Ingest

The _Edinburgh International Data Facility_ (EIDF) can host your data for the lifetime of the EIDF service. This documentation describes the data ingestion process.

## Overview

The EIDF provides two complementary services: **Archive** and **Analytics-Ready Data** (ARD). The ARD hosted by the EIDF are publicly available to EIDF data service cloud users. ARD are indexed and searchable on the EIDF Metadata Catalogue.

In the following, a dataset is a collection of data resources (or files), together with a description and other information (what is known as metadata).

To set up automated ingestion:

1. The data provider creates an empty dataset.
1. An ingest workflow is set up for the dataset.

Automated ingestion of each batch of data then proceeds as follows:
1. The data provider uploads a batch of data files (_raw data_) and corresponding _metadata_ to the "landing zone" for this dataset, accessed via the managed file transfer (MFT) service.
1. If archiving is required, copies of the raw data files are deposited in the EIDF archive.
1. The raw data may be processed and transformed to ARD format, if requested by the data provider.
1. The analytics ready data is published on the ARD service.
1. The uploaded metadata is updated with download links and is published in the EIDF metadata catalogue.
1. A report is created and dispatched to the data provider.

## Application

Apply for a data ingest project to publish analytics ready data in the EIDF. A data ingest project may contain many datasets.

1. If you do not already have an EPCC SAFE account you will need to create one.
1. Once you have an EPCC SAFE account use this to login to the EIDF portal.
1. Apply for a project: https://portal.eidf.ac.uk/proposal/new
   * Fill in a project application and submit it for review.
   * If your application is successful, a project will be created for you.

## Preparation of ingest

### Project accounts and datasets

Create accounts for data providers to have access to the MFT service.

### CKAN organisation

The EIDF data catalogue is a CKAN instance.

We map an EIDF project to a CKAN organisation.
Your CKAN organisation will be created if your application is successful. The title of your organisation is the title of your project and you may also provide a description.

### Ingest dataset

An EIDF dataset consists of descriptive metadata to allow researchers to find your dataset information via a free text search, and a set of resources which link to the actual data files held within EIDF. Each dataset resource itself consists of searchable metadata, and a link to the data file location within the EIDF ARD service.

You will need to create an ingest dataset for each dataset that you wish to publish or archive and provide the necessary metadata, by filling in a form in the EIDF Portal.

1. Choose create dataset.
1. Provide the top level metadata to create your Dataset:
    * Title
    * Description
    * Contact Point

   There is also a number of optional fields that you may wish to provide to make it easier for your data to be discovered.
1. (Optional) Indicate whether archival is required.
1. (Optional) Add the fully qualified name of your pre-processing container image that produces ARD from the raw data. It must be available in a public registry, e.g. Dockerhub `NAMESPACE/IMAGE_NAME:VERSION` or Github `ghcr.io/NAMESPACE/IMAGE_NAME:VERSION`. See below for instructions on how to create the container image.

We will set up the ingest process and you will be provided with a link to upload the data.

### Pre-processing container

Unless the data that you are providing is already in ARD format (the format your end data consumer will access), you will need to provide a public link to a container image that transforms your raw data to ARD (you will still need to produce resource metadata).

See the page [Pre-processing Container](./PreprocessingContainer.md) for guidance on how to create the preprocessing container image.

### Data granularity and metadata format

**Data**

A data file can be any format, for example CSV, JSON, or even in a raw binary format. We recommend limiting the number of resources within a dataset to less than 100 to keep the data catalogue entries manageable. For example, when publishing timeseries data, a file resource may be a week's worth of data and a dataset contains 52 resources, i.e. 1 year.

Data files can be organised in a directory tree.

**Metadata**

You need to provide metadata for your data in JSON format. For each data file the required metadata fields listed below must be provided, and optionally other fields may be populated.
* **Name**: The name of your resource. 
* **Identifier**: An identifier that is relevant to your domain (this does not need to be unique within the dataset).
* **Description**: Additional description of your data.
* **Licence**: Licence under which you make this data available.
* **Resource format**: e.g. JSON, CSV, or a domain specific binary format.

Providing detailed metadata will make it easier for researchers to discover and use your data. Additional metadata may be provided in the metadata file, if available for your data. Please see the following page for more information about optional metadata and detailed examples: [Resource Metdata](https://git.ecdf.ed.ac.uk/wcdi/eidf_metadata/-/blob/main/ResourceMetaDataUserDoc.md).

## Data upload

The data ingestion process starts with a data upload.

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

Users of the data science cloud (DSC) can view and search the ARD metadata in the EIDF data catalogue.
Each organisation has a number of datasets.
The dataset lists the data resources (files) available and provides a download link.

## Data access

Users of the DSC have anonymous access to public ARD datasets in EIDF S3, using the download link from the EIDF data catalogue.

Access permissions for non-public ARD datasets may be managed by granting access to a set of projects using the SAFE. It is implemented using S3 policies on buckets.
