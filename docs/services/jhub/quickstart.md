# Quickstart

## Accessing

Log in to the EIDF Notebook Service at [https://notebooks.eidf.ac.uk](https://notebooks.eidf.ac.uk).
Click on "Login with SAFE". You will be redirected to the SAFE login page.

After logging in to the SAFE you have a choice of user accounts for the Notebook Service. This account is your user in your data science environment and you can share data with your DSC VMs within the same project.

## First Notebook

After logging in you will be redirected back to the Notebook Service pages where you are presented with a choice of data science environments. Select which environment you would like to run and press "Launch" and your container will be started. This may take a little while.

You will be presented with the Jupyter Lab view when the container has started.

The availability of launchers depends on the environment that you selected.

For example launch a Jupyter notebook to run a Python command or launch RStudio to execute an R script.

## Data

There is a project space mounted in `/project_data`. Here you can exchange data with other members of your project who are using the Notebook Service or a DSC VM.

## Limits

There are limited amounts of memory and cores available per user and currently no GPUs. If you have access to the EIDF GPU Service you can submit jobs but your Jupyter notebooks do not have interactive access to a GPU.