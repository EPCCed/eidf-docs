# Continuous Integration and Continuous Deployment (CI/CD) with EIDF GitLab

## GitLab Harbor Integration and the ECIR

We recommend that users set up Harbor Integration to automate the use of the EIDF Container Image Registry (ECIR) as the pull and push location for container images.
The ECIR is recommended as it is part of EIDF infrastructure and hence provides speed over external registries as well as a number of built-in security features such as software bills of materials (SBOMs) and security scanning via Trivy.
More documentation around the ECIR can be found in the [ECIR documentation](../registry/index.md) and the [ECIR working with documentation](../registry/working-with.md).

We assume users have set up an ECIR project and ECIR push robot account for the project which can be done by contacting the [EIDF Helpdesk](https://portal.eidf.ac.uk/queries/submit).

Users should follow the [GitLab documentation on Harbor Integration](https://docs.gitlab.com/user/project/integrations/harbor/), making note of the following values to be input:

- Harbor URL: `https://registry.eidf.ac.uk`
- Harbor Project Name: Typically the same as the EIDF project you are working in e.g. `eidf123`
- Username: The username of the Push Robot for your ECIR project, typically has a name like `eidf123-push-robot`
- Password: The secret key of the push robot

## Using an ECIR image in GitLab CI/CD

The ECIR is a private registry and so the use of images stored in the ECIR requires authentication. A number of methods for this are documented in the [GitLab documentation](https://docs.gitlab.com/ci/docker/using_docker_images/#access-an-image-from-a-private-container-registry). We recommend setting up a variable defining the `DOCKER_AUTH_CONFIG` as described in the GitLab documentation above. When making use of the Harbor Integration this variable should be set as follows:

```.gitlab-ci.yml
variables:
  DOCKER_AUTH_CONFIG: "{\"auths\":{\"$HARBOR_HOST\":{\"username\":\"$HARBOR_USERNAME\",\"password\":\"$HARBOR_PASSWORD\"}}}"
```

This will then authorise you to make use of the ECIR in your CI/CD pipelines, for example by pulling an image from the ECIR as the image for a job:

```.gitlab-ci.yml

variables:
  DOCKER_AUTH_CONFIG: "{\"auths\":{\"$HARBOR_HOST\":{\"username\":\"$HARBOR_USERNAME\",\"password\":\"$HARBOR_PASSWORD\"}}}"

my-job:
  image: $HARBOR_HOST/$HARBOR_PROJECT/hello-world:latest
  script:
    - echo "This job uses an image from the ECIR"
```

## Building a Container Image with GitLab CI/CD

Automation of building of container images is possible using GitLab CI/CD in the default GitLab Instance runner.

Images can be built from a Dockerfile using [BuildKit](https://docs.docker.com/build/buildkit/). This requires users to include a stage in the .gitlab-ci.yml using the following template, taking special note of replacing parts in `< >` and if not using Harbor integration ensuring the Environment Variables are set correctly:

```.gitlab-ci.yml
build-rootless:
  image:
    name: moby/buildkit:rootless
  stage: build
  variables:
    BUILDKITD_FLAGS: --oci-worker-no-process-sandbox
    REG_IMAGE: "$HARBOR_HOST/$HARBOR_PROJECT/<image-name>:$CI_COMMIT_SHA"
  before_script:
    - mkdir -p ~/.docker
    - echo "{\"auths\":{\"$HARBOR_HOST\":{\"username\":\"$HARBOR_USERNAME\",\"password\":\"$HARBOR_PASSWORD\"}}}" > ~/.docker/config.json
  script:
    - |
      buildctl-daemonless.sh build \
        --frontend dockerfile.v0 \
        --local context=. \
        --local dockerfile=<. or Dockerfile path to use> \
        --output type=image,name=$REG_IMAGE,push=true
```

This will build an image using the specified Dockerfile and push it to the specified registry. The template is lightly adapted from the GitLab documentation on [building and pushing Docker images with BuildKit](https://docs.gitlab.com/ee/ci/docker/using_docker_buildx.html#build-and-push-docker-images-with-buildkit) where more examples and details can be found.
