<style>
.border-img {
  border: 5px solid transparent;
  padding: 5px;
  /*margin: 15px;*/
  border-color: rgba(192, 192, 192, 0.1);
  border-radius: 10px;
}

.bold {
  font-weight: bold;
  /*color: black;*/
}

.inline-img {
  vertical-align: middle;
}

.center {
  display: block;
  margin-left: auto;
  margin-right: auto;
}

.fake-link {
    color: blue;
    text-decoration: underline;
    cursor: pointer;
}
</style>

# Workshop Setup
<span class="bold">Please follow the instructions in [JupyterHub Notebook Service Access](/eidf-docs/access/jhub-git#workshops)
to arrange access to the EIDF Notebook service before continuing. The table below provides the login URL and the relevant
GitHub organization to register with.</span>

| Workshop                                                                                           | Login URL                                                                            | GitHub Organization                                     |
|----------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------|---------------------------------------------------------|
| [Ed-DaSH Introduction to Statistics](https://edcarp.github.io/2022-05-03_ed-dash_intro-statistics) | [https://secure.epcc.ed.ac.uk/ed-dash-hub](https://secure.epcc.ed.ac.uk/ed-dash-hub) | [Ed-DaSH-Training](https://github.com/Ed-DaSH-Training) |
| [Ed-DaSH High-Dimensional Statistics](https://edcarp.github.io/2022-05-17_ed-dash_high-dim-stats)  | [https://secure.epcc.ed.ac.uk/ed-dash-hub](https://secure.epcc.ed.ac.uk/ed-dash-hub) | [Ed-DaSH-Training](https://github.com/Ed-DaSH-Training) |

Please follow the sequence of instructions described in the sections below to get ready for the workshop:

1. [Accessing the EIDF RStudio Server Service for the First Time](#access-rstudio-server)
2. [Login to EIDF JupyterHub](#login-jupyterhub)
3. [Creating a New R Script](#create-script)

#### <a id="access-rstudio-server"></a> 1. Accessing the EIDF RStudio Server Service for the First Time
We will be using the RStudio Server service provided by the [Edinburgh International Data Facility
(EIDF)](https://www.ed.ac.uk/edinburgh-international-data-facility/overview). Follow the steps listed below to gain
access.

1. Visit <span class="fake-link">https://secure.epcc.ed.ac.uk/&lt;WORKSHOP&gt;</span>, e.g.
[https://secure.epcc.ed.ac.uk/ed-dash-hub](https://secure.epcc.ed.ac.uk/ed-dash-hub) in your browser
2. Click on the ![GitHub-Signin-Button](/eidf-docs/images/access/github-signin-btn.png){: class="inline-img"} button
3. You will be asked to sign in to GitHub, as shown in the form below

   ![GitHub-Signin](/eidf-docs/images/access/github-signin.png){: class="border-img center"}

4. Enter your GitHub credentials, or click on the ‘Create an account’ link if you do not already have one, and follow
the prerequisite instructions to register with GitHub and join the workshop organization
5. Click on the ‘Sign in’ button
6. On the next page, you will be asked whether to authorize the workshop organization to access your GitHub account as
shown below

   ![GitHub-Authorize](/eidf-docs/images/access/github-authorize.png){: class="border-img center"}

7. Click on the ![GitHub-Authorize-Button](/eidf-docs/images/access/authorize-btn.png){: class="inline-img"} button
8. At this point, you will receive an email to the email address that you registered with in GitHub, stating that
“A third-party OAuth application has been added to your account” for the workshop
9. If you receive a ‘403 : Forbidden’ error message on the next screen (if you did not already do so as in step 4 of the
prerequisites section) send an email to <span class="fake-link">j.hay@epcc.ed.ac.uk</span> from your GitHub registered
email address, including your GitHub username, and ask for an invitation to the workshop organization. Otherwise, skip
to the next step.
10. If you receive a ‘400 : Bad Request’ error message, you need to accept the invitation that has been emailed to you
to join the workshop organization as in the prerequisite instructions

#### <a id="login-jupyterhub"></a> 2. Login to the EIDF JupyterHub
Now that you have completed registration with the workshop GitHub organization, you can access the workshop RStudio
Server in EIDF.

1. Return to the <span class="fake-link">https://secure.epcc.ed.ac.uk/&lt;WORKSHOP&gt;</span> and you will now be redirected
to the <span class="fake-link">https://secure.epcc.ed.ac.uk/&lt;WORKSHOP&gt;/hub/spawn-pending/&lt;GITHUB_USERNAME&gt;</span> page
2. You will see a message stating that your server is launching. If the page has not updated after 10 seconds, simply
refresh the page with the <CTRL> + R or <F5> keys in Windows, or <CMD> + R in macOS
3. Finally, you will be redirected to
<span class="fake-link">https://secure.epcc.ed.ac.uk/&lt;WORKSHOP&gt;/user/&lt;GITHUB_USERNAME&gt;/rstudio/</span> and presented with
the RStudio Server UI as shown below

   ![RStudio-Server-Screen](/eidf-docs/images/access/rstudio-server-screen.png){: class="border-img center"}

#### <a id="create-script"></a> 3. Creating a New R Script
Follow these [quickstart instructions](/eidf-docs/services/rstudioserver/quickstart#create-script) to create your first
R script in RStudio Server!
