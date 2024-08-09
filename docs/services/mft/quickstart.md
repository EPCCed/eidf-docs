# Managed File Transfer

## Getting to the MFT

The EIDF MFT can be accessed at [https://eidf-mft.epcc.ed.ac.uk](https://eidf-mft.epcc.ed.ac.uk)

## How it works

The MFT provides a 'drop zone' for the project. All users in a given project will have access to the same shared transfer area. They will have the ability to upload, download, and delete files from the project's transfer area. This area is linked to a directory within the projects space on the shared backend storage.

Files which are uploaded are owned by the Linux user 'nobody' and the group ID of whatever project the file is being uploaded to. They have the permissions: <br>
Owner = rw <br>
Group =   r <br>
Others = r

Once the file is opened on the VM, the user that opened it will become the owner and they can make further changes.

## Gaining access to the MFT

By default a project won't have access to the MFT, this has to be enabled. Currently this can be done by the PI sending a request to the EIDF Helpdesk.
Once the project is enabled within the MFT, every user with the project will be able to log into the MFT using their usual EIDF credentials.

Once MFT access has been enabled for a project, PIs can give a project user access to the MFT.
A new 'eidf-mft' machine option will be available for each user within the portal, which the PI can select to grant the user access to the MFT.