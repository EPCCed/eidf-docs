# Using the EIDF S3 Browser

The [EIDF S3 Browser](https://portal.eidf.ac.uk/project/s3browser/) is part of the [EIDF S3 Service](./index.md) and offers a web-based user interface within the EIDF Portal for creating and managing buckets and uploading, downloading and deleting files.

## Select projects

The 'PROJECTS' section allows you to select one of your EIDF projects for which use of the EIDF S3 Service has been enabled.

To select a project:

1. Click on the search field.
1. A list of your projects will be shown.
1. Click on a project.

Your selected project's S3 access keys will be shown in the 'ACCESS KEYS' section.

## Select S3 accounts and access keys

The 'ACCESS KEYS' section shows your selected project's S3 access keys, grouped by their S3 account names.

!!! Note "S3 access keys and permissions"

    You will only see those access keys, and associated S3 accounts, which your project lead has granted you permission to view.

    If you are a project lead, then you will see all the access keys, and associated S3 accounts, for your project.

To select an access key, click on the access key.

The current buckets within your project, belonging to the S3 account which owns the selected access key, will be shown in the 'BUCKETS' section.

## Manage buckets

The 'BUCKETS' section shows you the current buckets within your project belonging to the S3 account which owns the selected access key.

!!! Note "Access keys, S3 accounts and buckets"

    Selecting different access keys belonging to the same S3 account will show the same buckets in the 'BUCKETS' section, as all the buckets belonging to the S3 account are shown.

### Create a bucket

To create a bucket:

1. Click **Create**.
1. A 'Create New Bucket' dialog will appear.
1. Enter a **New Bucket Name**.
1. Click **Create**.
1. The new bucket will be created.

!!! Important "Bucket names"

    Bucket names must be between 3-63 characters in length, and must contain only lower case letters, numbers, hyphens `-`, or full stops `.`. See the AWS S3 documentation on [General purpose bucket naming rules](https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html).

### View a bucket

To view a bucket, including its URL and files:

1. Click the bucket name within the 'BUCKETS' section.
1. The bucket URL will be shown. The bucket URL is of form `https://s3.eidf.ac.uk/<project-name>:<bucket-name>`, for example `https://s3.eidf.ac.uk/eidfNNN:mybucket`.
1. The files in the bucket will be listed in a table.

To refresh the view of the selected bucket, to reflect any changes to the bucket since the web page was last loaded, click **Refresh**.

### Upload file(s) into a bucket

To upload file(s) into a bucket:

1. Click **Upload**.
1. An 'Upload Files' section will appear.
1. Either, click **Browse Files** to select files, or, drag and drop files into the 'Upload Files' section.
1. The files will be queued for upload and listed in a 'QUEUED' list.
1. Click **Upload Queued/Failed** to upload the files in the queue.
1. Once uploaded, the files will be listed in a 'COMPLETED' list.

To remove files queued for upload:

1. Click **Clear All**.
1. Any queued files will be removed.
1. The 'QUEUED' and 'COMPLETED' lists will be hidden.

### Download a file from a bucket

To download a file from a bucket:

1. Click the **Download** button, at the right of the file's row in the files table.
1. Depending on both your browser and the file type, the file will either be opened in a new browser tab or downloaded.

### Delete file(s) from a bucket

To delete file(s) from a bucket:

1. Select the file(s) from the files table..
1. Click the **Delete file** button.
1. A 'Permanently delete' dialog will appear.
1. Click **OK**.

!!! Warning "Files are permanently deleted"

    If you want to restore a deleted file, then you will have to re-upload it.

### Toggle file (object) versioning

The EIDF S3 Service supports file (object) versioning. By default, versioning is disabled, and only the latest version of files will be kept. If versioning is enabled, then you can preserve, retrieve, and restore every version of every file stored in your bucket.

To toggle versioning:

1. Click **Settings** and select **Enable Versioning**.
1. A 'Bucket Versioning' dialog will appear.
1. Click the checkbox to toggle on and off versioning.
1. Click **Save Changes**.

### Configure bucket policies

You can configure bucket policies using the Bucket Policy Editor.

To open the Bucket Policy Editor:

1. Click **Settings** and select **Set Bucket Policy**.
1. The 'Bucket Policy Editor' will appear.

Within the Bucket Policy Editor you can edit policies via one of:

* A visual editor.
* A JSON editor.

To switch between these editors, click **JSON** when in the visual editor and click **Visual** when in the JSON editor.

To save the policy, click **Save Policy**.

### Make a bucket public

To make a bucket publicly-readable:

1. Click **Settings** and select **Make Bucket Public**
1. A 'Make bucket publicly readable' dialog will appear.
1. Click **OK**.
1. A 'Bucket is public' section will appear and the bucket URL will be shown. The bucket URL is of form `https://s3.eidf.ac.uk/<project-name>:<bucket-name>` for example `https://s3.eidf.ac.uk/eidfNNN:mybucket`.

To view information about the bucket:

1. Either, visit the bucket URL.
1. Or, click the 'upward right pointing arrow button, at the right of the 'Bucket is public' section.
1. A new browser tab will open, showing an XML document with information about the bucket and all the files it contains including their metadata.

!!! Warning "Publicly-readable buckets are available to all"

    Making a bucket publicly-readable allows anyone who knows the bucket URL to anonymously read the bucket, and the files within.

!!! Note "Effect on existing bucket policies (for those familiar with policies)"

    Making a bucket public will not overwrite any existing bucket policy you may have defined. Rather, it adds two policy statements to your existing policy, if these have not already been added:

    * Effect: Allow, Principal: *, Action: s3:GetObject, Resource: `arn:aws:s3::<project-name>:<bucket-name>/*`
    * Effect: Allow, Principal: *, Action: s3:ListBucket, Resource: `arn:aws:s3::<project-name>:<bucket-name>/*`

### Make a bucket private

If you have previously made a bucket public following the steps of the previous section, then, to make the bucket private:

1. Click **Settings** and select **Set Bucket Policy**.
1. The 'Bucket Policy Editor' will appear.
1. Either, within the visual editor, click **Remove Rule** to remove the permission rules:
    * Effect: Allow, Principals: Public Access (*), Actions: Read Objects
    * Effect: Allow, Principals: Public Access (*), Actions: List Bucket
1. Or, within the JSON editor, edit the `Statement` list to remove the statements:
    * Effect: Allow, Principal: *, Action: s3:GetObject, Resource: `arn:aws:s3::<project-name>:<bucket-name>/*`
    * Effect: Allow, Principal: *, Action: s3:ListBucket, Resource: `arn:aws:s3::<project-name>:<bucket-name>/*`
1. Click **Save Policy**.
