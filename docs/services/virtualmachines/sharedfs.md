# Shared Filesystem (CephFS)

## Introduction

EIDF allows projects with storage space allocated on our CephFS filesystem to access that space on different compute resources such as the EIDF Virtual Machines Service (VMS).

Mounting is done at a project level, so the whole project CephFS tree is mounted. For users who have used our Cerebras or Cirrus services, `/home/eidf124` on Cirrus is the same as `/home/eidf124` on the VM, and users can manipulate files in that directory.

!!! note
    Changing file properties on CephFS on a VM will cause the effect to be visible wherever the file is visible, ie on other systems.

If you set a file stored on CephFS to be world readable on your VM, it will also be world readable (i.e. viewable by any user) on shared-access systems such as Cerebras or Cirrus. This also applies to files in the top-level shared directory. For example, files in `/home/eidf124/shared` are visible wherever `/home/eidf124` is mounted. User VMs typically only mount the project tree, not t
he complete CephFS tree.

## Pre-requisites

!!! warning
    It is not possible to mount CephFS on VMs running Ubuntu 20.04 LTS due to incompatible driver packages. We recommend upgrading to Ubuntu 22.04 LTS, or later, before trying to mount CephFS.

To mount CephFS on a VM:

1. The project must have space allocated on CephFS.
1. A mount key must be created exist. PI's should contact the EIDF helpdesk to have this created.

If both pre-requisites are met, PIs and PMs will be able to see the **Mount** button under **CephFS Mounts** in the project management page in the EIDF portal.

   ![CephFSMountButton](../../images/virtualmachines/CephFSMountButton.png){: class="border-img"}
   *Mount button displayed in project management page*

## Mounting CephFS on a VM

When CephFS is mounted on a VM, it can become the home directory for users logging into that VM. PIs and PMs can enable this mounting for individual VMs via the management page in the Portal.

!!! warning
    Mounting CephFS on a VM of a project where project users have superuser (`sudo`) permissions will allow these project users to see and manipulate files on the CephFS belonging to all other project users.

!!! note
    If there is existing data in the VM-local `/home`, it will be moved to `/local-home` before mounting.
    You will have to manually move this data to the mounted home if you wish it accessible by users without superuser permissions.<BR>
    If your VM runs Ubuntu and you don't mount at `/home` the target location **MUST** be empty. A non-empty mountpoint will cause the mount to fail.

To mount CephFS on a VM:

1. Click the **Mount** button in the project management page under CephFS (see screenshot above).
1. Follow the instructions, selecting either to mount as `/home` or specifying an alternative mount location
1. Select the VMs on which to mount CephFS at the specified location.
1. Click **Submit**

   ![CephFSMountPage](../../images/virtualmachines/CephFSMountPage.png){: class="border-img"}
   *Example mounting page for project eidf124*
