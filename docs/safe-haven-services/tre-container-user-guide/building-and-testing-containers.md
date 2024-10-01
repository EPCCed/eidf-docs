# Building and Testing Containers

## Choose a container base from DockerHub

Projects should build containers by starting with a well-known application base container on a public registry. Projects should add a minimum of additional project software and packages so that the container is clearly built for a specific purpose.
Containers built for one specific batch job, either a data transformation or analysis, are examples of this approach.
Container builds that assemble groups of tools and then used to run a variety of tasks should be avoided.
Additionally, container builds that start from generic distributions such as Debian or Ubuntu should also be avoided as leaner and more focussed application and language containers are already available.

Examples of batch job container bases are Python and PyTorch, and other language specific and ML software stacks. Examples of interactive container bases are Rocker, Jupyter Docker Stacks, and NVIDIA RAPIDS extended with additional package sets and code required by your project.

## Add TRE file system directories

Container images built to run in the TRE must implement the following line in the Dockerfile to interface with the project data and the TRE file system:

```docker
RUN mkdir /safe_data /safe_outputs /scratch
```

The project’s private `/safe_data/<project id>` directory is mapped to the container’s `/safe_data` directory. A unique container job output directory is created in the user's home directory and mapped to `/safe_outputs` in the container. And `/scratch` is a temporary workspace that is deleted when the container exits. If the container processing uses the `TMP` environment variable, it should be set to the `/scratch` volume mount.
Hence, containers have access to three directories located on the host system as detailed in the following table:

| Directory on host system | Directory in container | Intended use
| -------- | ------- | ------- |
| `/safe_data/<your_project_name>/`|/`safe_data`|Read-only access if required by IG, or read-write access, to data and other project files.|
|`~/outputs_<unique_id>`  |`/safe_outputs`  |Will be created at container startup as an empty directory. Intended for any outputs: logs, data, models.|
|`~/scratch_<unique_id>`|`/scratch`|Temporary directory that is removed after container termination on the host system. Any temporary files should be placed here.|

Currently, temporary files can also be written into any directory in the container’s internal file system. This is allowed to prevent container software failure when it is dependent on the container file system being writable. However, the use of `/scratch` is encouraged for two reasons:

 1. In the future, write access to the container file system might be prevented for security reasons. Further, the space available on the container’s internal file system is limited compared to the space available on `/scratch`. Writing only to `/scratch` at runtime is therefore future proof.
 1. Use of `/scratch` can be more efficient if the service is able to mount it on high-performing storage devices.

## Install and copy project code into container

Research software stacks are complex and dependent on many package sets and libraries, and sometimes on specific version combinations of these. The container build process presents the project team with the opportunity to manage and resolve these dependencies before contact with the project data in the restricted TRE setting.

Unlike the TRE desktop servers, containers do not have access to external network repositories, and do not have access to external licence servers. Any container software that requires a licence to run must be copied into the container at build time. EPCC are not responsible for verifying that the appropriate licences are installed or that license terms are being met.

Projects using configuration files for multiple containers, for example ML models, can also import these to the TRE directly by copying them to the project `/safe_data` file system.

Batch jobs built to run as containers should start directly from the `ENTRYPOINT` or `CMD` section of the Dockerfile. Batch jobs should run without any user interaction after start, should read input from the `/safe_data` directory and write outputs to the `/scratch` and `/safe_outputs` directories.

Interactive containers should present a connection port for the user session. Once the container is started the user can connect to the session port from the TRE desktop. If code files are being changed during the session these should be saved on the `/safe_data` or the `/safe_outputs` directories as the internal container file space is not preserved when the session ends.

## Test the container for TRE use

When the container is running in the TRE it will not have any external network or internet access. If the code, or any of its dependencies, rely on data files downloaded at runtime (for example machine learning models) this will fail in the TRE. Code must be modified to load these files explicitly from a file path which is accessible from inside the container.

An example of TRE network isolation significance and the considerations arising from this is provided by Hugging Face, where models are cached in the user local `~/.cache/huggingface/hub/` directory in the container. The environment variable `HF_HOME` must be set to a directory in a `/safe_data` project folder and the `cache_dir` option of the `from_pretrained()` call used at runtime.

If a model is downloaded from Hugging Face the advice is to set the environment variable `HF_HUB_OFFLINE=1` to prevent attempts at contact the Hugging Face Hub. Any connection attempts will take a significant time to elapse and then fail in the TRE setting.

It is recommended that the checklist for Dockerfile composition is followed: [Container Build Guide](https://github.com/EPCCed/tre-container-samples/blob/main/docs/container-build-guide.md)

Information Governance requirements may require a security scan of both:

 1. The Dockerfile used to build the container image

 1. The container image itself, once it is built.

[Trivy](https://trivy.dev/) is a tool that can help with this task. Trivy inspects container images to find items which have known vulnerabilities and produces a report that may be used to help assess the risk.

### 1. Scanning the container Dockerfile

The use of the Trivy misconfiguration tool on Dockerfiles is also recommended. This tool option will highlight many common security issues in the Dockerfile:

```bash
docker run --rm -v $(pwd):/repo ghcr.io/aquasecurity/trivy:latest config "/repo/Dockerfile"
```

The security posture of containers and the build process may be of interest to IG teams, however, it is not expected that security issues indicated by the tool need to be addressed before the container is run in the TRE unless the IG team issues specific guidance on vulnerability and configuration remediation and mitigation.

### 2. Scanning the container image using Trivy CI

Trivy can be run manually on the built image but it is easier to have it run automatically whenever you update your container image. An example GitHub Actions workflow to run Trivy and publish the outputs can be found [here](https://github.com/EPCCed/tre-container-samples/blob/main/.github/workflows/main.yaml)

The Trivy report can be downloaded as an artifact from the job summary page. Before using a specific container in the TRE it may be necessary to test the security risk and gain IG team approval.
