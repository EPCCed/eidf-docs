# The Safe Haven HPC Service - Superdome Flex

## What is the Superdome Flex?

The [Superdome Flex (SDF)](https://www.hpe.com/psnow/doc/a00026242enw) is a high-performance computing cluster manufactured by Hewlett Packard Enterprise. It has been designed to handle multi-core, high-memory tasks in environments where security is paramount. The hardware specifications of the SDF within the Trusted Research Environment (TRE) are as follows:

- 576 physical cores (1152 hyper-threaded cores)
- 18TB of dynamic memory (17 TB available to users)
- 768TB or more of permanent memory

The software specification of the SDF are:

- [Red Hat Enterprise Linux](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/8.7_release_notes/index) (v8.7 as of 27/03/23)
- [Slurm](https://slurm.schedmd.com/quickstart.html) job manager
- Access to local copies of R (CRAN) and python (conda) repositories
- [Singularity](https://docs.sylabs.io/guides/3.5/user-guide/introduction.html) container platform

!!! warning "Network access controls"
    The SDF is within the TRE, therefore, the same restrictions apply, i.e. outside access is limited by Safe Haven IG controls, and copying/recording/extracting code or data outside of the TRE is strictly prohibited unless through approved processes.

## Accessing the SDF

Users can only access the SDF by ssh-ing into it via their VM desktop.

### Hello world

```bash
**** On the VM desktop terminal ****

ssh shs-sdf01
<Enter VM password>

echo "Hello World"

exit
```

## SDF vs VM file systems

The SDF file system is separate from the VM file system, which is again separate from the project data space. Files need to be transferred between the three systems for any analysis to be completed within the SDF.

### Example showing separate SDF and VM file systems

```bash
**** On the VM desktop terminal ****

cd ~
touch test.txt
ls

ssh shs-sdf01
<Enter VM password>

ls # test.txt is not here
exit

scp test.txt shs-sdf01:/home/<USERNAME>/

ssh shs-sdf01
<Enter VM password>

ls # test.txt is here
```

### Example copying data between project data space and SDF

Transferring and synchronising data sets between the project data space and the SDF is easier with the rsync command (rather than manually checking and copying files/folders with scp). rsync only transfers files that are different between the two targets, more details in its manual.

```bash
**** On the VM desktop terminal ****

man rsync # check instructions for using rsync

rsync -avPz -e ssh /safe_data/my_project/ shs-sdf01:/home/<USERNAME>/my_project/ # sync project folder and SDF home folder

ssh shs-sdf01
<Enter VM password>

*** Conduct analysis on SDF ***

exit

rsync -avPz -e ssh /safe_data/my_project/current_wip shs-sdf01:/home/<USERNAME>/my_project/ # sync project file and ssh home page # re-syncronise project folder and SDF home folder

*** Optionally remove the project folder on SDF ***
```
