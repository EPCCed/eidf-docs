# Data ingest crib sheet

**Version 0.3.6**

If you do not already have an EPCC SAFE account you will need to create one first:

* https://safe.epcc.ed.ac.uk/

Once you have an account on SAFE go to the EIDF portal and use your SAFE credentials to login.

* https://portal.eidf.ac.uk/

First apply for an EIDF project. 

* Press on the `Your project applications` link. 
* Press on the `New Application` link and put in an application for us to host your data. 

Currently, this is orientated towards the compute resources as that is what the EIDF has been mainly used for up to now. Be sure to describe the dataset(s) that you wish to ingest. Submit your application. Your application will be reviewed and you will be notified if your project is approved or rejected - someone may be in touch to clarify points in your application.

When/if your project is approved an organisation will be created on the EIDF data catalogue (an instance of CKAN version 2.10.4 ([user documentation](https://docs.ckan.org/en/2.10/user-guide.html))). You can customise your organisation information (at the moment we are mapping an EIDF project to a CKAN organisation).

* https://projects.eidf.ac.uk/ckan

Login using your SAFE credentials - there is a "Log in" on the top, towards the right.

**Note**

* Currently, the above URL is only available on the EdLan network so you will need to be on EdLan or use the UoE VPN.
* Do NOT use the CKAN interface to create Datasets or resources (see below) - the data ingest process creates these for you and associates S3 links with your data. You can provide additional metadata once the Dataset/Resource records are in CKAN. Please do not add/remove resources or datasets through the CKAN interface. Contact us if would like anything removed.
* The CKAN data catalogue URL will change at some future point to https://catalogue.eidf.ac.uk.

There is some additional proto documentation about the data ingest process at:

* https://github.com/EPCCed/eidf-docs/tree/data_ingest/docs/dataingest

This will be updated as the process evolves.

Once your project is approved go to the test portal at this link (only available on the EdLan network):

* https://projects.eidf.ac.uk/testportal/ingest/

Select the project which you want to use to ingest data. The list of `Ingest Datasets` will be empty unless you have already created Datasets.

* Create a Dataset by pressing on the `New` button. You will need to provide the following minimal bits of information:
  * **Name**: The name for your dataset.
  * **Bucket name**: this entry will automatically be populated from your dataset name to create your S3 bucket name. You can costumise the name for yourself subject to the constraints specified below the text box by editing the link directly. Note though if you change the dataset name you will overwrite the S3 bucket name link if you have customised it.
  * **Description**: a description for your dataset.
  * **Link**: a link describing your group/contact information.
  * **Contact email**: a contact email to answer queries about your data set (this is optional).
  

Once you are happy with the content press on the `Create` button. This will be used to create your Dataset within your organisation (we are mapping EIDF projects to CKAN organisations) on the EIDF Data Catalogue and a data bucket in S3. You can supplement your Dataset with additional metadata through the CKAN interface once you login.

To upload your data you will need to:

* Create a user account in the portal and notify us with the id of the user you created (to add access permissions for the *Managed File Transfer* (MFT), a manual process at the moment).
  * Go into your project on the EIDF portal
  * Scroll down to the project accounts segment
  * Manage -> Create User Account
  * Submit

Once you have created the user you can click on their linked username and assign them to a VM if you have created one and give them sudo privileges if appropriate. Note that if you did not apply for a VM when you submitted your project application you will not be able to do this and will get an error. If you would like to create a VM gest in touch with us. You can use this account to login to the MFT. You should now be able to click on a link to your dataset name to see a copy of the information that you provided, when the Dataset was created, a link to the catalogue entry you can go and peruse and a link to the S3 bucket where your data will live. Once you have uploaded the data you can `Trigger [the] Ingest`.

However, you will not be able to upload your data/metadata until you are notified. Currently a manual step is involved which has to be done for you to upload your data and metadata using the MFT into the folder with the name you used for your dataset (which will start with the project code). The metadata is important otherwise the data ingest process will fail. 

If your data is not already in an *Analytics Ready Data* (ARD) format, the format which your end consumers will use then you can provide a link to a published docker image that will map your data to be ARD. If your data is already supplied in an ARD format you can ignore this step. To do this press on the `Configure` button and provide:

* A public link to a container that maps your data to ARD (go to the main documentation to have more information on the container expectations). Note that the container also needs to also create the meadata (more information on the requirements below).
* A description of the process.

Once you have been notfied to upload the ARD and metadata, or the data your container will act on, go to:

* [https://eidf-mft.epcc.ed.ac.uk](https://eidf-mft.epcc.ed.ac.uk/) - you can only access this service within EdLan. Log in with the user account that you created before (remember to set a password).

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

Once you have your `resources.json` and your data ready, you now have a choice of how to do the upload. You can upload via the web interface at https://eidf-mft.epcc.ed.ac.uk or you can use sftp. Note that if your data is hosted on Cirrus or ARCHER2, you will have to use sftp.

To upload via the web interface

* Login to your account at https://eidf-mft.epcc.ed.ac.uk/
* Navigate to the directory for your dataset and place your data there

To upload using sftp:

* From a shell running on the machine where your data is hosted, start an sftp session

   ```
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

When you the upload is complete and all files are present, open the dataset page in the EIDF Portal and press the `Trigger Ingest` button.

* We recommend no more than 100 data resources as CKAN does not present a large number of resources very well to consumers. You can publish as many files as you like as long as they are grouped together as only a few resources. For example, publish one data descriptor or index file as a resource, and a group of data files as another resource.

* Check progress in the list of processing runs on the dataset page (reload the page to refresh the list or turn on auto-refresh).

If you feel that the minimal metadata suffices you can add your own fields BUT the above items must be present or you can use the CKAN interface to supplement the metadata. To do so, go to the EIDF data catalogue at:

* https://projects.eidf.ac.uk/ckan/

On the top right you will see a `Log in` link. Click on that then use your `SAFE Login` , then click on `Datasets` and find your own dataset and click on that. If you click on the `Manage` you can edit existing metadata or add to the existing metadata. Please do not try to edit the dataset URL or delete the dataset or things will break. Similarly, if you have uploaded resources you can click on a resource link and then `Manage` and you will be able to update Metadata. You will not be able to edit the S3 links.

Analytics-ready datasets in EIDF S3 are public and can be viewed in a browser at the links displayed in the catalogue. With an S3 client of your choice you can list and download objects as with any S3 service, and there are no credentials required.

For example, using the AWS CLI, the following command lists the objects and prefixes in the bucket `<BUCKET_NAME>`: 

```
aws s3 ls s3://<BUCKET_NAME> --no-sign-request --endpoint-url https://s3.eidf.ac.uk
```
