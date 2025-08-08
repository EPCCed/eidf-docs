# Introduction

## Overview

The Container Execution Service (CES) has been introduced to allow project code developed and tested by researchers outside the Trusted Research Environment (TRE) in personal development environments to be imported and run on the project data inside the TRE using a well-documented, transparent, secure workflow.
The primary role of the TRE is to store and share data securely; it is not intended to be a software development and testing environment. The CES helps researchers perform software development tasks in their chosen environment, rather than the restricted one offered in the TRE.
This guide describes the process of building and testing TRE-ready containers outside the TRE, specifically within a test enviroment created in the EIDF, so that they are ready to be pulled and used inside the TRE.

We assume that users are already familiar with container concepts and have some experience in building their own images. If a user is new to container tools, the following resources would be a good starting point:

- <https://carpentries-incubator.github.io/docker-introduction/>
- <https://docs.docker.com/get-started/overview/>
- <https://docker-curriculum.com/>

It is also assumed that software development best practices are followed, such as version control using Git(Hub) and Continuous Integration (CI). This can help create container build audit trails to satisfy any IG (Information Governance) concerns about the provenance of the project code.

The development process includes the following steps:

1. Create a Dockerfile following [general recommendations](./development-workflow.md#12-general-recommendations) and [TRE-specific advice](./development-workflow.md#11-tre-specific-advice).
1. Build the image and upload to the GitHub Container Registry (GHCR), either locally or using a CI/CD pipeline.
1. Test the container in the [CES test environment](./development-workflow.md#31-accessing-test-environment) to ensure it functions correctly and has no external runtime dependencies.
1. Login to a TRE desktop enabled for container execution to pull and run the container.

This guide contains a number of [workflow examples](./workflow-examples.md) designed to assist users in building TRE-ready containers. Other [container examples](./container-examples.md) are also available in our [TRE Container Samples](https://github.com/EPCCed/tre-container-samples/) repository.

> [!NOTE]
> Users wishing to gain access to the CES inside a Safe Haven will need to contact their Research Coordinator and request access.

## TRE directories

Before continuing with this guide, it is important that the users are aware of the TRE file system directories so that they can be used correctly within their containers. Project data inside the TRE can be found in the `/safe_data/<project-id>` directory.
The CES tools automatically map this to a directory called `/safe_data` inside the container. Additionally, two directories are created and mapped to the user's home directory. The first one is `/scratch`, a temporary directory that is removed after container termination on the host system.
The second one is a unique container job output directory mapped to the `/safe_outputs` directory in the container, where output files that the users wishes to preserve should be placed. Note that containers that have been pulled into the TRE are destroyed after they have been run. Only the files written to the container outputs directory are guaranteed to be retained.

| Directory on host system | Directory in container | Intended use
| -------- | ------- | ------- |
| `/safe_data/<your_project_name>/`|/`safe_data`|Read-only access if required by IG, or read-write access, to data and other project files.|
|`~/outputs_<unique_id>`  |`/safe_outputs`  |Will be created at container startup as an empty directory. Intended for any outputs: logs, data, models. Content saved in this directory will be retained after the container exits.|
|`~/scratch_<unique_id>`|`/scratch`|Temporary directory that is removed after container termination on the host system. Any temporary files should be placed here.|

Temporary files can also be written into any directory in the container’s internal file system. However, the use of `/scratch` can be more efficient if the service is able to mount it on high-performing storage devices.

## Advising Information Governance of required software stack

Projects must establish that the software stack they intend to import in the container is acceptable for the project’s IG approvals. Projects should only seek to use container-based software if the standard TRE desktop environment is not sufficient for the research scope. However, it is broadly understood that the standard desktop software, whilst useful in most cases, is inadequate for many purposes and specifically ML, and software import using containers is intended to address this.
