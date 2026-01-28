# Overview

The Secure Virtual Desktop service is a specialised offering within EIDF, designed to provide enhanced security and controlled access for sensitive data projects. The Secure Virtual Desktop service is built on the same underlying EIDF Virtual Machine (VM) Service infrastructure with additional access controls, network isolation, and policy requirements to meet the needs of secure data handling. Development of this service makes use of work done on the Scottish Safe Haven Trusted Research Environment. This section describes the service features specific to the Secure Virtual Desktop, and highlights differences from the general VM Service where relevant.

The service currently has a mixture of hardware node types which host VMs of various flavours, [these are the same as the virtual machine service](../virtualmachines/flavours.md):

## Data Processing Requirements for Secure Virtual Desktop Service

EIDF supports processing many kinds of data including sensitive and personal data. We have policies in place about the kinds of data that are permitted in the EIDF and that certain requirements are in place to ensure data complies with EIDF and regulatory processing requirements before it is processed.

For processing some types of data, the Secure Virtual Desktop service may be appropriate; for others, a Safe Haven TRE may be required. For a full list of data types and their restrictions or requirements please see the [EIDF Third Party Data Policy](https://edinburgh-international-data-facility.ed.ac.uk/about/policies/third-party-data).

## Service Access

Users should have an EIDF account - [EIDF Accounts](../../access/project.md).

Project Leads will be able to have access to the DSC added to their project during the project application process or through a request to the EIDF helpdesk.

## Additional Service Policy Information

Additional information on service policies can be found [in the policies page](policies.md).

## Using the Secure Virtual Desktop

An introduction to using the Secure Virtual Desktop service can be found in the [Quickstart guide](quickstart.md).

Management of Secure Virtual Desktop VMs is described in the [Managing VMs documentation](docs.md).
