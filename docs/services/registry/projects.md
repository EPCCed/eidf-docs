# Projects

## Projects within EIDF

Every EIDF project can request that a ECIR project is created for them. An ECIR project is a namespace within the registry which contains repositories for container images private to users of that EIDF project.

!!! important "ECIR Projects"

    EIDF and other EPCC Projects can have ECIR Projects, all users in the owning project can access the ECIR project. The ECIR project is only for image storage and scanning. The owning project can have access to a wide range of other services.

### Project Quota

The default project quota for image storage will be 50 GiB.

Quota increase requests should be submitted via the [EIDF Portal](https://portal.eidf.ac.uk/queries/submit).

### Naming

The root project name for each project will be their EIDF project number in the form:

```bash
eidfXXX
```

### Vulnerability Level Tolerance

The default position of the ECIR is that all images can be deployed onto services, if a project would prefer to have a restriction on the vulnerabilities they are willing to tolerate in their projects, a request can be made to helpdesk to enforce a maximum level of vulnerability tolerance.

Vulnerabilities are ranked:

* Critical
* High
* Medium
* Low

Vulnerability scanning is provided via Trivy, more information about severity levels can be found on the [trivy documentation](https://trivy.dev/latest/docs/scanner/vulnerability/#severity-selection).

### Permissions

ECIR users have the [Harbor project maintainer role permissions](https://goharbor.io/docs/2.14.0/administration/managing-users/user-permissions-by-role/), this allows ECIR users to:

* Create and delete repositories in their projects
* Push and pull images from their projects
* Initiate vulnerability and SBOM scans
* View the results of scans
* Edit the labels available to their projects

ECIR Project maintainers **do not** have the permissions to:

* Create new projects
* Edit project configuration
* Delete projects.

## The Library and Public Caches

ECIR provides a common library of standard images. ECIR provides cache projects for four major registries which allow images to be stored for 7 days after use in ECIR for convenient access.

### The Library

The Library is a public project containing ECIR copies of commonly used container images on the GPU Service. This will be updated over time to reflect use and updates on the service.

To use an image from the Library, the image name should be preceded by `registry.eidf.ac.uk/library`, for example if an Ubuntu image with the tag `latest` were available in the Library it would be accessed with:

```bash
registry.eidf.ac.uk/library/ubuntu:latest
```

Use of images from the Library will not count towards project image storage on the ECIR.

The Library will be updated as images are deprecated or updated and is read only for project users.

Whilst users can use public registries to download images, ECIR aims to reduce request load on public systems and provide a local cache to speed up image access. This helps provide a consistent experience as though downloading from the source but with faster download times.

Users can submit images to be added to the Library where they think these would be beneficial for many users or for images that are accessed frequently. These can be self built images or public images. These should be submit via the [EIDF helpdesk](https://portal.eidf.ac.uk/queries/submit) giving the image details, such as image source and tag(s), as well as justification for inclusion.

### Public Caches

Several main public registries are routed through proxy caches on ECIR. The proxy cache means that a user can pull a public image from a public registry and the ECIR will store a copy of that image. Images in the cache which are pulled in a 7 day period will be retained, otherwise images not pulled for 7 days will be removed from the cache.

This is to reduce pressure on public registries from EIDF systems and to reduce the chance of the public services rate limiting.

The services which have cache projects are:

* Dockerhub [https://hub.docker.com](https://hub.docker.com) - Project docker-cache
* GHCR [https://ghcr.io](https://ghcr.io) - Project ghcr-cache
* Nvidia NGC Registry [https://nvcr.io](https://catalog.ngc.nvidia.com/) - Project nvidia-cache
* Quay.io [https://quay.io](http://quay.io) - Project quay-cache

To use a cache project, the ECIR address and the project name should be pre-pending the name of the image, for example to pull the image, `nvidia/pytorch:25.05-py3` from the Nvidia (NVCR.io) registry, you would use:

```bash
registry.eidf.ac.uk/nvidia-cache/nvidia/pytorch:25.05-py3
```

For Docker, top level images can be referred to directly, such as:

```bash
registry.eidf.ac.uk/docker-cache/alpine:latest
```

Or if they are part of an organisation public repository:

```bash
registry.eidf.ac.uk/docker-cache/mcp/slack:latest
```
