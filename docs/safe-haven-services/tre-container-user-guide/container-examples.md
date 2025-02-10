# Container Examples

To help with writing your own Dockerfiles to run within a Trusted Research Environment via the Container Execution Service, we have provided a set of examples for commonly used software stacks, which can be found in our [TRE Container Samples repository](https://github.com/EPCCed/tre-container-samples/tree/main).

Please contact your Service Manager if you need further support with the use of containers available in the [EPCC TRE Container Samples epository](https://github.com/EPCCed/tre-container-samples/tree/main).

## Example Containers

| Public examples   |   Comments |
| ---------------  |   -------- |
| Julia            |  |
| Octave           |  |
| PostGreSQL       |  |
| Python           |  |
| Quarto           | separate containers for R and Jupyter |
| Rocker           |  interactive |

Additional examples can be made available on demand. To do so, please contact the [EIDF Helpdesk](https://portal.eidf.ac.uk/queries/submit) referencing this page, otherwise send your query by email to [eidf@epcc.ed.ac.uk](mailto:eidf@epcc.ed.ac.uk) with the subject line "TRE Container Support".
ß
| Available on demand   |   Comments |
| ---------------  |   -------- |
| Freesurfer       |            |
| Jamovi           |            |
| MinIO S3         |  |
| Nextflow         |  |
| PSPP             |  |
| Python           |  |
| Stata            |

Most of these containers are minimum working examples, they are not fully fledged applications or workflow examples, but provide a template for setting up the technical parts of the containerisation process, such as user mapping, and mapping to any required `safe_data` folders or similar. Please refer to the `README` in each example for guidance on how to use the container.
