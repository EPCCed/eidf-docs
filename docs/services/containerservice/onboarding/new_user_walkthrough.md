# New user onboarding for the K8s GPU cluster

## 1) New user sign up to EIDF

All users need an account on the EIDF portal which provides users with a desktop VM to access the  GPU cluster.

Full Documentation on signing up at [EIDF Documentation](https://epcced.github.io/eidf-docs/).

a. Open Browser and goto the [EIDF Portal](https://portal.eidf.ac.uk)

b. Click Login -> This will redirect to SAFE

c. if you have a SAFE account -> use that account, if you do not have a SAFE account, register for a new SAFE account

d. Return to the EIDF portal after your SAFE account has logged in and activated.

## 2) New user request access to the informatics project

Once you have an EIDF account you can request the creation of a desktop VM linked to the GPU cluster.

a. Click on the dropdown menu "Projects"

b. Click "Request Access"

c. Choose from the list "eidf029 - Informatics K8s Support"

d. Click "Apply'

e. Wait for the approver (project lead) to add you to the project and create an account.

## 3) New user first login

You need to log onto the EIDF VM and change the default password. This must be done through the EIDF VDI web portal. Once you have changed the password you can continue to use the VDI portal or you can access the desktop VM by ssh-ing from your local terminal. However, local ssh-ing into the desktop VM requires you to register an ssh key on the EIDF portal.

a. Login to the [EIDF Portal](https://portal.eidf.ac.uk)

b. Click on the dropdown menu "Projects"

c. Click "Your Projects"

d. Choose from the list "eidf029 - Informatics K8s Support"

e. Click your account user name from your Account

f. Click to view your initial password and copy/note it

g. Click VDI Login

h. From the project list of VMs, choose eidf029-host1_ssh

i. Enter your username

j. Enter the initial password

k. At the change password prompt follow the instructions.

l. Read through the training materials to understand how to use the kubernetes cluster

## Optional: Registering an ssh key to access the desktop VM

a. Generate public-private ssh key pair

```bash
ssh-keygen -f <suitable ssh key file name>
```

b. Login to the [EIDF Portal](https://portal.eidf.ac.uk)

c. Click on the dropdown menu "Projects"

d. Click "Your Projects"

e. Choose from the list "eidf029 - Informatics K8s Support"

f. Click your account user name from your Account

g. Upload <suitable ssh key file name>.public to your credentials

h. Wait for the credential to be accepted

i. Add private key to current ssh key registry

```bash
ssh-add <private ssh key file>
<password>
```

j. ssh in on your local terminal using

```bash
ssh -J <account>@eidf-gateway.epcc.ed.ac.uk <account>@10.24.5.121
```
