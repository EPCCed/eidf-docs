# Using the MFT Web Portal

## Logging in to the web browser

When you reach the MFT [home page](https://eidf-mft.epcc.ed.ac.uk) you can log in using your usual VM project credentials.

You will then be asked what type of session you would like to start. Select New Web Client or Web Client and continue.

## File Ingress

Once logged in, all files currently in the projects transfer directory will be displayed.
Click the 'Upload' button under the 'Home' title to open the dialogue for file upload. You can then drag and drop files in, or click 'Browse' to find them locally.

Once uploaded, the file will be immediately accessible from the project area, and can be used within any EIDF service which has the filesystem mounted.

## File Egress

File egress can be done in the reverse way. By placing the file into the project transfer directory, it will become available in the MFT portal.

## File Management

Directories can be created within the project transfer directory, for example with 'Import' and 'Export' to allow for better file management.
Files deleted from either the MFT portal or from the VM itself will remove it from the other, as both locations point at the same file. It's only stored in one place, so modifications made from either place will remove the file.


## SFTP

Once a project and user have access to the MFT, they can connect to it using SFTP as well as through the web browser.

This can be done by logging into the MFT URL with the user's project account:

 ```bash

    sftp [EIDF username]@eidf-mft.epcc.ed.ac.uk

```

## SCP

Files can be scripted to be upload to the MFT using SCP.

To copy a file to the project MFT area using SCP:

```bash

    scp /path/to/file [EIDF username]@eidf-mft.epcc.ed.ac.uk:/

```
