# Data ingest crib sheet

**Version 0.3.4**

If you already have an account on Cirrus you should already have an account on the EPCC SAFE. If you do not have a SAFE account you will need to create one there first:

* https://safe.epcc.ed.ac.uk/

If/once you have an account on SAFE go to the EIDF portal and use your SAFE credentials to login.

* https://portal.eidf.ac.uk/

Follow the `Your project applications` link. Press on the `New Application` link and put in an application for us to host your data. Currently, this more heavily orientated to the compute resources but that is what the EIDF has been mainly used for up to now.

When/if your project is approved an organisation will be created on the EIDF data catalogue (an instance of CKAN version 2.10.4 ([user documentation](https://docs.ckan.org/en/2.10/user-guide.html))). You can customise your organisation (at the moment we are mapping an EIDF project to a CKAN organisation).

* https://projects.eidf.ac.uk/ckan

**Note**

* Currently, the above URL is only available on the EdLan network so you will need to be on EdLan or use the UoE VPN.
* Do NOT use the CKAN interface to create Datasets or resources (see below) - the data ingest process will do this for you and associate S3 links with a minimally required Resource metadata subset. The same applies to Datasets. You can provide additional metadata once the records are in CKAN but please do not remove resources or datasets through CKAN. Contact us if would like anything removed.
* The CKAN data catalogue URL will change at some future point to https://catalogue.eidf.ac.uk.

There is some proto documentation about the data ingest process at:

* https://github.com/EPCCed/eidf-docs/tree/data_ingest/docs/dataingest

This will be updated as the process evolves.

Once your project is approved go to the test portal at this link (only available on the EdLan network):

* https://projects.eidf.ac.uk/testportal/ingest/

Select your project. The list of datasets will be empty.

* Create a Dataset. You will need to provide the following minimal bits of information:
  * **Name**: The name for your dataset.
  * **Bucket name**: this entry will automatically be populated from your dataset name to create your S3 bucket name. You can costumise the name for yourself subject to the constraints by editing the link though note if you change the dataset name you will overwrite the S3 bucket name link.
  * **Description**: a description for your dataset.
  * **Link**: a link describing your group/contact information.
  * **Contact email**: a contact email to answer queries about your data set (this is optional).
  

This will be used to create your Dataset on CKAN and a data bucket in S3. You can supplement your Dataset with additional metadata through the CKAN interface.

You will need to:

* Create a user account in the portal and notify mario/amy with the id of the user you created (to add access permissions for the *Managed File Transfer* (MFT), a manual process at the moment).
  * Go into your project on the EIDF portal
  * Scroll down to the project accounts segment
  * Manage -> Create User Account
  * Submit
  * Once you have created the user you can click on their linked username and assign them to a VM if you have created one and give them sudo privileges if appropriate. Note that if you did not apply for a VM when you applied your project you will not be able to do this and will get an error. If you would like to create a VM gest in touch with us.
  * You can use this account to connect to the MFT.

* Do not perform this step until you are notified as currently a manual step has to be done for you to upload your data using the MFT into the folder with the name of the dataset (starts with the project code) 
  * [https://eidf-mft.epcc.ed.ac.uk](https://eidf-mft.epcc.ed.ac.uk/) - you can only access this service within EdLan. Log in with the user account that you created before (remember to set a password).

* This is an optional step: `Configure` the dataset and specify a processing container if required (this will be a docker image available in a public location). 
  * The container is supposed to map your data to an *Analytics Ready Data* (ARD), the format which your end consumers will use.
  * If your data is already ARD you do not need to add any content to this page.

* If your data is already in ARD format, then upload the data files into the folder `data` within the dataset folder. The metadata file `resources.json` must be organised as follows:
  * Data file name (any file names are given relative to the `data` subdirectory)
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

* When you the upload is complete and all files are present press on the `Trigger Ingest` button in the portal.
  * We recommend no more than 100 data resources as CKAN does not present a large number of resources very well to consumers. You can publish as many files as you like as long as they are grouped together as only a few resources. For example, publish one data descriptor or index file as a resource, and a group of data files as another resource.
* Check progress in the list of processing runs on the dataset page (reload the page to refresh the list).

If you feel that the minimal metadata suffices you can add your own fields BUT the above items must be present or you can use the CKAN interface to supplement the metadata. To do so, go to the EIDF data catalogue at:

* https://projects.eidf.ac.uk/ckan/

On the top right you will see a `Log in` link. Click on that then use your `SAFE Login` , then click on `Datasets` and find your own dataset and click on that. If you click on the `Manage` you can edit existing metadata or add to the existing metadata. Please do not try to edit the dataset URL or delete the dataset or things will break. Similarly, if you have uploaded resources you can click on a resource link and then `Manage` and you will be able to update Metadata. You will not be able to edit the S3 links.

