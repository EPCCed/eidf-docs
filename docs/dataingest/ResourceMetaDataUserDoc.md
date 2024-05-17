# Resource Metadata

When you ingest data into the *EIDF Analytics-Ready Data service*, you need to provide metadata so that your deposited data can be discovered by other researchers. This page aims to describe the minimally required metadata set, and the optional pieces of metadata that you may want to provide. We also aim to provide an evolving set of domain-specfic examples.

## Overview

When data is ingested into the EIDF *Analytics-Ready Data service* (ARD), a corresponding record is held in the EIDF Metadata Catalogue. The contents of this record are indexed and made searchable, so that other researchers can find information about your data. You will need to supply your resource metadata as a JSON format file in a file called `resources.json`. The ingest process requires a small set of mandatory information (fields can be in any order but the entries have to be there):

```json
{
   "name" : "some_name_for_searching and display",
   "resource:identifier": "some identifier that is relevant to your domain",
   "resource:description": "free text description of your data",
   "resource:licence": "licence under which you make this data available",
   "resource:format": "e.g. json"
}
```

Additionally, you may provide the following optional fields in your metadata file:

```json
{
    "resource:size": "resource data file size in bytes",
    "resource:hash": "checksum for the data file",
    "resource:compression_format": "compression format applied to the data, if appropriate",
    "resource:documentation": "a link to related external documentation about this resource",
    "resource:has_policy": "indicate if the resource data adheres to a specific defined policy",
    "resource:language": "the language in which the resource is written, if appropriate",
    "resource:conforms_to": "an external defined schema that the resource conforms to",
    "resource:mimetype": "the media type of the resource, eg video, images, etc",
    "resource:packaging_format": "the packaging format that was applied to the resource, if appropriate",
    "resource:issued": "the formal date on which the resource was issued",
    "resource:rights": "A statement on any distribution rights held with respect to the resource", 
    "resource:spatial_resolution", "Spatial Resolution of the resource data (in metres)",
    "resource:status": "The maturity status of the resource metadata",
    "resource:temporal_resolution", "the minimum timestep of the data, if appropriate",
    "resource:modified": "the most recent date on which the resource was modified before ingest",
}

```

Note that if the minimally required metadata is not provided the whole data ingest process will fail.

You also have to associate the metadata with the resource that it is associated with. For instance, you will be provided with a directory named after your `dataset-name` then within this you will have a `data` directory which contains your data. Paths will have to be given relative to the `data` subdirectory.

For example, for the data files:

* `dataset-name/data/file1.csv`
* `dataset-name/data/dir1/file2.csv`

The metadata content file will be `dataset-name/resources.json` (i.e. above the `data` directory), the path of the files is relative to the `data` directory:

```json
{
  "file1.csv": {
    "name": "My Name",
    "resource:identifier": "my-name",
    "resource:description": "A very important data file",
    "resource:format": "CSV",
    "resource:licence": "CC-BY"
  },
  "dir1/file2.csv": {
    "name": "Another File",
    "resource:identifier": "another-file",
    "resource:description": "More details about the file",
    "resource:format": "CSV",
    "resource:licence": "CC-BY"
  }
}
```

It is also possible to add an entire directory tree as a single metadata resource, for example:

```json
{
  "dir/": {
    "name": "Many files",
    "resource:identifier": "many-files",
    "resource:description": "A collection of data files in one data resource",
    "resource:format": "CSV",
    "resource:licence": "CC-BY"
  }
}
```

This will create one resource in the catalogue with a link to all files in the S3 ARD bucket with the prefix `dir`, you do not have to use the forward slash to indicate a directory.
