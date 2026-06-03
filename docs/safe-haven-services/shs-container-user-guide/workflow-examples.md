# Workflow Examples

These examples will help guide you in the process of creating different types of containers.

For a complete list of examples, please see our SHS Container Samples repository, at [EPCCed/shs-container-samples](https://github.com/EPCCed/tre-container-samples).

## Example 1 - PyTorch

This section will explain how to create a container that runs a script using PyTorch inside the SHS. The expected directory structure is:

```console
  ├── Dockerfile
  ├── requirements.txt
  ├── torch_gpu_test.py
```

where `requirements.txt` contains:

```console
numpy
torch
```

and `torch_gpy_test.py` is any script that performs a simple task using PyTorch.

### Example 1 - Step 1. Writing a Dockerfile

In our Dockerfile, we want to start by using an officially supported image that already contains as much of the software required to run the script as possible.

In our case, we want a ready-made Python 3 image to start with, which we can find in [DockerHub](https://hub.docker.com/search?q=python). The latest stable version at the time of writing is [3.13.3](https://hub.docker.com/layers/library/python/3.13.3/images/sha256-981c77781aa563fc22ee5936fdd37e16679e3b28d32351430a6aede491f6e8b1), so we will use this and include the digest in our Dockerfile.

Next, we need to set up the SHS directories, copy our files into the container, install the necessary packages and finally execute the script. This process can be accomplished with the following Dockerfile:

``` Dockerfile
FROM python:3.13.3@sha256:a4b2b11a9faf847c52ad07f5e0d4f34da59bad9d8589b8f2c476165d94c6b377

# Create SHS directories
RUN mkdir /safe_data /safe_outputs /scratch

WORKDIR /usr/app
COPY requirements.txt ./

# Use hadolint ignore=DL3013 when linting this Dockerfile.
RUN pip install --no-cache-dir --upgrade pip  && \
    pip install --no-cache-dir -r requirements.txt

COPY torch_gpu_test.py .

CMD ["python", "./torch_gpu_test.py"]
```

### Example 1 - Step 2. Build, test locally and push to registry

As mentioned in our container development workflow, it is good practice to check the Dockerfile with a linting tool to detect common mistakes before building our container:

```sh
# Ignore DL3013 to allow --upgrade
docker run --pull always --rm -i docker.io/hadolint/hadolint:latest hadolint --ignore DL3013 - < Dockerfile
```

Here we deliberately ignore hadolint flags if the selected features are required by the container to run successfully.

We can then define our GitLab Container Registry (GHCR) variables, where `GHCR_TOKEN` needs to be a GitHub access token with 'repo' and 'write:packages' scope:

```sh
export GHCR_NAMESPACE=mynamespace
export GHCR_TOKEN=mytoken
```

We can now build our container:

```sh
docker build . --tag ghcr.io/$GHCR_NAMESPACE/pytorch-test:v1.1 --tag ghcr.io/$GHCR_NAMESPACE/pytorch-test:latest --platform linux/amd64
```

and run it locally:

```sh
docker run --rm ghcr.io/$GHCR_NAMESPACE/pytorch-test:v1.1
```

If the container runs without errors, we can push our image to GHCR using our namespace and token:

```sh
echo "${GHCR_TOKEN}" | docker login ghcr.io -u $GHCR_NAMESPACE --password-stdin
docker push "ghcr.io/$GHCR_NAMESPACE/pytorch-test:v1.1"
docker push "ghcr.io/$GHCR_NAMESPACE/pytorch-test:latest"
docker logout
```

### Example 1 - Step 3. Pull and run container inside the CES test VM

To test the container inside the CES test VM, first log into the CES test VM following [Accessing EIDF](../../../access).

Pull the container using the following command, where both the `$GHCR_NAMESPACE` and `$GHCR_TOKEN` arguments to `ces-pull` are mandatory:

```sh
ces-pull podman $GHCR_NAMESPACE $GHCR_TOKEN ghcr.io/$GHCR_NAMESPACE/pytorch-test:v1.1
```

!!! tip

    When pulling containers into the SHS, instead of using the GitHub access token you used to push the container, it is **recommended** you use a GitHub access token with 'read:packages' scope only. Restricting where you use your read-write token can keep your GHCR secure.

Now run the container using the following command:

```sh
ces-run podman --gpu ghcr.io/$GHCR_NAMESPACE/pytorch-test:v1.1
```

### Example 1 - Step 4. Pull and run container inside your Safe Haven

The container can be pulled and run inside the SHS using the same commands as in the [previous step](#example-1-step-3-pull-and-run-container-inside-the-ces-test-vm).

## Example 2 - Python ML

This example demonstrates how to build a container which requires a machine learning (ML) model that would normally be downloaded from the internet when first run.

Such models are typically cached in a hidden directory so it can be difficult to understand how to manually download the model, where to put it, and how to load it.

The approach we take is to run a sample piece of code during the container build phase, which downloads the model to the hidden cache directory. This then becomes part of the container.

The expected directory structure is:

```console
  ├── Dockerfile
  ├── cache-easyocr.py
  ├── doc1.png
  ├── test_easyocr.py
```

where `cache-easyocr` contains:

```py
#!/usr/bin/env python3

import easyocr
reader = easyocr.Reader(['en'])
```

`test_easyocr.py` is defined as:

```py
#!/usr/bin/env python3

import easyocr
import json
import sys
import shutil

src="/src/"
dst="/safe_outputs/"
reader = easyocr.Reader(['en'])

for filename in sys.argv[1:]:
    print("Processing file: ", filename)
    text_list = reader.readtext(filename)

    entities = []
    for (bbox_list, text, confidence) in text_list:
        print('Found text "%s" with confidence %f at %s' % (text, confidence, bbox_list))
        entities.append({'text': text,
            'confidence': confidence,
            })
    out_file = filename + '.json'
    with open(out_file, 'w') as fd:
        json.dump(entities, fd)
        print(entities)
    shutil.copyfile(out_file, dst + out_file.split("/")[2])
```

and `doc1.png` is an image that contains text.

### Example 2 - Step 1. Writing a Dockerfile

As for the PyTorch example, we will base our Dockerfile on the `python:3` image:

```dockerfile
FROM python:3.13.3@sha256:a4b2b11a9faf847c52ad07f5e0d4f34da59bad9d8589b8f2c476165d94c6b377
```

We then install easyocr and download the HuggingFace ML models:

```dockerfile
RUN pip install easyocr
COPY cache_easyocr.py .
RUN python ./cache_easyocr.py
```

As there is no internet access from within the SHS, we need to make sure that HuggingFace does not attempt to access its hub:

```dockerfile
ENV HF_HUB_OFFLINE=1
```

We can then create the SHS directories, copy the files inside the container and execute the script:

```dockerfile
RUN mkdir /safe_data /safe_outputs /scratch /src
COPY test_easyocr.py doc1.png /src/
ENTRYPOINT [ "python3", "/src/test_easyocr.py", "/src/doc1.png"]
```

The final Dockerfile is:

```dockerfile
FROM python:3.13.3@sha256:a4b2b11a9faf847c52ad07f5e0d4f34da59bad9d8589b8f2c476165d94c6b377

# Install easyocr globally
RUN pip install easyocr

# Download ML models during the build phase
COPY cache_easyocr.py .
RUN python ./cache_easyocr.py

# Set environment variable to prevent HuggingFace hub access
ENV HF_HUB_OFFLINE=1

# Create SHS directories
RUN mkdir /safe_data /safe_outputs /scratch /src
# Copy files inside the container
COPY test_easyocr.py doc1.png /src/
# Run the script with the desired parameters
ENTRYPOINT [ "python3", "/src/test_easyocr.py", "/src/doc1.png"]
```

### Example 2 - Step 2. Build, test locally and push to registry

As mentioned in our container development workflow, it is good practice to check the Dockerfile with a linting tool to detect common mistakes before building our container:

```sh
# Ignore DL3013, DL3042 and DL3045
docker run --pull always --rm -i docker.io/hadolint/hadolint:latest hadolint --ignore DL3013 --ignore DL3042 --ignore DL3045 - < Dockerfile
```

Here we deliberately ignore hadolint flags if the selected features are required by the container to run successfully.

We can then define our GHCR variables, where `GHCR_TOKEN` needs to be a GitHub access token with 'repo' and 'write:packages' scope:

```sh
export GHCR_NAMESPACE=mynamespace
export GHCR_TOKEN=mytoken
```

We can now build our container:

```sh
docker build . --tag ghcr.io/$GHCR_NAMESPACE/python-ml-test:v1.1 --tag ghcr.io/$GHCR_NAMESPACE/python-ml-test:latest --platform linux/amd64
```

and run it locally:

```sh
docker run --rm --network=none test_easyocr ghcr.io/$GHCR_NAMESPACE/python-ml-test:v1.1
```

If successful, we should see an output of this type:

```console
Processing file:  /src/doc1.png
Found text "Apple is looking at buying U.K." with confidence 0.771268 at [[np.int32(1), np.int32(4)], [np.int32(221), np.int32(4)], [np.int32(221), np.int32(25)], [np.int32(1), np.int32(25)]]
Found text "startup" with confidence 0.994821 at [[np.int32(225), np.int32(9)], [np.int32(279), np.int32(9)], [np.int32(279), np.int32(23)], [np.int32(225), np.int32(23)]]
Found text "for" with confidence 0.999294 at [[np.int32(283), np.int32(7)], [np.int32(307), np.int32(7)], [np.int32(307), np.int32(21)], [np.int32(283), np.int32(21)]]
Found text "billion" with confidence 0.999928 at [[np.int32(331), np.int32(7)], [382, np.int32(7)], [382, np.int32(21)], [np.int32(331), np.int32(21)]]
[{'text': 'Apple is looking at buying U.K.', 'confidence': np.float64(0.7712680738082065)}, {'text': 'startup', 'confidence': np.float64(0.9948211556483356)}, {'text': 'for', 'confidence': np.float64(0.9992943653537125)}, {'text': 'billion', 'confidence': np.float64(0.9999277279271659)}]
```

If the container runs without errors, we can push our image to GHCR using our namespace and token:

```sh
echo "${GHCR_TOKEN}" | docker login ghcr.io -u $GHCR_NAMESPACE --password-stdin
docker push "ghcr.io/$GHCR_NAMESPACE/python-ml-test:v1.1"
docker push "ghcr.io/$GHCR_NAMESPACE/python-ml-test:latest"
docker logout
```

### Example 2 - Step 3. Pull and run container inside the CES test VM

To test the container inside the CES test VM, first log into the CES test VM following [Accessing EIDF](../../../access).

Pull the container using the following command, where both the `$GHCR_NAMESPACE` and `$GHCR_TOKEN` arguments to `ces-pull` are mandatory:

```sh
ces-pull podman $GHCR_NAMESPACE $GHCR_TOKEN ghcr.io/$GHCR_NAMESPACE/python-ml-test:v1.1
```

!!! tip

    When pulling containers into the SHS, instead of using the GitHub access token you used to push the container, it is **recommended** you use a GitHub access token with 'read:packages' scope only. Restricting where you use your read-write token can keep your GHCR secure.

Now run the container using the following command:

```sh
ces-run podman --gpu ghcr.io/$GHCR_NAMESPACE/python-ml-test:v1.1
```

### Example 2 - Step 4. Pull and run container inside your Safe Haven

The container can be pulled and run inside the SHS using the same commands as in the [previous step](#example-2-step-3-pull-and-run-container-inside-the-ces-test-vm).

## Example 3 - Interactive RStudio Rocker container

This section guides you through the process of creating a Rocker RStudio container that can be imported into the SHS and used for data analysis. In the example, a script is copied into the container, and the necessary packages are installed to ensure it runs correctly. Finally, RStudio is accessed from the host, allowing you to interact with the application as if it were running natively.

We will assume that this is the directory structure of our files:

```console
  .
  ├── src
  │   ├── install_packages.R
  │   ├── plot_example.R
  ├── Dockerfile
```

Where `install_packages.R` contains the following:

```R
install.packages("ggplot2")
```

and `plot_example.R` is a simple script that generates a graph:

```R
# library
library(ggplot2)

# basic graph
p <- ggplot(mtcars, aes(x = wt, y = mpg)) +
  geom_point()

# a data frame with all the annotation info
annotation <- data.frame(
   x = c(2,4.5),
   y = c(20,25),
   label = c("label 1", "label 2")
)

# Add text
p + geom_text(data=annotation, aes( x=x, y=y, label=label),                 ,
           color="orange",
           size=7 , angle=45, fontface="bold" )

ggsave("test_figure.png")
```

### Example 3 - Step 1. Writing a Dockerfile

Again, we start by selecting a base image. Searching for Rocker in [DockerHub](https://hub.docker.com/search?q=rocker), presents us with a number of options. Only some of these originate from official sources. We want to select the most appropriate image published from a reputable source, in our case the [Rocker Project](https://rocker-project.org/).

For this example, we choose the latest version of Rocker RStudio, [rocker/rstudio](https://hub.docker.com/r/rocker/rstudio) from [Docker Hub](https://hub.docker.com/).

Clicking on "tags", we can then select "latest" and see the full signature of the image. We can then include the pinned image in our Dockerfile:

```dockerfile
FROM docker.io/rocker/rstudio:latest@sha256:ee7c4efa46f0b5d46e051393ef05f262aceb959463b15fc3648955965290d231
```

The next step is to include the SHS directories:

```dockerfile
RUN mkdir /safe_data /safe_outputs /scratch
```

We then want to copy our script inside the container. As we do not mean to preserve the script, only its output, we will copy it in a new `/src` directory. Note that we cannot save the files to `/scratch` as they would otherwise be overwritten when running the container using the CES tools. To avoid repeating the `RUN` command, we will add our new directory to it:

```dockerfile
RUN mkdir /safe_data /safe_outputs /scratch /src
```

and then copy the files:

```dockerfile
COPY ./src/* /src
```

We then switch into our code directory:

```dockerfile
WORKDIR /src
```

And finally install the required packages:

```dockerfile
RUN r install_packages.R
```

This gives us the following Dockerfile:

```dockerfile
FROM docker.io/rocker/rstudio:latest@sha256:ee7c4efa46f0b5d46e051393ef05f262aceb959463b15fc3648955965290d231

RUN mkdir /safe_data /safe_outputs /scratch /src

COPY ./src/* /src

WORKDIR /src

RUN r install_packages.R
```

### Example 3 - Step 2. Build, test locally and push to registry

As mentioned in our container development workflow, it is good practice to check the Dockerfile with a linting tool to detect common mistakes before building our container:

```sh
# Ignore DL3008 (Pin versions in apt get install)
docker run --pull always --rm -i docker.io/hadolint/hadolint:latest hadolint --ignore DL3008 - < Dockerfile
```

Here we deliberately ignore hadolint flags if the selected features are required by the container to run successfully.

We can then define our GHCR variables, where `GHCR_TOKEN` needs to be a GitHub access token with 'repo' and 'write:packages' scope:

```sh
export GHCR_NAMESPACE=mynamespace
export GHCR_TOKEN=mytoken
```

We can now build our container:

```sh
docker build . --tag ghcr.io/$GHCR_NAMESPACE/rocker-test:v1.1 --tag ghcr.io/$GHCR_NAMESPACE/rocker-test:latest --platform linux/amd64
```

and run it locally:

```sh
docker run --rm -e "PASSWORD=test" -p 8787:8787 ghcr.io/$GHCR_NAMESPACE/rocker-test:v1.1
```

We can now open a browser tab and access RStudio at `localhost:8787`. We can log in using the credentials `root` for the username and `test` for the password.

!!! note

    You are only 'root' within the context of the container, not outside of it.

If the container runs without errors, we can push our image to GHCR using our namespace and token:

```sh
echo "${GHCR_TOKEN}" | docker login ghcr.io -u $GHCR_NAMESPACE --password-stdin
docker push "ghcr.io/$GHCR_NAMESPACE/rocker-test:v1.1"
docker push "ghcr.io/$GHCR_NAMESPACE/rocker-test:latest"
docker logout
```

### Example 3 - Step 3. Pull and run container inside the CES test VM

To test the container inside the CES test VM, first log into the CES test VM following [Accessing EIDF](../../../access).

Pull the container using the following command, where both the `$GHCR_NAMESPACE` and `$GHCR_TOKEN` arguments to `ces-pull` are mandatory:

```sh
ces-pull podman $GHCR_NAMESPACE $GHCR_TOKEN ghcr.io/$GHCR_NAMESPACE/rocker-test:v1.1
```

!!! tip

    When pulling containers into the SHS, instead of using the GitHub access token you used to push the container, it is **recommended** you use a GitHub access token with 'read:packages' scope only. Restricting where you use your read-write token can keep your GHCR secure.

The Rocker container was designed to be run using Docker. In order for it to run successfully with podman, the container directories `/var/lib/rstudio-server` and `/run` need to be mounted to a tmpfs. As such, the following options are required:

```sh
'--mount type=tmpfs,destination=/var/lib/rstudio-server'
'--mount type=tmpfs,destination=/run'
```

A `ces-run` `opt-file.txt` can include these and other options required:

```text
-p 8787:8787
-it
--mount type=tmpfs,destination=/var/lib/rstudio-server
--mount type=tmpfs,destination=/run
```

If we want to set our password, we can add it to a `ces-run` `env-file.txt` as follows, replacing `<password>` with a strong password:

```text
PASSWORD=<password>
```

Now run the container using the following command:

```sh
ces-run podman --opt-file opt-file.txt --env-file env-file.txt ghcr.io/$GHCR_NAMESPACE/rocker-test:v1.1
```

To streamline the process, we can place all the necessary commands into an executable script, `run.sh`, as follows, replacing `<password>` with a strong password:

```sh
opt_file="./opt-file.txt"

if [ -f "$opt_file" ] ; then
        rm "$opt_file"
fi
echo -e '-p 8787:8787' >> ${opt_file}
echo -e '-it' >> ${opt_file}
echo -e '--mount type=tmpfs,destination=/var/lib/rstudio-server' >> ${opt_file}
echo -e '--mount type=tmpfs,destination=/run' >> ${opt_file}

env_file="./env-file.txt"

if [ -f "$env_file" ] ; then
        rm "$env_file"
fi
echo -e "PASSWORD=<password>" >> ${env_file}

ces-run podman --opt-file $opt_file --env-file $env_file ghcr.io/$GHCR_NAMESPACE/rocker-test:v1.1
```

The script can be run as follows:

```sh
bash run.sh
```

After starting the container, either via `ces-run podman` or `bash run.sh`, we can open a browser tab and access RStudio at `localhost:8787`. We can log in using the credentials `root` for the username and our password selected above. From within RStudio, we can then run our script, which can be found in `/src`, and then copy our output to `/safe_output` so that it can be preserved after we exit the container.

The container is running successfully if:

- Your log-in is successful.
- The 'root' user - your user within the container - has full access to SHS directories `/safe_data`, `/safe_outputs` and `/scratch`.
- The files saved in `/safe_outputs` and `/safe_data` (when writing permission is granted by IG) have correct permission on the host, that is, you.

!!! note

    You are only 'root' within the context of the container, not outside of it.

### Example 3 - Step 4. Pull and run container inside your Safe Haven

The container can be pulled and run inside the SHS using the same commands as in the [previous step](#example-3-step-3-pull-and-run-container-inside-the-ces-test-vm).
