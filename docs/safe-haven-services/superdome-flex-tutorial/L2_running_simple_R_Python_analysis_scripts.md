# Running Simple R/Python Scripts

Running analysis scripts on the SDF is slightly different to running scripts on the Desktop VMs. 
The Linux distribution differs between the two with the SDF using Red Hat Enterprise Linux (RHEL) and the Desktop VMs using Ubuntu. 
Therefore, it is highly advisable to use virtual environments (e.g. conda environments) to complete any analysis and aid the transition between the two distributions.
Conda should run out of the box on the Desktop VMs, but some configuration is required on the SDF. 

## Setting up conda environments on the SDF

	*** SDF Terminal ***

	conda activate base # Test conda environment

	# Conda command will not be found. There is no need to install!

	eval "$(/opt/anaconda3/bin/conda shell.bash hook)" # Tells your terminal where conda is

	conda init # changes your .bashrc file so conda is automatically available in the future

	conda config --set auto_activate_base false # stop conda base from being activated on startup

	python # note python version

	exit()

The base conda environment is now available but note that the python and gcc compilers are not the latest (Python 3.9.7 and gcc 7.5.0).

## Getting an up-to-date python version

In order to get an up-to-date python version we first need to use an updated gcc version. 
Fortunately, conda has an updated gcc toolset that can be installed.

	*** SDF Terminal ***

	conda create -n python-v3.11 gcc_linux-64=11.2.0 python=3.11.3
	
	conda activate python-v3.11

	python

	exit()

## Running R scripts on the SDF

There is a default version of R available on the SDF v4.1.2. Alternative R versions can be installed using conda similar to the python conda environment above.

	conda create -n r-v4.3 gcc_linux-64=11.2.0 r-base=4.3
	
	conda activate r-v4.3

	R 

	q()

## Final points

- The SDF, like the rest of the SHS, is separated from the internet. The installation of python/R libraries to your environment is from a local copy of the respective conda/CRAN library repositories. Therefore, not all packages may be available and not all package versions may be available.

- It is discouraged to run extensive python/R analyses without submitting them as job requests using Slurm. 



