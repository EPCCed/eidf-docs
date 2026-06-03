# Development Workflow

This document describes in detail the steps introduced in [The Safe Haven Container Execution Service - CES](./introduction.md) for the development of containers for SHS use.

## Step 1. Writing a `Dockerfile`

### 1.1 SHS-specific advice

**Declare SHS specific directories using the line `RUN mkdir /safe_data /safe_outputs /scratch` in your `Dockerfile`**. While the CES tools automatically generate these directories within the container, explicitly creating them enhances transparency and helps others more easily understand the container’s structure and operation.

!!! note

    Files should not be added to these directories through the `Dockerfile` prior to mounting, as they would be overwritten during the mounting process. The directories will be fully accessible within the container during run time.

**Start with a well-known application base container on a public registry**. Projects should add a minimum of additional project software and packages so that the container is clearly built for a specific purpose. Avoid patching and preserve the original container setup wherever possible.

!!! warning

    Complex containers, particularly interactive ones, have been carefully designed by competent developers to meet high security and usability standards. Modifying these without the required knowledge might introduce unwanted risks and side effects.

**Do not copy data files into the image**. As a general rule, images should only contain software and configuration files. Any data files required will be presented to the container at runtime (e.g. via the `/safe_data` mount) and should not be copied into the container during the build.

**Add all the additional content (code files, libraries, packages, data, and licences) needed for your analysis work to your `Dockerfile`**. Since the SHS VMs do not have internet access, all necessary code, dependencies, and resources must be pre-packaged within the container to ensure it runs successfully.

**Apply the principle of least privilege**, that is select a non-privileged user inside the container whenever possible.

<!--
Some containers are meant to be started by the root user, for example Rocker. In this case, please use Podman and avoid Kubernetes. In our CES Kubernetes setup, security policies and configurations enforce a non-root execution model. This means containers are explicitly prohibited from running as the root user.
-->

### 1.2 General recommendations

It is highly recommended that you follow these `Dockerfile` best practice guidelines.

**Use fully-qualified and pinned images in all `FROM` statements**. Images can be hosted on multiple repositories, and image tags are mutable. The only way to ensure reproducible builds is by pinning images by their full signature, and, where possible, citing a repository such as `docker.io` or `ghcr.io`.

!!! tip

    The signature of an image can be viewed with the command:

    ```console
    docker inspect --format='{{index .RepoDigests 0}}' <image>
    ```

Incorrect examples:

```dockerfile
FROM nvidia/cuda:latest
```

```dockerfile
FROM docker.io/nvidia/cuda:12.4.1-cudnn-devel-ubuntu22.04
```

```dockerfile
FROM docker.io/nvidia/cuda:latest
```

Correct example:

```dockerfile
FROM docker.io/nvidia/cuda:12.4.1-cudnn-devel-ubuntu22.04@sha256:622e78a1d02c0f90ed900e3985d6c975d8e2dc9ee5e61643aed587dcf9129f42
```

**Group consecutive and related commands into a single `RUN` statement**. Each `RUN` statement causes a new layer to be created in the image. By grouping `RUN` statements together, and deleting temporary files, the final image image size can be greatly reduced.

Incorrect example:

```dockerfile
RUN apt-get -y update
RUN apt-get -y install curl
RUN apt-get -y install git
```

Correct example with a single `RUN` statement with commands broken over multiple lines. Temporary apt files are deleted and not stored in the final image.

```dockerfile
RUN : \
   && apt-get update -qq \
   && DEBIAN_FRONTEND=noninteractive apt-get install \
         -qq -y --no-install-recommends \
         curl \
         git \
   && apt-get clean \
   && rm -rf /var/lib/apt/lists/* \
   && :
```

**Use `COPY` instead of `ADD`**. Compared to the `COPY` command, `ADD` supports much more functionality such as unpacking archives and downloading from URLs. While this may seem convenient, using `ADD` may result in much larger images with layers which are unnecessary. In the following example, using COPY after unpacking locally makes the image more efficient:

Incorrect example:

```dockerfile
FROM python:3.9-slim
# Unpack a tar archive
ADD my_project.tar.gz /target-dir/
CMD ["python", "/target-dir/main.py"]
```

Correct example:

```dockerfile
FROM python:3.9-slim
# Unpack my_project.tar.gz locally first, then copy
COPY my_project/ /target-dir/
CMD ["python", "/target-dir/main.py"]
```

**Use multi-stage builds where appropriate**. Separating build/compilation steps into a separate stage helps to minimise the content of the final image and reduce the overall size.

Example:

```dockerfile
FROM some-image AS builder
RUN apt update && apt -y install build-dependencies
COPY . .
RUN ./configure --prefix=/opt/app && make && make install

FROM some-minimal-image
RUN apt update && apt -y install runtime-dependencies
COPY --from=builder /opt/app /opt/app
```

**Use a minimal image in the last stage to reduce the final image size**. When using multi-stage builds, the final `FROM` image should use a minimal image such as from [Distroless](https://github.com/GoogleContainerTools/distroless/) or [Chainguard](https://images.chainguard.dev/) to minimise image content and size.

Example:

```dockerfile
FROM some-image AS builder
# ...
FROM gcr.io/distroless/base-debian12
# ...
```

**Use a linter to verify the content of the `Dockerfile`**. An example is [Hadolint](https://github.com/hadolint/hadolint). Automated code linting tools can be very useful in detecting common mistakes and pitfalls when developing software. Some configuration tweaks may be required however, as shown in the example below.

Example:

```console
# Ignore DL3008 (Pin versions in apt get install)
docker run --pull always --rm -i docker.io/hadolint/hadolint:latest hadolint --ignore DL3008 - < Dockerfile
```

### 1.3 Other recommendations

See the following resources for additional recommendations:

- <https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1008316>
- <https://docs.docker.com/develop/develop-images/dockerfile_best-practices/>
- <https://sysdig.com/blog/dockerfile-best-practices/>

## Step 2. Build, test locally and push to registry

### 2.1 Build and test the container locally

Docker, Podman, Kubernetes, and Apptainer container images can be created from a single `Dockerfile`, as all of them support the OCI container image format either natively or indirectly.

Containers can be built using the following command:

```console
docker build -t <image>:<tag> -f <path-to-Dockerfile>
```

Run your image locally, so that minor errors can be immediately fixed before proceeding with the next steps:

```console
docker run <options> <image>:<tag>
```

We recommend that you test containers without a network connection to best mimick their functionality inside the SHS, where the container will not be able to access the internet. With Docker and Podman, this can be achieved using the `--network none` command-line parameter.

### Example

A container with the following `Dockerfile`:

```dockerfile
FROM python:3.13.3@sha256:a4b2b11a9faf847c52ad07f5e0d4f34da59bad9d8589b8f2c476165d94c6b377

# Create SHS directories
RUN mkdir /safe_data /safe_outputs /scratch

# Add app files
COPY . /app
WORKDIR /app

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Default command
CMD ["python", "app.py"]
```

where this is the app structure:

```text
.
├── app.py
├── requirements.txt
└── Dockerfile
```

can be built with the command:

```console
docker build -t myapp:v1.1 . --platform linux/amd64
```

where `--platform linux/amd64` is added to ensure image compatibility with the SHS environment in case the image is being built on a different platform.

The container can then be tested with:

```console
docker run --rm myapp:v1.1
```

Podman can be used equivalently to Docker in the commands above.

### 2.2 Automating `Dockerfile` validation

During development, we recommend that tools like GitHub or GitLab are used for version control and recording of the image content. Using the [`pre-commit`](https://pre-commit.com/) tool, it is possible to configure your local repository so that Hadolint (and similar tools) are run automatically each time `git commit` is run. This is recommended to ensure linting and auto-formatting tools are always run before code is pushed to GitHub.

To run Hadolint, include the hook in your `.pre-commit-config.yaml` file:

```yaml
repos:
  - repo: https://github.com/hadolint/hadolint
    rev: v2.12.0
    hooks:
      - id: hadolint-docker
```

### 2.3 Push to GHCR

To prepare the image before pushing to GHCR, we recommend to save the image with a unique, descriptive tag. While it is useful to define a `latest` tag, each production image should also be tagged with a label such as the version or build date. For non-local images, the registry and repository should also be included. Images can also be tagged multiple times.

For example:

```console
docker build \
   --tag ghcr.io/my/image:v1.2.3 \
   --tag ghcr.io/my/image:latest \
   ...
```

The following commands can be used to upload the image to a GHCR repository, where `GHCR_TOKEN` needs to be a GitHub access token with 'repo' and 'write:packages' scope.

```console
echo "${GHCR_TOKEN}" | docker login ghcr.io -u $GHCR_NAMESPACE --password-stdin
docker build . --tag "ghcr.io/$GHCR_NAMESPACE/$IMAGE:$TAG" --tag "ghcr.io/$GHCR_NAMESPACE/$IMAGE:latest"
docker push "ghcr.io/$GHCR_NAMESPACE/$IMAGE:latest"
docker push "ghcr.io/$GHCR_NAMESPACE/$IMAGE:$TAG"
docker logout
```

### 2.5 Optional - Build and upload automation using GitHub Actions

#### Building in CI

Below is a sample GitHub Actions configuration which runs Hadolint, builds a container named `ghcr.io/my/repo`, then runs the [Trivy](https://aquasecurity.github.io/trivy) container scanning tool. The Trivy [SBOM](https://www.cisa.gov/sbom) report is then uploaded as a job artifact.

This assumes:

- The repository contains a `Dockerfile` in the top-level directory,
- The `Dockerfile` contains an `ARG` or `ENV` variable which defines the version of the packaged software.

```yaml
# File .github/workflows/main.yaml
name: main
on:
  push:
defaults:
  run:
    shell: bash
jobs:
  build:
    runs-on: ubuntu-22.04
    steps:
      - name: checkout
        uses: actions/checkout@v4
      - name: run hadolint
        run: docker run --rm -i ghcr.io/hadolint/hadolint hadolint --failure-threshold error - < Dockerfile
      - name: build image
        run: |
          set -euxo pipefail
          repository="ghcr.io/myrepo"
          version="myversion"
          image="${repository}:${version}"
          docker build . --tag "${image}"
          echo "image=${image}" >> "$GITHUB_ENV"
          echo "Built ${image}"
      - name: push image
        run: |
          set -euxo pipefail
          echo "${{ secrets.GITHUB_TOKEN }}" | docker login ghcr.io -u $ --password-stdin
          docker push "${image}"
      - name: run trivy
        uses: aquasecurity/trivy-action@master
        with:
          image-ref: "${{ env.image }}"
          format: 'github'
          output: 'dependency-results.sbom.json'
          github-pat: "${{ secrets.GITHUB_TOKEN }}"
          severity: 'MEDIUM,CRITICAL,HIGH'
          scanners: "vuln"
      - name: upload trivy report
        uses: actions/upload-artifact@v4
        with:
          name: 'trivy-sbom-report'
          path: 'dependency-results.sbom.json'
```

where `secrets.GITHUB_TOKEN` needs to be a GitHub access token with 'repo' and 'write:packages' scope.

!!! note

    Manually running Hadolint via pre-commit can be skipped if you are using pre-commit and the [pre-commit.ci](https://pre-commit.ci/) service.

#### Publishing in CI

!!! note

    Images can also be built and pushed from your local environment as normal.

Once the stage has been reached where your software package is ready for distribution, the GHA example above can be extended to automatically publish new image versions to the GHCR. An introduction to GHCR can be found in the GitHub documentation, [Quickstart for GitHub Packages](https://docs.github.com/en/packages/quickstart).

After the image has been built and scanned, the image can be pushed as follows:

```yaml
- name: push image
  run: |
    set -euxo pipefail
    echo "${{ secrets.GITHUB_TOKEN }}" | docker login ghcr.io -u $ --password-stdin
    docker push "${image}"
```

## Step 3. Pull and run container inside the SHS

To use the containers inside the SHS, log into the desired VM following [Safe Haven Services Access](..//safe-haven-access.md).

!!! warning "Do not use container commands directly"

    The CES tools **must** be used to pull and run containers within the SHS. This is to ensure that the correct data directories are automatically made available.

    You **must not** use commands such as `podman run ...` or `docker run ...` directly.

### 3.1 Pull container

Containers can only be used on the SHS desktop hosts using shell commands. Containers can only be pulled from the GHCR into the SHS using the CES tools `ces-pull` command. Hence containers must be pushed to GHCR for them to be used in the SHS.

!!! note

    Both public and private containers can be pulled from GitHub Container Registry (GHCR) into the SHS. However, within the SHS you will need to provide both a username and an access token to do so. This is a requirement of the CES tools used to pull containers into the SHS.

You can pull a container from your GHCR repository using the `ces-pull` command:

```sh
ces-pull [<runtime>] <github_user> <ghcr_token> ghcr.io/<namespace>/<container_name>:<container_tag>
```

`<gitlab_user>` is a GitHub user name, `<ghcr_token>` is a GitHub access token with 'read:packages' scope that allows access to the image 'ghcr.io/<namespace>/<container_name>:<container_tag>'. Both these arguments are mandatory.

!!! tip

    When pulling containers into the SHS, instead of using the GitHub access token you used to push the container, it is **recommended** you use a GitHub access token with 'read:packages' scope only. Restricting where you use your read-write token can keep your GHCR secure.

If a runtime is not specified then podman is used as the default.

### 3.2 Run container

The container can then be run with `ces-run`:

```sh
ces-run [<runtime>] ghcr.io/<namespace>/<container_name>:<container_tag>
```

`ces-run` supports the following optional arguments under most runtimes:

- Use `--opt-file=<file>` to specify a file containing additional options to be passed to the runtime
- Use `--arg-file=<file>` to specify a file containing arguments to pass to the container command or entrypoint
- Use `--env-file=<file>` to specify a file containing environment variables which will be set inside the container

Containers that require a GPU can be run by adding the `--gpu` option. See `ces-run [<runtime>] --help` for all available options.
