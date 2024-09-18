# Container Examples

To help with writing your own Dockerfiles to run within a Trusted Research Environment via the Container Execution Service, we have provided a set of example Dockerfiles for commonly used software stacks. These show examples of how to set up containers with non-root user access, as well as other best practices for developing secure containers. 

To request access to these container examples please contact Giulia Deiana or Declan Valters via the EIDF helpdesk.

## Example Containers

| Software Stack   |   Comments | 
| ---------------  |   -------- |
| Freesurfer       |            |
| Jamovi           |            |
| Julia            |   |
| Jupyter Notebook | non-interactive at present |
| MinIO S3         |  |
| Nextflow         |  |
| NVIDIDA-Rapids   |  basic/minimal packages |
| Octave           |  |
| PostGreSQL       |  | 
| PSPP             |  |
| Python           |  | 
| Pytorch          |  | 
| Quarto           | separate containers for R and Jupyter |
| Stata            |

Most of these containers are minimum working examples, they are not fully fledged applications or workflow examples, but provided a template for setting up the technical parts of the containerisation process, such as user mapping, and mapping to any required `safe_data` folders or similar. 
