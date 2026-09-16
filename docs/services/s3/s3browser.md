# Using the EIDF S3 Browser

The [EIDF S3 Service](./index.md) is complemented by the [EIDF S3 Browser](https://portal.eidf.ac.uk/project/s3browser/), part of the EIDF portal. The EIDF S3 Browser is a web-based user interface within the EIDF portal, for creating and managing buckets and uploading, downloading and deleting files.

## Select projects

The 'PROJECTS' area allows you to select one of your EIDF projects for which use of the EIDF S3 Service has been enabled.

To select a project:

* Click on the search field.
* A list of your projects will be shown.
* Click on a project.

Your access keys for the project will be shown in the 'ACCESS KEYS' area.

## Select access keys

The 'ACCESS KEYS' area shows your access keys for your selected project.

To select an access key, click on the access key.

Current buckets within your project to which this access key grants access will be shown in the 'BUCKETS' area.

## Manage buckets

The 'BUCKETS' area shows you the current buckets within your selected project to which your selected access key grants access. Within this area, you can manage buckets for your selected project, using your selected access key.

### Create a bucket

To create a bucket:

* Click **Create**.
* A 'Create New Bucket' dialog will appear.
* Enter a **New Bucket Name**.
* Click **Create**.
* The new bucket will be created.

!!! Important "Bucket names"

    Bucket names must be between 3-63 characters in length, and must contain only lower case letters, numbers, hyphens `-`, or full stops `.`. See the AWS S3 documentation on [General purpose bucket naming rules](https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html).

### View a bucket

To view a bucket, including its URL and files:

* Click the bucket name within the 'BUCKETS' area.
* The bucket URL will be shown. The bucket URL is of form `https://s3.eidf.ac.uk/<project-name>:<bucket-name>`, for example `https://s3.eidf.ac.uk/eidfNNN:mybucket`.
* The files in the bucket will be listed in a table.

To refresh the view of the selected bucket, to reflect any changes to the bucket since the web page was last loaded, click **Refresh**.

### Upload file(s) into a bucket

To upload file(s) into a bucket:

* Click **Upload**.
* An 'Upload Files' area will appear.
* Either, click **Browse Files** to select files, or, drag and drop files into the 'Upload Files' area.
* The files will be queued for upload and listed in a 'QUEUED' list.
* Click **Upload Queued/Failed** to upload the files in the queue.
* Once uploaded, the files will be listed in a 'COMPLETED' list.

To remove files queued for upload:

* Click **Clear All**.
* Any queued files will be removed.
* The 'QUEUED' and 'COMPLETED' lists will be hidden.

### Download a file from a bucket

To download a file from a bucket:

* Click the **Download** button, at the right of the file's row in the files table.
* Depending on both your browser and the file type, the file will either be opened in a new browser tab or downloaded.

### Delete file(s) from a bucket

To delete file(s) from a bucket:

* Select the file(s) from the files table..
* Click the **Delete file** button.
* A 'Permanently delete' dialog will appear.
* Click **OK**.

!!! Warning "Files are permanently deleted"

    If you want to restore a deleted file, then you will have to re-upload it.

### Toggle file (object) versioning

The EIDF S3 Service supports file (object) versioning. By default, versioning is disabled, and only the latest version of files will be kept. If versioning is enabled, then you can preserve, retrieve, and restore every version of every file stored in your bucket.

To toggle versioning:

* Click **Settings** and select **Enable Versioning**.
* A 'Bucket Versioning' dialog will appear.
* Click the checkbox to toggle on and off versioning.
* Click **Save Changes**.

### Configure bucket policies

You can configure bucket policies using the Bucket Policy Editor.

To open the Bucket Policy Editor:

* Click **Settings** and select **Set Bucket Policy**.
* The 'Bucket Policy Editor' will appear.

Within the Bucket Policy Editor you can edit policies via one of:

* A visual editor.
* A JSON editor.

To switch between these editors, click **JSON** when in the visual editor and click **Visual** when in the JSON editor.

To save the policy, click **Save Policy**.

### Make a bucket public

To make a bucket publicly-readable:

* Click **Settings** and select **Make Bucket Public**
* A 'Make bucket publicly readable' dialog will appear.
* Click **OK**.
* A 'Bucket is public' area will appear and the bucket URL will be shown. The bucket URL is of form `https://s3.eidf.ac.uk/<project-name>:<bucket-name>` for example `https://s3.eidf.ac.uk/eidfNNN:mybucket`.

To view information about the bucket:

* Either, visit the bucket URL.
* Or, click the 'upward right pointing arrow button, at the right of the 'Bucket is public' area.
* A new browser tab will open, showing an XML document with information about the bucket and all the files it contains including their metadata.

!!! Warning "Publicly-readable buckets are available to all"

    Making a bucket publicly-readable allows anyone who knows the bucket URL to anonymously read the bucket, and the files within.

!!! Note "Effect on existing bucket policies (for those familiar with policies)"

    Making a bucket public will not overwrite any existing bucket policy you may have defined. Rather, it adds two policy statements to your existing policy, if these have not already been added:

    * Effect: Allow, Principal: *, Action: s3:GetObject, Resource: `arn:aws:s3::<project-name>:<bucket-name>/*`
    * Effect: Allow, Principal: *, Action: s3:ListBucket, Resource: `arn:aws:s3::<project-name>:<bucket-name>/*`

### Make a bucket private

If you have previously made a bucket public following the steps of the previous section, then, to make the bucket private:

* Click **Settings** and select **Set Bucket Policy**.
* The 'Bucket Policy Editor' will appear.
* Either, within the visual editor, click **Remove Rule** to remove the permission rules:
    * Effect: Allow, Principals: Public Access (*), Actions: Read Objects
    * Effect: Allow, Principals: Public Access (*), Actions: List Bucket
* Or, within the JSON editor, edit the `Statement` list to remove the statements:
    * Effect: Allow, Principal: *, Action: s3:GetObject, Resource: `arn:aws:s3::<project-name>:<bucket-name>/*`
    * Effect: Allow, Principal: *, Action: s3:ListBucket, Resource: `arn:aws:s3::<project-name>:<bucket-name>/*`
* Click **Save Policy**.
