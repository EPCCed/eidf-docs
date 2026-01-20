# Template workflow

## Requirements

It is recommended that users complete [Getting started with Kubernetes](../training/L1_getting_started.md) and [Requesting persistent volumes With Kubernetes](../training/L4_requesting_persistent_volumes.md) before proceeding with this tutorial.

## Overview

An example workflow for code development using K8s is outlined below.

In theory, users can create docker images with all the code, software and data included to complete their analysis.

In practice, docker images with the required software can be several gigabytes in size which can lead to unacceptable download times when ~100GB of data and code is then added.

Therefore, it is recommended to separate code, software, and data preparation into distinct steps:

1. Data Loading: Loading large data sets asynchronously.

1. Developing a Docker environment: Manually or automatically building Docker images.

1. Code development with K8s: Iteratively changing and testing code in a job.

The workflow describes different strategies to tackle the three common stages in code development and analysis using the SHS GPU Cluster.

The three stages are interchangeable and may not be relevant to every project.

Some strategies in the workflow require a [GitHub](https://github.com) account and [Docker Hub](https://hub.docker.com/) account for automatic building (this can be adapted for other platforms such as GitLab).

## Data loading

The SHS GPU Cluster contains GPUs with 40Gb/80Gb of on board memory and it is expected that data sets of > 100 Gb will be loaded onto the service to utilise this hardware.

Persistent volume claims need to be of sufficient size to hold the input data, any expected output data and a small amount of additional empty space to facilitate IO.

Read the [requesting persistent volumes with Kubernetes](L4_requesting_persistent_volumes.md) lesson to learn how to request and mount persistent volumes to pods.

It often takes several hours or days to download data sets of 1/2 TB or more to a persistent volume.

Therefore, the data download step needs to be completed asynchronously as maintaining a contention to the server for long periods of time can be unreliable.

### Asynchronous data downloading with a lightweight job

1. Check a PVC has been created.

    ``` bash
    kubectl -n <project-namespace> get pvc template-workflow-pvc
    ```

1. Write a job yaml with PV mounted and a command to download the data. Change the curl URL to your data set of interest.

    ``` yaml
    apiVersion: batch/v1
    kind: Job
    metadata:
     generateName: lightweight-job-
     labels:
      kueue.x-k8s.io/queue-name: <project-namespace>-user-queue
    spec:
     completions: 1
     backoffLimit: 1
     parallelism: 1
     ttlSecondsAfterFinished: 1800
     template:
      metadata:
       name: lightweight-job
      spec:
       restartPolicy: Never
       containers:
       - name: data-loader
         image: alpine/curl:latest
         command: ['sh', '-c', "cd /mnt/ceph; curl https://archive.ics.uci.edu/static/public/53/iris.zip -o iris.zip"]
         resources:
          requests:
           cpu: 1
           memory: "1Gi"
          limits:
           cpu: 1
           memory: "1Gi"
         volumeMounts:
         - mountPath: /mnt/ceph
           name: volume
       volumes:
       - name: volume
         persistentVolumeClaim:
          claimName: template-workflow-pvc
    ```

1. Run the data download job.

    ``` bash
    kubectl -n <project-namespace> create -f lightweight-pod.yaml
    ```

1. Check if the download has completed.

    ``` bash
    kubectl -n <project-namespace> get jobs
    ```

1. Delete the lightweight job once completed.

    ``` bash
    kubectl -n <project-namespace> delete job lightweight-job
    ```

### Asynchronous data downloading within a screen session

[Screen](https://www.gnu.org/software/screen/manual/screen.html#Overview) is a window manager available in Linux that allows you to create multiple interactive shells and swap between then.

Screen has the added benefit that if your remote session is interrupted the screen session persists and can be reattached when you manage to reconnect.

This allows you to start a task, such as downloading a data set, and check in on it asynchronously.

Once you have started a screen session, you can create a new window with `ctrl-a c`, swap between windows with `ctrl-a 0-9` and exit screen (but keep any task running) with `ctrl-a d`.

Using screen rather than a single download job can be helpful if downloading multiple data sets or if you intend to do some simple QC or tidying up before/after downloading.

1. Start a screen session.

    ```bash
    screen
    ```

1. Create an interactive lightweight job session.

    ``` yaml
    apiVersion: batch/v1
    kind: Job
    metadata:
     generateName: lightweight-job-
     labels:
      kueue.x-k8s.io/queue-name: <project-namespace>-user-queue
    spec:
     completions: 1
     backoffLimit: 1
     parallelism: 1
     ttlSecondsAfterFinished: 1800
     template:
      metadata:
       name: lightweight-pod
      spec:
       restartPolicy: Never
       containers:
       - name: data-loader
         image: alpine/curl:latest
         command: ['sleep','infinity']
         resources:
          requests:
           cpu: 1
           memory: "1Gi"
          limits:
           cpu: 1
           memory: "1Gi"
         volumeMounts:
         - mountPath: /mnt/ceph
           name: volume
       volumes:
       - name: volume
         persistentVolumeClaim:
          claimName: template-workflow-pvc
    ```

1. Download data set. Change the curl URL to your data set of interest.

    ``` bash
    kubectl -n <project-namespace> exec <lightweight-pod-name> -- curl https://archive.ics.uci.edu/static/public/53/iris.zip -o /mnt/ceph_rbd/iris.zip
    ```

1. Exit the remote session by either ending the session or `ctrl-a d`.

1. Reconnect at a later time and reattach the screen window.

    ```bash
    screen -list

    screen -r <session-name>
    ```

1. Check the download was successful and delete the job.

    ```bash
    kubectl -n <project-namespace> exec <lightweight-pod-name> -- ls /mnt/ceph_rbd/

    kubectl -n <project-namespace> delete job lightweight-job
    ```

1. Exit the screen session.

    ```bash
    exit
    ```

## Preparing a custom Docker image

Kubernetes requires Docker images to be pre-built and available for download from a container repository such as Docker Hub.

It does not provide functionality to build images and create pods from docker files.

However, use cases may require some custom modifications of a base image, such as adding a python library.

These custom images need to be built locally (using docker) or online (using a GitHub/GitLab worker) and pushed to a repository such as Docker Hub.

This is not an introduction to building docker images, please see the [Docker tutorial](https://docs.docker.com/get-started/)  for a general overview.

### Manually building a Docker image locally

1. Select a suitable base image (The [Nvidia container catalog](https://catalog.ngc.nvidia.com/containers) is often a useful starting place for GPU accelerated tasks). We'll use the base [RAPIDS image](https://catalog.ngc.nvidia.com/orgs/nvidia/teams/rapidsai/containers/base).

1. Create a [Dockerfile](https://docs.docker.com/engine/reference/builder/) to add any additional packages required to the base image.

    ```txt
    FROM nvcr.io/nvidia/rapidsai/base:23.12-cuda12.0-py3.10
    RUN pip install pandas
    RUN pip install plotly
    ```

1. Build the Docker container locally (You will need to install [Docker](https://docs.docker.com/))

    ```bash
    cd <dockerfile-folder>

    docker build . -t <docker-hub-username>/template-docker-image:latest
    ```

!!! important "Building images for different CPU architectures"
    Be aware that docker images built for Apple ARM64 architectures will not function optimally on the SHS GPU Cluster's AMD64 based architecture.

    If building docker images locally on an Apple device you must tell the docker daemon to use AMD64 based images by passing the `--platform linux/amd64` flag to the build function.

1. Create a repository to hold the image on [Docker Hub](https://hub.docker.com) (You will need to create and setup an account).

1. Push the Docker image to the repository.

    ```bash
    docker push <docker-hub-username>/template-docker-image:latest
    ```

1. Finally, specify your Docker image in the `image:` tag of the job specification yaml file.

    ```yaml
    apiVersion: batch/v1
    kind: Job
    metadata:
     generateName: template-workflow-job
     labels:
      kueue.x-k8s.io/queue-name: <project-namespace>-user-queue
    spec:
     completions: 1
     parallelism: 1
     template:
      spec:
       restartPolicy: Never
       containers:
       - name: template-docker-image
         image: <docker-hub-username>/template-docker-image:latest
         command: ["sleep", "infinity"]
         resources:
          requests:
           cpu: 1
           memory: "4Gi"
          limits:
           cpu: 1
           memory: "8Gi"
    ```

### Automatically building docker images using GitHub Actions

In cases where the Docker image needs to be built and tested iteratively (i.e. to check for comparability issues), git version control and [GitHub Actions](https://github.com/features/actions) can simplify the build process.

A GitHub action can build and push a Docker image to Docker Hub whenever it detects a git push that changes the docker file in a git repo.

This process requires you to already have a [GitHub](https://github.com) and [Docker Hub](https://hub.docker.com) account.

1. Create an [access token](https://docs.docker.com/security/for-developers/access-tokens/) on your Docker Hub account to allow GitHub to push changes to the Docker Hub image repo.

1. Create two [GitHub secrets](https://docs.github.com/en/actions/security-guides/using-secrets-in-github-actions) to securely provide your Docker Hub username and access token.

1. Add the dockerfile to a code/docker folder within an active GitHub repo.

1. Add the GitHub action yaml file below to the .github/workflow folder to automatically push a new image to Docker Hub if any changes to files in the code/docker folder is detected.

    ```yaml
    name: ci
    on:
      push:
        paths:
          - 'code/docker/**'

    jobs:
      docker:
        runs-on: ubuntu-latest
        steps:
          -
            name: Set up QEMU
            uses: docker/setup-qemu-action@v3
          -
            name: Set up Docker Buildx
            uses: docker/setup-buildx-action@v3
          -
            name: Login to Docker Hub
            uses: docker/login-action@v3
            with:
              username: ${{ secrets.DOCKERHUB_USERNAME }}
              password: ${{ secrets.DOCKERHUB_TOKEN }}
          -
            name: Build and push
            uses: docker/build-push-action@v5
            with:
              context: "{{defaultContext}}:code/docker"
              push: true
              tags: <target-dockerhub-image-name>
    ```

1. Push a change to the dockerfile and check the Docker Hub image is updated.

## Code development with K8s

Production code can be included within a Docker image to aid reproducibility as the specific software versions required to run the code are packaged together.

However, binding the code to the docker image during development can delay the testing cycle as re-downloading all of the software for every change in a code block can take time.

If the docker image is consistent across tests, then it can be cached locally on the SHS GPU Cluster instead of being re-downloaded (this occurs automatically although the cache is node specific and is not shared across nodes).

A pod yaml file can be defined to automatically pull the latest code version before running any tests.

Reducing the download time to fractions of a second allows rapid testing to be completed on the cluster with just the `kubectl create` command.

You must already have a [GitHub](https://github.com) account to follow this process.

This process allows code development to be conducted on any device/VM with access to the repo (GitHub/GitLab).

A template GitHub repo with sample code, k8s yaml files and a Docker build Github Action is available in [in our user documentation](https://github.com/EPCCed/template-EIDFGPU-workflow).

### Create a job that downloads and runs the latest code version at runtime

1. Write a standard yaml file for a k8s job with the required resources and custom docker image (example below)

    ```yaml
    apiVersion: batch/v1
    kind: Job
    metadata:
     generateName: template-workflow-job-
     labels:
      kueue.x-k8s.io/queue-name: <project-namespace>-user-queue
    spec:
     completions: 1
     parallelism: 1
     template:
      spec:
       restartPolicy: Never
       containers:
       - name: template-docker-image
         image: <docker-hub-username>/template-docker-image:latest
         command: ["sleep", "infinity"]
         resources:
          requests:
           cpu: 1
           memory: "4Gi"
          limits:
           cpu: 1
           memory: "8Gi"
         volumeMounts:
         - mountPath: /mnt/ceph
           name: volume
       volumes:
       - name: volume
         persistentVolumeClaim:
          claimName: template-workflow-pvc
    ```

1. Add an initial container that runs before the main container to download the latest version of the code.

    ```yaml
    apiVersion: batch/v1
    kind: Job
    metadata:
     generateName: template-workflow-job-
     labels:
      kueue.x-k8s.io/queue-name: <project-namespace>-user-queue
    spec:
     completions: 1
     parallelism: 1
     template:
      spec:
       restartPolicy: Never
       containers:
       - name: template-docker-image
         image: <docker-hub-username>/template-docker-image:latest
         command: ["sleep", "infinity"]
         resources:
          requests:
           cpu: 1
           memory: "4Gi"
          limits:
           cpu: 1
           memory: "8Gi"
         volumeMounts:
         - mountPath: /mnt/ceph
           name: volume
         - mountPath: /code
           name: github-code
       initContainers:
       - name: lightweight-git-container
         image: cicirello/alpine-plus-plus
         command: ['sh', '-c', "cd /code; git clone <target-repo>"]
         resources:
          requests:
           cpu: 1
           memory: "4Gi"
          limits:
           cpu: 1
           memory: "8Gi"
         volumeMounts:
         - mountPath: /code
           name: github-code
       volumes:
       - name: volume
         persistentVolumeClaim:
          claimName: template-workflow-pvc
       - name: github-code
         emptyDir:
          sizeLimit: 1Gi
    ```

1. Change the command argument in the main container to run the code once started. Add the URL of the GitHub repo of interest to the `initContainers: command:` tag.

    ```yaml
    apiVersion: batch/v1
    kind: Job
    metadata:
     generateName: template-workflow-job-
     labels:
      kueue.x-k8s.io/queue-name: <project-namespace>-user-queue
    spec:
     completions: 1
     parallelism: 1
     template:
      spec:
       restartPolicy: Never
       containers:
       - name: template-docker-image
         image: <docker-hub-username>/template-docker-image:latest
         command: ['sh', '-c', "python3 /code/<python-script>"]
         resources:
          requests:
           cpu: 10
           memory: "40Gi"
          limits:
           cpu: 10
           memory: "80Gi"
           nvidia.com/gpu: 1
         volumeMounts:
         - mountPath: /mnt/ceph
           name: volume
         - mountPath: /code
           name: github-code
       initContainers:
       - name: lightweight-git-container
         image: cicirello/alpine-plus-plus
         command: ['sh', '-c', "cd /code; git clone <target-repo>"]
         resources:
          requests:
           cpu: 1
           memory: "4Gi"
          limits:
           cpu: 1
           memory: "8Gi"
         volumeMounts:
         - mountPath: /code
           name: github-code
       volumes:
       - name: volume
         persistentVolumeClaim:
          claimName: template-workflow-pvc
       - name: github-code
         emptyDir:
          sizeLimit: 1Gi
    ```

1. Submit the yaml file to kubernetes

    ```bash
    kubectl -n <project-namespace> create -f <job-yaml-file>
    ```
