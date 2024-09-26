# Introduction

This guide sets out the required activities for researchers using containers in the EPCC TRE (Safe Haven). The intended audience are software developers with experience of containers and Docker and Podman in particular. Online courses such as [Intro to Containers](https://github.com/ImperialCollegeLondon/RCDS-intro-to-containers) demonstrate the base skills needed if there is any doubt.

The Container Execution Service (CES) has been introduced to allow project code developed and tested by researchers outside the TRE in personal development environments to be imported and run on the project data inside the TRE using a well-documented, transparent, secure workflow. The primary role of the TRE is to store and share data securely; it is not intended to be a software development and testing environment. The CES removes the need for software development in the TRE.

The use of containers and software configuration management processes is also strongly advocated by the research software engineering community for experiment management and reproducibility. It is recommended that TRE container builders take a disciplined approach to code management and use git to create container build audit trails to satisfy any IG (Information Governance) concerns about the provenance of the project code.
