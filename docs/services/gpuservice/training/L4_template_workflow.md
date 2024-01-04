# Template workflow

An example workflow for code development using K8s is outlined below.

The workflow requires a GitHub account and GitHub Actions for CI/CD, (this can be adapted for other platforms such as GitLab).

The workflow is separated into three sections:

1. Data Loading

1. Preparing a custom Docker image

1. Code development with K8s

## Data loading

### Create a persistent volume

Request memory from the Ceph server by submitting a PVC to K8s (example pvc spec yaml below).

``` bash
kubectl create -f <pvc-spec-yaml>
```

#### Example PersistentVolumeClaim

``` yaml
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
 name: template-workflow-pvc
spec:
 accessModes:
  - ReadWriteOnce
 resources:
  requests:
   storage: 100Gi
 storageClassName: csi-rbd-sc
```

### Create a lightweight pod to tranfer data to the persistent volume

1. Check PVC has been created

    ``` bash
    kubectl get pvc <pv-name>
    ```

1. Create a lightweight pod with PV mounted (example pod below)

    ``` bash
    kubectl create -f lightweight-pod.yaml
    ```

1. Download data set (If the data set download time is estimated to be hours or days you may want to run this code within a [screen](https://www.gnu.org/software/screen/manual/screen.html) instance on your VM so you can track the progress asynchronously)

    ``` bash
    kubectl exec lightweight-pod -- curl <dataset-web-address> /mnt/ceph_rbd/<dataset_name>
    ```

1. Delete lightweight pod

    ``` bash
    kubectl delete pod lightweight-pod
    ```

#### Example lightweight pod specification

``` yaml
apiVersion: v1
kind: Pod
metadata:
 name: lightweight-pod
spec:
 containers:
 - name: data-loader
   image: alpine/curl:latest
   command: ["sleep", "infinity"]
   resources:
    requests:
     cpu: 1
     memory: "1Gi"
    limits:
     cpu: 1
     memory: "1Gi"
   volumeMounts:
   - mountPath: /mnt/ceph_rbd
     name: volume
 volumes:
 - name: volume
   persistentVolumeClaim:
    claimName: template-workflow-pvc
```

## Preparing a custom Docker image

Kubernetes requires Docker images to be pre-built and available for download from a container repository such as Docker Hub. Typical use cases require some custom modifications of a base image.

1. Select a suitable base image (The [Nvidia container catalog](https://catalog.ngc.nvidia.com/containers) is often a useful starting place for GPU accelerated tasks)

1. Create a [Dockerfile](https://docs.docker.com/engine/reference/builder/) to add any additional packages required to the base image

    ```txt
    FROM nvcr.io/nvidia/rapidsai/base:23.12-cuda12.0-py3.10
    RUN pip install pandas
    RUN pip install scikit-learn
    ```

1. Build the Docker container locally or on a VM (You will need to install [Docker](https://docs.docker.com/))

    ```bash
    docker build <Dockerfile>
    ```

1. Push Docker image to Docker Hub (You will need to create and setup an account)

    ```bash
    docker push template-docker-image
    ```

## Code development with K8s

A rapid development cycle from code writing to testing requires some initial setup within k8s.

The first step is to automatically pull the latest code version before running any tests in a pod.

This allows development to be conducted on any device/VM with access to the repo (GitHub/GitLab) and testing to be completed on the cluster with just one `kubectl create` command.

This allows custom code/models to be prototyped on the cluster, but typically within a standard base image.

However, if the Docker container also needs to be developed then GitHub actions can be used to automatically build a new image and publish it to Docker Hub if any changes to a Dockerfile is detected.

A template GitHub repo with sample code, k8s yaml files and github actions is available [here](https://github.com/DimmestP/template-EIDFGPU-workflow).

### Create a job that downloads and runs the latest code version at runtime

1. Write a standard yaml file for a k8s job with the required resources and custom docker image (example below)

    ```yaml
    apiVersion: batch/v1
    kind: Job
    metadata:
     name: template-workflow-job
    spec:
     completions: 1
     parallelism: 1
     template:
      spec:
       restartPolicy: Never
       containers:
       - name: template-docker-image
         image: <dockerhub-user>/template-docker-image:latest
         command: ["sleep", "infinity"]
         resources:
          requests:
           cpu: 10
           memory: "40Gi"
          limits:
           cpu: 10
           memory: "80Gi"
           nvidia.com/gpu: 1
         volumeMounts:
         - mountPath: /mnt/ceph_rbd
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
     name: template-workflow-job
    spec:
     completions: 1
     parallelism: 1
     template:
      spec:
       restartPolicy: Never
       containers:
       - name: template-docker-image
         image: <dockerhub-user>/template-docker-image:latest
         command: ["sleep", "infinity"]
         resources:
          requests:
           cpu: 10
           memory: "40Gi"
          limits:
           cpu: 10
           memory: "80Gi"
           nvidia.com/gpu: 1
         volumeMounts:
         - mountPath: /mnt/ceph_rbd
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
          claimName: benchmark-imagenet-pvc
       - name: github-code
         emptyDir:
          sizeLimit: 1Gi
    ```

1. Change the command argument in the main container to run the code once started.

    ```yaml
    apiVersion: batch/v1
    kind: Job
    metadata:
     name: template-workflow-job
    spec:
     completions: 1
     parallelism: 1
     template:
      spec:
       restartPolicy: Never
       containers:
       - name: template-docker-image
         image: <dockerhub-user>/template-docker-image:latest
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
         - mountPath: /mnt/ceph_rbd
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
          claimName: benchmark-imagenet-pvc
       - name: github-code
         emptyDir:
          sizeLimit: 1Gi
    ```

1. Submit the yaml file to kubernetes

    ```bash
    kubectl create -f <job-yaml-file>
    ```

### Setup GitHub actions to build and publish any changes to a Dockerfile

1. Create two [GitHub secrets](https://docs.github.com/en/actions/security-guides/using-secrets-in-github-actions) to securely provide your Docker Hub username and access token.

1. Add the Dockerfile to a code/docker folder within the active GitHub repo

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
