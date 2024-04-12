# Crib sheet for Henry Thompson

**Version 0.1**

If you already have an account on cirrus you should already have an account on the EPCC SAFE. If you do not have a SAFE account you will need to go on that first:

* https://safe.epcc.ed.ac.uk/

If/once you have an account on SAFE go to the EIDF portal and use your SAFE credentials to login.

* https://portal.eidf.ac.uk/

Follow the "Your project applications" link. Press on the "New Application" link and put in an application for us to host your data. Currently this more heavily orientated to the compute resources but that is what the EIDF has been mainly used for up to now.

When/if your project is approved an organisation will be created on the EIDF data catalogue (an instance of CKAN version 2.10.4 ([user documentation](https://docs.ckan.org/en/2.10/user-guide.html))). You can costumise your organisation (at the moment we are mapping an EIDF project to a CKAN organisation).

* https://projects.eidf.ac.uk/ckan

**Note**

* Currently the above URL is only available on the EdLan network so you will need to be on EdLan or use the VPN.
* Do NOT use the CKAN interface to create Datasets or resources (see below) - the data ingest process will do this for you and associate S3 links with a minimally required Resource metadata subset. The same applies to Datasets. You can provide additional metadata once the records are in CKAN but please do not remove resources or datasets through CKAN and contact us if would like anything removed.
* This URL will change on (or after) 18th April to https://catalogue.eidf.ac.uk.

There is some proto documentation at:

* https://github.com/EPCCed/eidf-docs/tree/data_ingest/docs/dataingest

This will need to be updated as the process evolves.

Once your project is approved you will have to go back to EIDF portal (this may have to be a test version of the portal). Use the portal to:

* Create a Dataset. You will need to provide the following minimal bits of information:
  * **Name**: The name for your dataset
  * **Description**: a description for your dataset
  * **Link**: a link describing your group/contact information
  * **Contact email**: a contact email to answer queries about your data set (this is optional)
  

This will be used to create your Dataset on CKAN and a data bucket in S3. You can supplement your Dataset with additional metadata through the CKAN interface.

You will need to:

* Create a user account in the portal and notify me (to add access permissions for the MFT, manual at the moment).
* Upload the data to the MFT into the folder with the UUID of the dataset (not great to use the UUID but should be obvious if there's only one).
* Configure the dataset and specify a processing container if required (this will be a docker image published in a public location).
* Trigger the ingest in the portal.
* Check progress in the list of processing runs on the dataset page (reload the page to refresh the list).

Through the CKAN interface you should be able to supplement the:

*  Dataset metadata
* Resource metadata
