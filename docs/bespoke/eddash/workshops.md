# Workshop Setup

**Please follow the instructions in [JupyterHub Notebook Service Access](../jhub-git/#ed-dash-workshops)
to arrange access to the EIDF Notebook service before continuing. The table below provides the login URL and the relevant
GitHub organization to register with.**

| Workshop                                                                                                                         | Login URL                                                                            | GitHub Organization                                     |
|----------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------|---------------------------------------------------------|
| [Ed-DaSH Introduction to Statistics](https://edcarp.github.io/2022-05-03_ed-dash_intro-statistics)                               | [https://secure.epcc.ed.ac.uk/ed-dash-hub](https://secure.epcc.ed.ac.uk/ed-dash-hub) | [Ed-DaSH-Training](https://github.com/Ed-DaSH-Training) |
| [Ed-DaSH High-Dimensional Statistics](https://edcarp.github.io/2022-05-17_ed-dash_high-dim-stats)                                | [https://secure.epcc.ed.ac.uk/ed-dash-hub](https://secure.epcc.ed.ac.uk/ed-dash-hub) | [Ed-DaSH-Training](https://github.com/Ed-DaSH-Training) |
| [Ed-DaSH Introduction to Machine Learning with Python](https://edcarp.github.io/2022-08-23_ed-dash_machine_learning/)            | [https://secure.epcc.ed.ac.uk/ed-dash-hub](https://secure.epcc.ed.ac.uk/ed-dash-hub) | [Ed-DaSH-Training](https://github.com/Ed-DaSH-Training) |
| [N8 CIR Introduction to Artificial Neural Networks in Python](https://n8cir.org.uk/events/introduction-machine-learning-python/) | [https://secure.epcc.ed.ac.uk/ed-dash-hub](https://secure.epcc.ed.ac.uk/ed-dash-hub) | [Ed-DaSH-Training](https://github.com/Ed-DaSH-Training) |

Please follow the sequence of instructions described in the sections below to get ready for the workshop:

1. [Step 1: Accessing the EIDF Notebook Service for the First Time](#step-1-accessing-the-eidf-notebook-service-for-the-first-time)
1. [Step 2: Login to EIDF JupyterHub](#step-2-login-to-the-eidf-notebook-service)
1. [Step 3: Creating a New R Script](#step-3-creating-a-new-r-script)

## Step 1: Accessing the EIDF Notebook Service for the First Time

We will be using the Notebook service provided by the [Edinburgh International Data Facility
(EIDF)](https://www.ed.ac.uk/edinburgh-international-data-facility). Follow the steps listed below to gain
access.

* Visit [https://secure.epcc.ed.ac.uk/ed-dash-hub](https://secure.epcc.ed.ac.uk/ed-dash-hub) in your browser

!!! warning
    If you are receiving an error response such as '403: Forbidden' when you try to access
    [https://secure.epcc.ed.ac.uk/ed-dash-hub](https://secure.epcc.ed.ac.uk/ed-dash-hub), please send an email to
    [ed-dash-support@mlist.is.ed.ac.uk](mailto:ed-dash-support@mlist.is.ed.ac.uk) to request access and also include
    your IP address which you can find by visiting [https://whatismyipaddress.com/](https://whatismyipaddress.com/) in
    your browser. Please be aware that if you are accessing the service from outside of the UK, your access might be
    blocked until you have emailed us with your IP address.

1. Click on the ![GitHub-Signin-Button](/eidf-docs/images/access/github-signin-btn.png){: class="inline-img"} button
1. You will be asked to sign in to GitHub, as shown in the form below
   ![GitHub-Signin](/eidf-docs/images/access/github-signin.png){: class="border-img center"}
   *GitHub sign in form for access to EIDF Notebook Service*
1. Enter your GitHub credentials, or click on the ‘Create an account’ link if you do not already have one, and follow
   the prerequisite instructions to register with GitHub and join the workshop organization
1. Click on the ‘Sign in’ button
1. On the next page, you will be asked whether to authorize the workshop organization to access your GitHub account as
   shown below
   ![GitHub-Authorize](/eidf-docs/images/access/github-authorize.png){: class="border-img center"}
   *GitHub form requesting authorization for the workshop organization*
1. Click on the ![GitHub-Authorize-Button](/eidf-docs/images/access/authorize-btn.png){: class="inline-img"} button
1. At this point, you will receive an email to the email address that you registered with in GitHub, stating that
   “A third-party OAuth application has been added to your account” for the workshop
1. If you receive a ‘403 : Forbidden’ error message on the next screen (if you did not already do so as in step 4 of the
    prerequisites section) send an email to [ed-dash-support@mlist.is.ed.ac.uk](mailto:ed-dash-support@mlist.is.ed.ac.uk)
    from your GitHub registered email address, including your GitHub username, and ask for an invitation to the workshop
    organization. Otherwise, skip to the next step. **N.B. If you are accessing the service from outside of the UK, you
    may see this error; if so, please contact
    [ed-dash-support@mlist.is.ed.ac.uk](mailto:ed-dash-support@mlist.is.ed.ac.uk) to enable access**
1. If you receive a ‘400 : Bad Request’ error message, you need to accept the invitation that has been emailed to you
     to join the workshop organization as in the prerequisite instructions

## Step 2: Login to the EIDF Notebook Service

Now that you have completed registration with the workshop GitHub organization, you can access the workshop RStudio
Server in EIDF.

1. Return to the [https://secure.epcc.ed.ac.uk/ed-dash-hub](https://secure.epcc.ed.ac.uk/ed-dash-hub)
1. You will be presented with a choice of server as a list of radio buttons. Select the appropriate one as labelled for
   your workshop and press the orange 'Start' button
1. You will now be redirected to the hub spawn pending page for your individual server instance
1. You will see a message stating that your server is launching. If the page has not updated after 10 seconds, simply
   refresh the page with the &lt;CTRL&gt; + R or &lt;F5&gt; keys in Windows, or &lt;CMD&gt; + R in macOS
1. Finally, you will be redirected to either the RStudio Server if it's a statistics workshop, or the Jupyter Lab
   dashboard otherwise, as shown in the screenshots below
   ![RStudio-Server-Screen](/eidf-docs/images/access/rstudio-server-screen.png){: class="border-img center"}
   *The RStudio Server UI*
   ![Jupyter-Lab-Dashboard](/eidf-docs/images/access/jupyterlab-dashboard.png){: class="border-img center"}
   *The Jupyter Lab Dashboard*

## Step 3: Creating a New R Script

Follow these [quickstart instructions](/eidf-docs/services/rstudioserver/quickstart#creating-a-new-r-script) to create your first
R script in RStudio Server!
