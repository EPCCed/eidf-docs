# Submitting Scripts to Slurm

## What is Slurm?

Slurm is a workload manager that schedules jobs submitted to a shared resource. 
Slurm is a well-developed tool that can manage large computing clusters, such as Archer2, with thousands of users each with different priorities and allocated computing hours.
Inside the SHS, Slurm is used to help ensure all users of the SDF get equal access.
Therefore, users who are submitting jobs with high resource requirements (>80 cores, >1TB of memory) may have to wait longer for resource allocation to enable users with lower resource demands to continue their work.

Slurm is currently set up so all users have equal priority and there is no limit to the total number of CPU hours allocated to a user per month.
However, there are limits to the maximum amount of resources that can be allocated to an individual job.
Jobs that require more than 200 cores, more than 4TB of memory, or an elapsed runtime of more than 96 hours will be rejected.
If users need to submit jobs with large resource demands then they need to submit a resource reservation request by emailing their project's service help desk.

## Why do you need to use Slurm?

The SDF is a resource shared across all projects within the SHS and all users should have equal opportunity to use the SDF to complete resource-intense tasks appropriate to their projects.
Users of the SDF are required to consider the needs of the wider community by:

- requesting resources appropriate to their intended task and timeline.

- submitting resource requests via Slurm to enable automatic scheduling and fair allocation alongside other user requests.  
   
Users can develop code, complete test runs, and debug from the SDF command line without using Slurm.
However, only 32 of the 512 cores are accessible without submitting a job request to Slurm. 
These cores are accessible to all users simultaneously.

## Slurm basics

Slurm revolves around four main entities: nodes, partitions, jobs and job steps. 
Nodes and partitions are relevant for more complex distributed computing clusters so Slurm can allocate appropriate resources to jobs across multiple pieces of hardware.
Nodes typically inform Slurm of how CPUs and memory are grouped together physically on hardware.
Partitions act like queues that also provide Slurm with information on what types of jobs can be allocated to different nodes.
Within the SHS, all the cores managed by Slurm are within the same SDF so there is only one node and one partition.
Jobs are requests for resources and job steps are what actually need to be completed once the resources have been allocated (completed in sequence or parallel).
Job steps can be further broken down into tasks.

There are four key commands for Slurm users:

- squeue: get details on a job or job step, i.e. has a job been allocated resources or is it still pending?

- srun: initiate a job step or execute a job. A versatile function that can initiate job steps as part of a larger batch job or submit a job itself to get resources and run a job step. This is useful for testing job steps, experimenting with different resource allocations or running job steps that require large resources but are relatively easy to define in a line or two (i.e. running a sequence alignment).

- scancel: stop a job from continuing.

- sbatch: submit a job script containing multiple steps (i.e. srun) to be completed with the defined resources. This is the typical function for submitting jobs to Slurm. 

More details on these functions (and several not mentioned here) can be seen on the Slurm website https://slurm.schedmd.com/quickstart.html.

## Submitting a simple job

	*** Signed onto the Superdome Flex***

	squeue -u $USER # Check if there are jobs already queued or running for you

	srun --job-name=my_first_slurm_job --nodes 1 --ntasks 10 --ncpus-per-task 1 echo 'Hello World'

	squeue -u $USER --state=CD # List all completed jobs

The srun command completes two steps in this instance: job submission and job step execution. First, it submits a job request to be allocated 10 CPUs (1 CPU for each of the 10 tasks). Once the resources are available, it executes the job step consisting of 10 tasks each running the 'echo "Hello World"' function.

srun accepts a wide variety of options to specify the resources required to complete its job step.
Within the SHS SDF you must always request 1 node (as there is only one node) and never use the --exclusive option (as no one will have exclusive access to this shared resource). 
Notice that running srun blocks your terminal from accepting any more commands and the output from each task in the job step, i.e. Hello World, gets outputted to your terminal.
We will contrast this to running a sbatch command.

## Submitting a batch job

Batch jobs are incredibly useful because they run in the background without blocking your terminal. The results of a batch job are also outputted to a log file rather than straight to your terminal to enable you check a job was complete successfully at a convenient time. This allows you to move on to other things whilst waiting for a job to complete. 

A batch job can be submitted to Slurm by passing a job script to the sbatch command. The first few lines of a job script outline the resources to be requested as part of the job. The remainder of job script consists of one or more srun commands outlining the job steps that need to be completed (in sequence or parallel) once the resources are available.

### Example Job Script 

	#!/usr/bin/env bash
	#SBATCH -J HelloWorld
	#SBATCH --nodes=1
	#SBATCH --tasks-per-node=10
	#SBATCH --ncpus-per-task=1

	% Run echo task in sequence
	
	srun --ntasks 5 --ncpus-per-task 1 echo "Series Task A. Time: " $(date +”%H:%M:%S”) 
	
	srun --ntasks 5 --ncpus-per-task 1 echo "Series Task B. Time: " $(date +”%H:%M:%S”) 

	% Run echo task in parallel with the ampersand character
	
	srun --ntasks 5 --ncpus-per-task 1 echo "Parallel Task A. Time: " $(date +”%H:%M:%S”) &
	
	srun --ntasks 5 --ncpus-per-task 1 echo "Parallel Task B. Time: " $(date +”%H:%M:%S”) 

### Example job script submission

	nano example_job_script.sh

	*** Copy example job script above ***

	sbatch example_job_script.sh

	squeue -u $USER -r 5

	*** Wait for batch job to be completed ***

	cat example_job_script.log # The series tasks should be grouped together and the parallel tasks interspersed.

The example batch job is intended to show two things: 1) the usefulness of the sbatch command and 2) the versatility of a job script. As the sbatch command allows you to submit scripts and check their outcome at you own discretion, it is the most common way of interacting with Slurm. Meanwhile, the job script command allows you to specify one global resource request and break it up into multiple job steps with different resource demands that can be completed in parallel or in sequence. 

	
## Signposting

Useful websites for learning more about Slurm:

- The Slurm documentation website https://slurm.schedmd.com/documentation.html

- The Introduction to HPC carpentries lesson on Slurm https://carpentries-incubator.github.io/hpc-intro/13-scheduler/index.html
