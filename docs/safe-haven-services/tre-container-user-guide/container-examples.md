# Container Examples

To help with writing your own Dockerfiles to run within a Trusted Research Environment via the Container Execution Service, we have provided a set of example Dockerfiles for commonly used software stacks. These show examples of how to set up containers with non-root user access, as well as other best practices for developing secure containers. 

To request access to these containers please **ACTION TBD**

## Example Containers

| Software Stack  |  Container Name  | Comments | 
| --------------- | ---------------- | -------- |
| Freesurfer      | freesurfer       | |
| Jamovi          | jamovi           | |
| Julia           | julia            | |
| Jupyter Notebook | jupyter-docker-stack-basic | non-interactive at present |
| MinIO S3         | minioS3         | |
| Nextflow         | nextflow        | |
| NVIDIDA-Rapids   | nvidia-rapids   | basic/minimal packages |
| Octave           | octave          | |
| PostGreSQL       | postgresql      | | 
| PSPP             | pspp            | |
| Python           | python          | | 
| Pytorch          | pytorch         | | 
| Quarto           | quarto-jupyter, quarto-r | separate containers for R and Jupyter |
| Stata            | stata |

Most of these containers are minimum working examples, they are not fully fledged applications or workflow examples, but provided a template for setting up the technical parts of the containerisation process, such as user mapping, and mapping to any required `safe_data` folders or similar. 
