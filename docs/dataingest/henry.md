# Crib sheet for Henry Thompson

**Version 0.2**

If you already have an account on Cirrus you should already have an account on the EPCC SAFE. If you do not have a SAFE account you will need to go on that first:

* https://safe.epcc.ed.ac.uk/

If/once you have an account on SAFE go to the EIDF portal and use your SAFE credentials to login.

* https://portal.eidf.ac.uk/

Follow the "Your project applications" link. Press on the "New Application" link and put in an application for us to host your data. Currently, this more heavily orientated to the compute resources but that is what the EIDF has been mainly used for up to now.

When/if your project is approved an organisation will be created on the EIDF data catalogue (an instance of CKAN version 2.10.4 ([user documentation](https://docs.ckan.org/en/2.10/user-guide.html))). You can customise your organisation (at the moment we are mapping an EIDF project to a CKAN organisation).

* https://projects.eidf.ac.uk/ckan

**Note**

* Currently the above URL is only available on the EdLan network so you will need to be on EdLan or use the VPN.
* Do NOT use the CKAN interface to create Datasets or resources (see below) - the data ingest process will do this for you and associate S3 links with a minimally required Resource metadata subset. The same applies to Datasets. You can provide additional metadata once the records are in CKAN but please do not remove resources or datasets through CKAN and contact us if would like anything removed.
* This URL will change on (or after) 18th April to https://catalogue.eidf.ac.uk.

There is some proto documentation at:

* https://github.com/EPCCed/eidf-docs/tree/data_ingest/docs/dataingest

This will need to be updated as the process evolves.

Once your project is approved go to the test portal at this link (only available on the EdLan network):

* https://projects.eidf.ac.uk/testportal/ingest/

Select your project. The list of datasets will be empty.

* Create a Dataset. You will need to provide the following minimal bits of information:
  * **Name**: The name for your dataset
  * **Description**: a description for your dataset
  * **Link**: a link describing your group/contact information
  * **Contact email**: a contact email to answer queries about your data set (this is optional)
  

This will be used to create your Dataset on CKAN and a data bucket in S3. You can supplement your Dataset with additional metadata through the CKAN interface.

You will need to:

* Create a user account in the portal and notify mario/amy with the id of the user you created (to add access permissions for the *Managed File Transfer* (MFT), a manual process at the moment).
  * Go into your project on the EIDF portal
  * Scroll down to the project accounts segment
  * Manage -> Create User Account
  * Submit
  * Once you have created the user you can click on their linked username and assign them to a VM if you have created one and give them sudo privileges if appropriate.
  * You can later also use this to connect to the MFT.

* Do not perform this step until notified as currently a manual step has to be done for you to upload your data using the MFT into the folder with the name of the dataset (starts with the project code) 
  * [https://eidf-mft.epcc.ed.ac.uk](https://eidf-mft.epcc.ed.ac.uk/) - you can only access this service within EdLan.

* Configure the dataset and specify a processing container if required (this will be a docker image published in a public location). 
  * The container is supposed to map your data to an *Analytics Ready Data* (ARD), the format which your end consumers will use.
  * If your data is already ARD you do not need to add any content in this page.

* Trigger the ingest in the portal.
* Check progress in the list of processing runs on the dataset page (reload the page to refresh the list).

Upload the data files into the folder `data` within the dataset folder. The metadata file `resources.json` must be organised as follows:
* Data file name (relative to `data`)
  * `name`: resource name in the catalogue
  * `resource:identifier`: an identifier for the resource
  * `resource:description`: description of the resource
  * `resource:format`: format description, for example `json` or `csv`
  * `resource:licence`: licence under which the resource is published

Through the CKAN interface you should be able to supplement the:

* Dataset metadata
* Resource metadata
