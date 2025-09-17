# \[Beta] TRE Code Management and Mirroring Service

!!! warning "Beta Service"
    This service is in early development, and the content of this page may change significantly. Please provide all feedback to your IG team.

The Code Management and Mirroring Service provides Researchers and IG teams with access to a platform similar to GitHub for managing code inside the TRE. If permitted by the IG team, this also supports egress of internal code to external repositories via review & approval by RCs.

A separate instance of the service is available to each TRE tenancy, and each instance is accessible only within the tenancy it is deployed to.

!!! note "Availabilty"
    This service is an add-on to the base tenancy offering, and so may not be available to all TRE users. Please enquire with your IG team to determine if it is available to you.

## Overview

The service is based on the [Gitea](https://about.gitea.com/) collaborative version control system, which offers many of the same features as GitHub and GitLab. Some restrictions, such as the ability to freely create repositories, are in place in order to ensure separation of project data as per IG requirements.

Available features include:

- Software version control
- Pull and push while inside the TRE
- Bug and issue tracking
- Pull Requests
- Code review
- Wikis

This page provides information on accessing and using the service, however is not intended as a guide to Gitea. Please see Gitea's own [documentation][gitea_docs] for general usage information. It is also assumed that users are familiar with git and the use of version control services.

## Access

Access must be requested from your Research Coordinator (RC). On being granted access, you will be provided with the following information:

- Gitea URL
- Username
- Initial Password

Gitea can be accessed from your VM desktop by opening a Web Browser and navigating to the provided URL. After logging in for the first time, you will be prompted to change your password.

Once logged-in, you will be presented with a dashboard showing recent activity in your organization. In Gitea, an "organization" is analagous to a project group, and you will be automatically granted access to the organization matching your TRE project identifier.

## Request a Repository

To request the creation of a repository in your organization, contact your RC and let them know the desired name. Multiple repositories may be created under each organization.

Once created, your repository will be visible from your Gitea dashboard or under the "Explore" tab.

!!! note "Repository Permissions"
    All members of an organization (TRE project) have full read/write access to each of its repositories, regardless of who requested its creation. This is the intended behaviour and will not be changed e.g., to restrict repository access to a subset of a TRE project's members. This is equivalent to the files in each `/safe_data/<project_id>` directory being accessible to all project members.

## Clone a Repository

SSH access is not enabled, so HTTPS must be used to clone repositories.

When running `git clone`, `git fetch`, and `git push`, you will be prompted for your Gitea username and password each time. For convenience, you may wish to generate an access token to avoid re-entering your credentials on each operation. To do this:

1. Click your profile picture in the top right and then on Settings
1. Click Applications in the sidebar
1. Create a new token
    1. Enter a descriptive name
    1. Expand "Select permissions" and change "repository" to "Read and Write"
1. Clone the repo using the token, for example `git clone https://<token>@<url>/<organization>/<repo>.git`

## Further Reading and Help

- The [Gitea docs][gitea_docs] are the best reference for using this service
- Contact your IG team if you require and help accessing or using the service

<!-- Links -->

[gitea_docs]: https://docs.gitea.com/
