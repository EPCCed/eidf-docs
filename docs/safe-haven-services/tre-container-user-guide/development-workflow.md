# Development workflow

The general guidance for TRE container development is:

- Develop all code on a git platform, typically GitHub or a university managed GitLab service

- Start Dockerfiles from a well-known base image. This is especially important if using a GPU as your container will need to have a compatible version of CUDA (currently 11.1 or later)

- Add all the additional content (code files, libraries, packages, data, and licences) needed for your analysis work to your Dockerfile

- Build and test the container to ensure that it has no external runtime dependencies

- Push the Dockerfile to the project git repository so the container image build is recorded

- Push the container image to the GitHub container registry ghcr.io (GHCR)

- Login to a TRE desktop enabled for container execution to pull and run the container

Containers are connected to three external directories when run inside the TRE: one for access to the project data files (which may be read-only in some cases); one for temporary work files that are all deleted when the container exits; and one for the job output files (which may be set as read-only in some cases when the container exits). All container outputs remain inside the TRE project file space and there is no automatic export when the container finishes.

Container images that have been pulled into the TRE are destroyed after they have been run. Only the files written to the container outputs directory are guaranteed to be retained.

You must ensure that, apart from the input data, your container has everything that it needs to run, including all code and dependencies, and any ancillary files such as machine learning models. It is likely that your development environment, which is always outside the TRE, does not normally have these three directories, but you need to build a container that uses them (see below for path names) because there is no ability inside the TRE to change which directories are available.

The input data file names may change so you may not want to hard-code them into your container. For example, instead of your code using `open("/safe_data/my_patients.csv")` you should consider putting a list of input file names into a config file and reading that config file in your container start up to determine which input data files to use. This will allow you to re-run your container on different data sets much faster than building a new container each time.
