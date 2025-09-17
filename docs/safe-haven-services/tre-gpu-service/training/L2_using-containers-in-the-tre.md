# Using Containers in the TRE GPU Cluster

Once you have built and tested your container, you are ready to start using it within the TRE.

!!! warning "Do not use container CLIs directly"
    The CES wrapper scripts **must** be used to download containers in the TRE. This is to ensure that the correct data directories are automatically made available.

    You **must not** use commands such as `podman pull ...` or `docker pull ...` directly.

## Pulling a container into the TRE

Containers can only be downloaded on the TRE desktop hosts using shell commands. And containers can only be pulled from the GitHub Container Registry (GHCR) into the TRE using a `ces-pull` script. Hence containers must be pushed to GHCR for them to be used in the TRE.

As use of containers in the TRE is a new service, it is at this stage regarded as an activity that requires additional security controls. Researcher accounts must be explicitly enabled for use of the `ces-pull` command through IG approval.

To pull a private image, you must create an access token to authenticate with GHCR (see [Authenticating to the container registry](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry#authenticating-to-the-container-registry)). The container is then pulled by the user with the command:

```bash
ces-pull <github_user> <github_token> ghcr.io/<namespace>/<container_name>[:<container_tag>]
```

To pull a public image, which does not require authenticating with username and token, pass two empty strings:

```bash
ces-pull "" "" ghcr.io/<namespace>/<container_name>[:<container_tag>]
```

Once the container image has been pulled into the TRE desktop host, the image can be managed with Podman commands.

## Using the container in the TRE GPU Cluster Jobs

Once the container is pulled, verify with:

```bash
podman images
```

Example output:

```text
REPOSITORY                                           TAG               IMAGE ID      CREATED      SIZE
ghcr.io/<github_user>/cuda-sample                      nbody-cuda11.7.1  06d607b1fa6f  2 years ago  324 MB
tre-ghcr-proxy.nsh.loc:5000/<github_user>/cuda-sample  nbody-cuda11.7.1  06d607b1fa6f  2 years ago  324 MB
```

### Job Definition in TRE GPU

In your TRE GPU Job definition, you must use the local proxy registry path in the `image:` field, like this:

```yaml
image: tre-ghcr-proxy.nsh.loc:5000/<github_user>/cuda-sample:nbody-cuda11.7.1
```

!!! warning "Only use local registry path"
    This is required because GPU nodes only have access to the local `tre-ghcr-proxy.nsh.loc` registry (not the public internet).
