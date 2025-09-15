# Development Workflow

This document describes in detail the [four steps](./introduction.md#overview) recommended for the development of containers for TRE use.

## Step 1. Writing a `Dockerfile`

### 1.1 TRE-specific advice

- Declare TRE specific directories using the line `RUN mkdir /safe_data /safe_outputs /scratch` in your Dockerfile. While the CES tools automatically generate these directories within the container, explicitly creating them
   enhances transparency and helps others more easily understand the container’s structure and operation.
   Note that files should not be added to these directories through the Dockerfile prior to mounting, as they would be overwritten during the mounting process. The directories will be fully accessible within the container during run time.

- Start with a well-known application base container on a public registry.
   Projects should add a minimum of additional project software and packages
   so that the container is clearly built for a specific purpose. Avoid
   patching and preserve the original container setup wherever possible.
   Complex containers, particularly interactive ones, have been carefully
   designed by competent developers to meet high security and usability
   standards. Modifying these without the required knowledge might introduce
   unwanted risks and side effects.

- Do not copy data files into the image. As a general rule, images should only contain software and configuration files. Any data files required will be presented to the container at runtime (e.g. via the `/safe_data` mount) and should not be copied into the container during the build.

- Add all the additional content (code files, libraries, packages, data, and licences) needed for your analysis work to your Dockerfile. Since the TRE VMs do not have internet access, all necessary code, dependencies, and resources must be pre-packaged within the container to ensure it runs successfully.

- Apply the principle of least privilege, that is select a non-privileged user inside the container whenever possible.

<!--- Some containers are meant to be started by the root user, for example Rocker. In this case, please use Podman and avoid Kubernetes. In our CES Kubernetes setup, security policies and configurations enforce a non-root execution model. This means containers are explicitly prohibited from running as the root user.-->

### 1.2 General recommendations

It is highly recommended that users follow these Dockerfile best practice guidelines:

- Use fully-qualified and pinned images in all `FROM` statements. Images can be hosted on multiple repositories, and image tags are mutable. The only way to ensure reproducible builds is by pinning images by their full signature. The signature of an image can be viewed with `docker inspect --format='{{index .RepoDigests 0}}' <image>`. The image repository is usually `docker.io` or `ghcr.io`.

   **Example**:

   ```dockerfile
   # Incorrect
   FROM nvidia/cuda:latest
   FROM docker.io/nvidia/cuda:12.4.1-cudnn-devel-ubuntu22.04
   FROM docker.io/nvidia/cuda:latest

   # Correct
   FROM docker.io/nvidia/cuda:12.4.1-cudnn-devel-ubuntu22.04@sha256:622e78a1d02c0f90ed900e3985d6c975d8e2dc9ee5e61643aed587dcf9129f42
   ```

- Group consecutive and related commands into a single `RUN` statement. Each `RUN` statement causes a new layer to be created in the image. By grouping `RUN` statements together, and deleting temporary files, the final image image size can be greatly reduced.

   **Example**:

   ```dockerfile
   # Incorrect
   RUN apt-get -y update
   RUN apt-get -y install curl
   RUN apt-get -y install git

   # Correct
   # - Single RUN statement with commands broken over multiple lines
   # - Temporary apt files are deleted and not stored in the final image
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

- Use `COPY` instead of `ADD`. Compared to the `COPY` command, `ADD` supports much more functionality such as unpacking archives and downloading from URLs. While this may seem convenient, using `ADD` may result in much larger images with layers which are unnecessary. In the following example, using COPY after unpacking locally makes the image more efficient:

   **Example**:

   ```dockerfile
   # Incorrect
   FROM python:3.9-slim
   # Unpack a tar archive
   ADD my_project.tar.gz /target-dir/
   CMD ["python", "/target-dir/main.py"]

   # Correct
   FROM python:3.9-slim
   # Unpack my_project.tar.gz locally first, then copy
   COPY my_project/ /target-dir/
   CMD ["python", "/target-dir/main.py"]
   ```

- Use multi-stage builds where appropriate. Separating build/compilation steps into a separate stage helps to minimise the content of the final image and reduce the overall size.

   **Example**:

   ```dockerfile
   FROM some-image AS builder
   RUN apt update && apt -y install build-dependencies
   COPY . .
   RUN ./configure --prefix=/opt/app && make && make install

   FROM some-minimal-image
   RUN apt update && apt -y install runtime-dependencies
   COPY --from=builder /opt/app /opt/app
   ```

- Use a minimal image in the last stage to reduce the final image size. When using multi-stage builds, the final `FROM` image should use a minimal image such as from [Distroless](https://github.com/GoogleContainerTools/distroless/) or [Chainguard](https://images.chainguard.dev/) to minimise image content and size.

   **Example**:

   ```dockerfile
   FROM some-image AS builder
   # ...
   FROM gcr.io/distroless/base-debian12
   # ...
   ```

- Use a linter such as [Hadolint](https://github.com/hadolint/hadolint) to verify the content of the `Dockerfile`.
 Automated code linting tools can be very useful in detecting common mistakes and pitfalls when developing software. Some configuration tweaks may be required however, as shown in the example below.

   **Example**:

   ```console
   # Ignore DL3008 (Pin versions in apt get install)
   docker run --pull always --rm -i docker.io/hadolint/hadolint:latest hadolint --ignore DL3008 - < Dockerfile
   ```

See the following resources for additional recommendations:

- <https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1008316>
- <https://docs.docker.com/develop/develop-images/dockerfile_best-practices/>
- <https://sysdig.com/blog/dockerfile-best-practices/>

## Step 2. Build, test locally and push to registry

### 2.1 Build and test the container locally

Docker, Podman, Kubernetes, and Apptainer container images can be created from a single Dockerfile, as all of them support the OCI container image format either natively or indirectly.

Containers can be built using the following command:

```console
docker build -t <image>:<tag> -f <path-to-Dockerfile>
```

Run your image locally, so that minor errors can be immediately fixed before proceeding with the next steps:

```console
docker run <options> <image>:<tag>
```

### Example

A container with the following Dockerfile:

```dockerfile
   FROM python:3.13.3@sha256:a4b2b11a9faf847c52ad07f5e0d4f34da59bad9d8589b8f2c476165d94c6b377

   # Create TRE directories
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

```console
.
├── app.py
├── requirements.txt
└── Dockerfile
```

can be built with the command:

```console
docker build -t myapp:v1.1 . --platform linux/amd64
```

where `--platform linux/amd64` is added to ensure image compatibility with the TRE environment in case the image is being built on a different platform.

The container can then be tested with:

```console
docker run --rm myapp:v1.1
```

Podman can be used equivalently to Docker in the commands above.

### 2.2 Automating Dockerfile validation

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

   **Example**:

   ```console
   docker build \
      --tag ghcr.io/my/image:v1.2.3 \
      --tag ghcr.io/my/image:latest \
      ...
   ```

The following commands can be used to upload the image to a private GHCR repository.

```console
echo "${GHCR_TOKEN}" | docker login ghcr.io -u $GHCR_NAMESPACE --password-stdin
docker build . --tag "ghcr.io/$GHCR_NAMESPACE/$IMAGE:$TAG" --tag "ghcr.io/$GHCR_NAMESPACE/$IMAGE:latest"
docker push "ghcr.io/$GHCR_NAMESPACE/$IMAGE:latest"
docker push "ghcr.io/$GHCR_NAMESPACE/$IMAGE:$TAG"
docker logout
```

### 2.5 Optional - Build and upload automation using GitHub Actions

#### Building in CI

Below is a sample GHA configuration which runs Hadolint, builds a container named `ghcr.io/my/repo`, then runs the [Trivy](https://aquasecurity.github.io/trivy) container scanning tool. The Trivy [SBOM](https://www.cisa.gov/sbom) report is then uploaded as a job artifact.

This assumes:

- The repo contains a `Dockerfile` in the top-level directory,
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

Note that manually running Hadolint via pre-commit can be skipped if you are using pre-commit and the [pre-commit.ci](https://pre-commit.ci/) service.

#### Publishing in CI

__Note__ Images can also be built and pushed from your local environment as normal.

Once the stage has been reached where your software package is ready for distribution, the GHA example above can be extended to automatically publish new image versions to the GHCR. An introduction to GHCR can be found in the GitHub docs [here](https://docs.github.com/en/packages/quickstart).

```yaml
# After the image has been built and scanned
- name: push image
  run: |
    set -euxo pipefail
    echo "${{ secrets.GITHUB_TOKEN }}" | docker login ghcr.io -u $ --password-stdin
    docker push "${image}"
```

## Step 3. Test in CES test environment

EPCC provides a test environment that allows users to test their containers in a TRE-like environment without having to be logged into the TRE itself. Containers that run successfully in such environment can then be expected to perform in the same way in the TRE.

### 3.1 Accessing test environment

The test environment is located in the eidf147 project. Please ask your research coordinator to contact EPCC and request for you to be added to the test environment.

### 3.2 Pull and run

!!! warning "Do not use container CLIs directly"
    The CES wrapper scripts **must** be used to run containers in the TRE. This is to ensure that the correct data directories are automatically made available.

    You **must not** use commands such as `podman run ...` or `docker run ...` directly.

Containers can only be used on the TRE desktop hosts using shell commands. Containers can only be pulled from the GHCR into the TRE using a `ces-pull` script. Hence containers must be pushed to GHCR for them to be used in the TRE. Although alternative methods can be used in the test environment, we encourage users to follow the exact same procedure as they would in the TRE.

Once access has been granted to the test environemnt in the eidf147 project, the user can pull a container from their private GHCR repository using the `ces-pull` command:

```sh
ces-pull [<runtime>] <github_user> <ghcr_token> ghcr.io/<namespace>/<container_name>:<container_tag>
```

If a runtime is not specified then podman is used as the default.

The container can then be run with `ces-run`:

```sh
ces-run [<runtime>] ghcr.io/<namespace>/<container_name>:<container_tag>
```

`ces-run` supports the following optional arguments under most runtimes:

- Use `--opt-file=<file>` to specify a file containing additional options to be passed to the runtime
- Use `--arg-file=<file>` to specify a file containing arguments to pass to the container command or entrypoint
- Use `--env-file=<file>` to specify a file containing environment variables which will be set inside the container

Containers that require a GPU can be run by adding the `--gpu` option. See `ces-run [<runtime>] --help` for all available options.

We recommend to test containers without network connection to best mimick their functionality inside the TRE, where the container will not be able to access the internet. With Podman, for example, this can be achieved by passing the option `--network=none` through the `opt-file`.

Once the container runs successfully in the test environment, it is ready to be used inside the TRE.

## Step 4. Pull and run container inside the TRE

To use the containers inside the TRE, log into the desired VM using the steps described in the EIDF User Documentation: <https://docs.eidf.ac.uk/safe-haven-services/safe-haven-access/>

The same steps described in [Section 3.2](#32-pull-and-run) of this document can then be used to pull and run the container.
