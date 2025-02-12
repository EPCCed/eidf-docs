# Using Containers in the TRE

Once you have built and tested your container, you are ready to start using it within the TRE.

!!! warning "Do not use container CLIs directly"
    The CES wrapper scripts **must** be used to run containers in the TRE. This is to ensure that the correct data directories are automatically made available.

    You **must not** use commands such as `podman run ...` or `docker run ...` directly.

## Pulling a container into the TRE

Containers can only be used on the TRE desktop hosts using shell commands. And containers can only be pulled from the GitHub Container Registry (GHCR) into the TRE using a `ces-pull` script. Hence containers must be pushed to GHCR for them to be used in the TRE.

As use of containers in the TRE is a new service, it is at this stage regarded as an activity that requires additional security controls. Researcher accounts must be explicitly enabled for use of the `ces-pull` command through IG approval.

To pull a private image, you must create an access token to authenticate with GHCR (see [Authenticating to the container registry](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry#authenticating-to-the-container-registry)). The container is then pulled by the user with the command:

```bash
ces-pull <github_user> <github_token> ghcr.io/<namespace>/<container_name>[:<container_tag>]
```

To pull a public image, which does not require authenticating with username and token, pass two empty strings:

```bash
ces-pull "" "" ghcr.io/<namespace>/<container_name>[:<container_tag>]
```

Once the container image has been pulled into the TRE desktop host, the image can be managed with Podman commands. However, containers must not be run directly using Podman. Instead, commands developed for use within the TRE must be used as will now be described.

## Running the container in the TRE

Containers may be run in the TRE using one of two commands: use `ces-gpu-run` if a GPU is to be connected to the container, otherwise use the `ces-run` command. The basic command to start a container is one of:

```bash
ces-run ghcr.io/<namespace>/<container_name>[:<container_tag>]
```

or, if your container requires a GPU:

```bash
ces-gpu-run ghcr.io/<namespace>/<container_name>[:<container_tag>]
```

Each command supports a number of options to control resource allocation and to pass parameters to the podman run command and to the container itself. Each command has a help option to output the following information:

```bash
Usage:
ces-run [options] <container>
Available Options:
-c|--cores          CPU cores to allocate (default is sharing all of them)
--dry-run           Do not run the container, print out all the command options
--env-file          File with env vars to pass to container
-h|--help           Print this stuff
-m|--memory         Memory to allocate in Gb (default is 4Gb)
-n|--name           Assign a name to the container
--opt-file          File with additional options to pass to run command
-v|--verbose        Print out all command options
--version           Print out version string
```

The `--env-file` and `--opt-file` arguments can be used to extend the command-line script that is executed when the container is started. The `--env-file` option is exactly the docker and podman run option with the file containing lines of the form `Variable=Value`. See the [Docker option reference](https://docs.docker.com/reference/cli/docker/container/run/#env)

The `--opt-file` option allows you to have a file containing additional arguments to the `ces-run` and `ces-gpu-run` command.
