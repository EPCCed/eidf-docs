# Pre-processing container

## Container image

The pre-processing container is launched from a public container image that you need to provide.
On launch of the container the entrypoint is executed to process the raw data available at a read-only mount point, and write the ARD formatted output to a specific path.

## Input and output

Input and output in the container will be done in two mounted subdirectories:

* `/input_data` which is read only and contains the raw data that was uploaded

* `/output_data` to which you write the ARD formatted output data:
     * `/output_data/data` for data. This may contain a directory tree.
     * `/output_data/metadata.json` for metadata. The metadata file must have the format described below.

## Metadata

For each data file (e.g. `dir1/file1`, `dir2/file2` etc) the following minimum metadata fields are required for ingest into EIDF:
```json
"dir1/file1": {
   "name" : "some_name_for_searching and display",
   "resource:identifier": "some identifier that is relevant to your domain",
   "resource:description": "additional description of your data",
   "resource:licence": "licence under which you make this data available",
   "resource:format": "e.g. json"
},
"dir2/file2": {
   ...
}
```
Other optional fields may be added to the JSON object.

Data files can be located in subdirectories - the file name is the path relative to `output_data/data/`.

## Example: Creating a Docker image

The container expects to find a data file, `MyData.zip` in the `input_data` subdirectory and it also expects the output directories `output_data/data` and `output_data/metadata` to be available.

```dockerfile
FROM ubuntu

# Update Ubuntu Software repository
RUN apt update

# Install unzip
RUN apt-get install unzip

# Entrypoint is the script that will covert the data to analytics ready data
COPY entrypoint.sh .
# This is copying an existing description of the resources metadata into the
# docker image. If your transformation generates the resource metadata on the
# fly you can remove this line.
COPY resources.json .

WORKDIR .
ENTRYPOINT ["./entrypoint.sh"]
```

and the `entrypoint.sh` which should have execute permissions set.

```bash
#!/usr/bin/bash

# Unzip the data.
unzip -q /input_data/MyData.zip -d /output_data/data/

# Copy the resource metadata
cp ./resources.json /output_data/metadata.json
```

The docker content lives in this public [GitHub repo](https://github.com/marioa/EidfTestDocker).

#### Publishing your Docker image

[Publishing docker images](https://docs.github.com/en/actions/publishing-packages/publishing-docker-images) on GitHub. The images can go on Docker Hub or GitHub packages.

