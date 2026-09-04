# Using the EIDF S3 Browser

The [EIDF S3 service](./index.md) is complemented by the [EIDF S3 Browser](https://portal.eidf.ac.uk/project/s3browser/), part of the EIDF portal. The EIDF S3 Browser is a web-based user interface within the EIDF portal, for creating and configuring buckets and uploading, downloading and deleting files.

## 'PROJECTS' area

The 'PROJECTS' area allows you to select one of your EIDF projects which have an S3 service enabled.

To select a project, select a project from the search field.

The associated access keys are displayed in the 'ACCESS KEYS' area.

TODO: Is this right? Is it project-specific?

## 'ACCESS KEYS' area

The 'ACCESS KEYS' area shows your user names and access keys for your selected project.

TODO: Is this right? Is it project-specific?

To select an access key, click on an access key within the list shown.

The buckets to which this access key is allowed access will be shown in the 'BUCKETS' area

## 'BUCKETS' area

The 'BUCKETS' area allows you to manage buckets for your selected project.

To create a bucket:

* Click **Create**.
* A 'Create New Bucket' dialog will appear.
* Enter a **New Bucket Name**.
* Click **Create**.
* The new bucket will be created.

To view a bucket, click the bucket name within the 'BUCKETS' area.

The files in the bucket will be listed.

To refresh the view of the bucket, to reflect any changes to the bucket since the web page was last loaded, click **Refresh**.

To upload a file, click **Upload**, then, either click **Browse Fiales** to select files, or drag and drop files into the browser.

To download a file, select the file from the table, then click the download button.

To delete one or more files, select the file(s) from the table, then click the **Delete file** button.

To configure a bucket, click **Settings**, then:

* Click **Enable Versioning**, to toggle object versioning. If enabled, then all object versions are retained.
* Click **Set Bucket Policy**, to configure bucket policies.
* Click **Make Bucket Public**, to make the bucket publicly readable. This will allow **anyone anywhere** who knows the endpoint URL and bucket name to access the bucket without authentication.
