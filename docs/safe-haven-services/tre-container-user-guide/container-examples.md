# Container Examples

To help with writing your own Dockerfiles to run within the Trusted Research Environment via the Container Execution Service, a set of examples for commonly used software stacks can be found in our [TRE Container Samples](https://github.com/EPCCed/tre-container-samples/) repository.

Please contact your Service Manager if you need further support with the use of containers.

## Example Containers

| Application |   Comments |
| ---------------  |   -------- |
| Julia            |  |
| Octave           |  |
| PostgreSQL       |  |
| Python           |  |
| Quarto           | Separate containers for R and Jupyter |
| Rocker           |  Interactive |

Additional examples can be made available on request. To do so, please contact the [EIDF Helpdesk](https://portal.eidf.ac.uk/queries/submit) referencing this page, otherwise send your query by email to [eidf@epcc.ed.ac.uk](mailto:eidf@epcc.ed.ac.uk) with the subject line "TRE Container Support".

| Available on demand   |   Comments |
| ---------------  |   -------- |
| Freesurfer       |            |
| Jamovi           |            |
| MinIO S3         |  |
| Nextflow         |  |
| PSPP             |  |
| Python           |  |
| Stata            |  |

These containers are not fully fledged applications or workflow examples, but provide a template for setting up the technical parts of the containerisation process such as user mapping, and mapping to any required `safe_data` folders or similar. Please refer to the `README` in each example for guidance on how to use the container.
