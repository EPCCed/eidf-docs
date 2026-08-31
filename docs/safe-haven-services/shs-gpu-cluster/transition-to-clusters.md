# When do I transition to the HPC Cluster or the GPU Cluster?

Many researchers are content with the use of VMs for their workloads. In the EPCC Safe Haven Services, we provision VMs with varied CPU-RAM configurations as specified by the Research co-ordinators who commission them, and we also provision VMs with a dedicated GPU. The most amount of RAM that we can provision on a single VM is 256GB and each Safe Haven normally has up to 72 CPUs in total.

Some researchers have increased performance requirements that go beyond these VMs. The EPCC Safe Haven Services offer an [HPC Cluster](https://docs.eidf.ac.uk/safe-haven-services/shs-superdome-flex/L1_Accessing_the_SDF_Inside_the_EPCC_SHS/) and a [GPU Cluster](https://docs.eidf.ac.uk/safe-haven-services/shs-gpu-cluster/). These are resources shared amongst our Safe Havens, so they do not mount the /safe_data folder, and the researchers need to be selective with the data that they replicate and process on these resources, to minimise the risks from using a shared resource.

There are no strict boundaries about the transition from the VM to the Clusters, but a good example could be that a researcher code is running out of memory; such a code would naturally transition to the [HPC Cluster](https://docs.eidf.ac.uk/safe-haven-services/shs-superdome-flex/L1_Accessing_the_SDF_Inside_the_EPCC_SHS/) to make use of the large amount of Shared Memory that it provides. Other than following simple instructions on how to use the job scheduler on the HPC Cluster, the transition is straightforward. More advanced researchers may run parallelised codes, and in that case the HPC Cluster can increase the scale of the execution as it has a significant number of CPUs available.

Similarly, a researcher running out of resource on a GPU-enabled VM would transition to the [GPU Cluster](https://docs.eidf.ac.uk/safe-haven-services/shs-gpu-cluster/). A modification may be required to containerise the code, as the GPU Cluster only allows containerised workloads, and EPCC can help with the containerisation.

Please visit the pages of our shared AI and Machine Learning resources for more information about the specification of these Clusters and tutorials to get you started. They are as follows:

[HPC Cluster](https://docs.eidf.ac.uk/safe-haven-services/shs-superdome-flex/L1_Accessing_the_SDF_Inside_the_EPCC_SHS/)

[GPU Cluster](https://docs.eidf.ac.uk/safe-haven-services/shs-gpu-cluster/)
