# Publishing Data

## Creating a dataset

Once your project is approved go to the test portal at this link (only available on the EdLan network):

* [https://projects.eidf.ac.uk/testportal/ingest/](https://projects.eidf.ac.uk/testportal/ingest/)

Select the project which you want to use to ingest data. The list of `Ingest Datasets` will be empty unless you have already created Datasets.

* Create a Dataset by pressing on the `New` button. You will need to provide the following minimal bits of information:

  * **Name**: The name for your dataset.
  * **S3 Bucket name**: this entry will automatically be populated from your dataset name to create your S3 bucket name. You can customise the name for yourself subject to the constraints specified below the text box by editing the link directly. Note though if you change the dataset name you will overwrite the S3 bucket name link if you have customised it. Your project id at the start you will not be able to change.
  * **Number of buckets**: you may want to distribute your data over a number of S3 buckets if your dataset is big.
  * **Description**: a description of your dataset.
  * **Link**: a link describing your group/contact information.
  * **Contact email**: a contact email to answer queries about your data set (this is optional).
  * **License**: the license under which you will distribute your data.

  As in the form example below.

![](imgs/CreateDataset.png)

Once you are happy with the content press on the `Create` button. This will be used to create an S3 bucket to which you will migrate your data. 

You can create a Dataset within your organisation (we are mapping EIDF projects to CKAN organisations) on the EIDF Data Catalogue and a data buckets in S3.

You should now be able to click on a link to your dataset to see a copy of the information that you provided. When the the S3 bucket has been created and you have added the data, you can add the S3 link to the catalogue entry. You can supplement your Dataset entry in the EIDF catalogue with additional metadata once you have logged into the data catalogue using your SAFE credentials.

### Metadata format

Metadata for resources in your dataset are added directly through the EIDF Data Catalogue.

Make sure you're logged in to the [EIDF Data Catalogue](https://catalogue.eidf.ac.uk). Open the page of your dataset and click on "Manage" at the top right. Open the "Resources"  tab and press the button "+ Add new resource". Now you can fill in the form and describe your data as you wish. Some entries that are required and these are marked with a red \* in the EIDF data catalogue:

* **Name**: a descriptive name for your dataset.
* **Access URL**: this is a link to a file in S3 or a set of files with a common prefix, that you uploaded as explained above.
* **Description**: a human readable description of your data set.
* **Resource format**: the type of data included in your resource.
* **Unique Identifier**
* **Licence**: the licence under which you are releasing your data.
