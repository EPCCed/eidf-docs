# Using Containers in the SHS GPU Cluster

Once you have built and tested your container, you are ready to start using it within the SHS.

!!! warning "Do not use container CLIs directly"
    The CES wrapper scripts **must** be used to download containers in the SHS. This is to ensure that the correct data directories are automatically made available.

    You **must not** use commands such as `podman pull ...` or `docker pull ...` directly.

## Pulling a container into the SHS

Unlike some other platforms (e.g. the EIDF, where the EIDF GPU Service can automatically pull images), in the SHS you must first **manually pull the container** onto the SHS desktop VM using the CES tools before you can run jobs on the SHS GPU Cluster. This ensures that the correct security and data-access controls are applied consistently.

Containers can only be downloaded on the SHS desktop hosts using `ces-tools`; and containers can only be pulled from the GitHub Container Registry (GHCR) into the SHS using a `ces-pull` script. Hence containers must be pushed to GHCR for them to be used in the SHS.

As use of containers in the SHS is a new service, it is at this stage regarded as an activity that requires additional security controls. Researcher accounts must be explicitly enabled for use of the `ces-pull` command through Information Governance approval.

To pull a private image, you must create an access token to authenticate with GHCR (see [Authenticating to the container registry](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry#authenticating-to-the-container-registry)). The container is then pulled by the user with the following command:

```bash
ces-pull [<runtime>] <github_user> <ghcr_token> ghcr.io/<namespace>/<container_name>:<container_tag>
```

Note: <gitlab_user> is a GitHub user name, <ghcr_token> is a GitHub access token with 'read:packages' scope that allows access to the image 'ghcr.io//:'. When pulling containers into the SHS, instead of using the GitHub access token you used to push the container, it is recommended you use a GitHub access token with 'read:packages' scope only. Restricting where you use your read-write token can keep your GHCR secure.

Note: The <github_user> and <ghcr_token> arguments to ces-pull are mandatory.

If a runtime is not specified then podman is used as the default.

Once the container image has been pulled into the SHS desktop host, the image can be managed with Podman commands.

## Using the container in the SHS GPU Cluster Jobs

Once the container is pulled, verify with the following commande:

```bash
podman images
```

An example output is as follows:

```text
REPOSITORY                                           TAG               IMAGE ID      CREATED      SIZE
ghcr.io/<github_user>/cuda-sample                      nbody-cuda11.7.1  06d607b1fa6f  2 years ago  324 MB
tre-ghcr-proxy.nsh.loc:5000/<github_user>/cuda-sample  nbody-cuda11.7.1  06d607b1fa6f  2 years ago  324 MB
```

### Job Definition in the SHS GPU Cluster

In your SHS GPU Job definition, you must use the local proxy registry path in the `image:` field, like this:

```yaml
image: tre-ghcr-proxy.nsh.loc:5000/<github_user>/cuda-sample:nbody-cuda11.7.1
```

!!! warning "Only use local registry path"
    This is required because GPU nodes only have access to the local `tre-ghcr-proxy.nsh.loc` registry (not the public internet).
