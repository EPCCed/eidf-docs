# The Safe Haven Container Execution Service - CES

## What is the CES?

The Container Execution Service (CES) has been introduced to allow project code developed and tested by researchers outside the Safe Haven Services (SHS) in personal development environments to be imported and run on the project data inside the SHS using a well-documented, transparent, secure workflow.

The primary role of the SHS is to store and share data securely; it is not intended to be a software development and testing environment. The CES helps researchers perform software development tasks in their chosen environment, rather than the restricted one offered in the SHS.

This guide describes the process of building and testing SHS-ready containers outside the SHS, and testing them within an EIDF CES test VM, so that they are ready to be pulled and used inside the SHS.

## Accessing the CES

In order for you to get access to CES, ask your Research Coordinator for your Safe Haven to submit a query to CES-enable the VM of interest (if not already enabled), then, per project-account, to submit a query to configure your account(s) to use the CES.

## Accessing the EIDF CES test VM

A CES test VM is available within EIDF that allows for containers to be tested in an SHS-like environment without having to be logged into the SHS itself. Containers that run successfully within this VM can then be expected to run in the same way in the SHS.

To get access to this EIDF CES test VM, ask your Research Coordinator for your Safe Haven to submit a query that states that you wish access to the EIDF CES test VM.

Then, if you do not already have an EPCC SAFE account, apply for an EPCC SAFE account following the instructions in [SAFE for users](https://epcced.github.io/safe-docs/safe-for-users/).

Once you have a safe account, follow [How to request to join a project](../../access/project.md#how-to-request-to-join-a-project), and request to join the EIDF project 'eidf147: CES Development'.

The EPCC CES team will check that your request from your Research Coordinator has been received. Once checked, an account on the CES test VM will be created and you will be notified of both your username and the CES test VM host name.

You can then log into the CES test VM following [Accessing EIDF](../../../access).

## Getting started

We assume that you are already familiar with container concepts and have some experience in building their own images. If you are new to container tools, the following resources would be a good starting point:

- <https://carpentries-incubator.github.io/docker-introduction/>
- <https://docs.docker.com/get-started/overview/>
- <https://docker-curriculum.com/>

It is also assumed that software development best practices are followed, such as version control using Git and GitHub or GitLab, and, ideally, Continuous Integration (CI). This can help create container build audit trails to satisfy any Information Governance (IG) concerns about the provenance of the container's content.

The [development workflow](./development-workflow.md) includes the following steps:

1. Write a Dockerfile following both our SHS-specific advice and general recommendations.
1. Build, test the image locally and push to a container registry, for example, the GitHub Container Registry (GHCR), either locally or using a CI/CD pipeline.
1. Pull and run the container inside the CES test VM
1. Pull and run the container inside your Safe Haven on a VM enabled for container execution.

This guide also contains a number of [workflow examples](./workflow-examples.md) designed to assist you in building SHS-ready containers. Other [container examples](./container-examples.md) are also available in our [SHS Container Samples](https://github.com/EPCCed/tre-container-samples/) repository.

## SHS directories and containers

Before continuing with this guide, it is important that you are aware of the SHS file system directories so that they can be used correctly within their containers.

Project data inside the SHS can be found in your `/safe_data/<project-id>/` directory. The CES tools automatically map, or mount, this to a directory called `/safe_data/` inside the container.

Additionally, two directories are created and mapped to directories in your home directory. The first is a temporary directory that is mapped to the `/scratch/` directory within the container and which is removed after the container stops running on the host.

The second is a unique container job output directory mapped to the `/safe_outputs/` directory in the container, where output files that you wish to preserve can be placed. You are also free to write output files to `/safe_data/` within the container if you have been granted read-write access to your `/safe_data/<project-id>/` directory.

| Directory on host system | Directory in container | Intended use |
| ------------------------ | ---------------------- | ------------ |
| `/safe_data/<project-id>/` | `/safe_data/`| Read-only access if required by IG, or read-write access, to data and other project files. Can be used for outputs, depending on your Safe Haven's IG and usage conventions. |
| `~/outputs_<unique_id>/`  | `/safe_outputs/` | Created at container startup as an empty directory. Can be used for any outputs e.g., logs, data, models, depending on your Safe Haven's IG and usage conventions. Content saved in this directory will be retained after the container exits. |
| `~/scratch_<unique_id>/` | `/scratch/`| Temporary directory that is removed when the container exits. Any temporary files should be placed here. |

!!! warning

    Only files created in `/safe_data/` or `/safe_outputs/` will continue to be available once a container exits.

!!! note

    Temporary files can also be written into any directory in the container’s internal file system. However, the use of `/scratch/` can be more efficient if the service is able to mount it on high-performing storage devices.

## Advising Information Governance of required software stack

Projects **must** establish that the software stack they intend to import in the container is acceptable for the project’s IG approvals.

Projects should only seek to use container-based software if the standard SHS desktop environment is not sufficient for the research scope. However, it is broadly understood that the standard SHS desktop software, whilst useful in most cases, is inadequate for many purposes, for example machine learning, and software import using containers is intended to address this.
