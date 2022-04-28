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
  color: blue;
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

# EIDF JupyterHub and RStudio Server Access 

Using the EIDF JupyterHub, users can access a range of services including standard interactive Python notebooks as well
as RStudio Server.

## Workshops
### Accessing

| Workshop                                                                                           | Login URL                                                                            |
|----------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------|
| [Ed-DaSH Introduction to Statistics](https://edcarp.github.io/2022-05-03_ed-dash_intro-statistics) | [https://secure.epcc.ed.ac.uk/ed-dash-hub](https://secure.epcc.ed.ac.uk/ed-dash-hub) |
| [Ed-DaSH High-Dimensional Statistics](https://edcarp.github.io/2022-05-17_ed-dash_high-dim-stats)  | [https://secure.epcc.ed.ac.uk/ed-dash-hub](https://secure.epcc.ed.ac.uk/ed-dash-hub) | 

In order to access the EIDF JupyterHub, authentication is through GitHub, so you must have an account on 
[https://github.com](https://github.com) and that account must be a member of the appropriate organization in GitHub. Please ask your project
admin or workshop instructor for the workshop GitHub organization details. Please follow the relevant steps listed below
to prepare.

1. If you do not have a GitHub account associated with the email you registered for the workshop with, follow the steps 
described in [Creating a GitHub Account](#create-github-account)
2. If you do already have a GitHub account associated with the email address you registered for the workshop with, 
follow the steps described in [Registering with the Workshop GitHub Organization](#register-github-org)

#### <a id="create-github-account"></a> 1. Creating a GitHub Account
1. Visit [https://github.com/signup](https://github.com/signup)  in your browser
2. Enter the email address that you used to register for the workshop
3. Complete the remaining steps of the GitHub registration process
4. Send an email to <span class="fake-link">eidf@epcc.ed.ac.uk</span> from your GitHub registered email address,
including your GitHub username, and ask for an invitation to the workshop GitHub organization
5. Wait for an email from GitHub inviting you to join the organization, then follow the steps in [Registering with the
Workshop GitHub Organization](#register-github-org)


#### <a id="register-github-org"></a> 2. Registering With the Workshop GitHub Organization
1. If you already have a GitHub account associated with the email address that you registered for the workshop with, you
should have received an email inviting you to join the relevant GitHub organization. If you have not, email 
<span class="fake-link">eidf@epcc.ed.ac.uk</span> from your GitHub registered email address, including your GitHub
username, and ask for an invitation to the workshop GitHub organization
3. Once you have been invited to the GitHub organization, you will receive an email with the invitation; click on the
![GitHub-Org-Button](/eidf-docs/images/access/github-btn.png){: class="inline-img"} button as shown

    ![GitHub-Invitation](/eidf-docs/images/access/github-invitation.png){: class="border-img center"}

4. Clicking on the button in the email will open a new web page at
<span class="fake-link">https://github.com/orgs/WORKSHOP_ORG_ID/invitation?via_email=1</span>
with another form as shown below

    ![GitHub-Invitation-2](/eidf-docs/images/access/github-invitation-2.png){: class="border-img center"}

5. Again, click on the ![Join-GitHub-Org-Button](/eidf-docs/images/access/join-btn.png){: class="inline-img"} button to
confirm, then the <span class="fake-link">https://github.com/WORKSHOP_ORG_ID</span> organization page will open

### Workshop Setup
Please follow the sequence of instructions described in the sections below to get ready for
the workshop:

1. [Accessing the EIDF RStudio Server Service for the First Time](#access-rstudio-server)
2. [Login to EIDF JupyterHub](#login-jupyterhub)
3. [Creating a New R Script](#create-script)

#### <a id="access-rstudio-server"></a> 1. Accessing the EIDF RStudio Server Service for the First Time
We will be using the RStudio Server service provided by the [Edinburgh International Data Facility
(EIDF)](https://www.ed.ac.uk/edinburgh-international-data-facility/overview). Follow the steps listed below to gain
access.

1. Visit <span class="fake-link">https://secure.epcc.ed.ac.uk/WORKSHOP</span>, e.g.
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
prerequisites section) send an email to eidf@epcc.ed.ac.uk from your GitHub registered email address, including your
GitHub username, and ask for an invitation to the workshop organization. Otherwise, skip to the next step.
10. If you receive a ‘400 : Bad Request’ error message, you need to accept the invitation that has been emailed to you
to join the workshop organization as in the prerequisite instructions 

#### <a id="login-jupyterhub"></a> 2. Login to the EIDF JupyterHub
Now that you have completed registration with the workshop GitHub organization, you can access the workshop RStudio
Server in EIDF.

1. Return to the <span class="fake-link">https://secure.epcc.ed.ac.uk/WORKSHOP</span> and you will now be redirected
to the <span class="fake-link">https://secure.epcc.ed.ac.uk/WORKSHOP/hub/spawn-pending/GITHUB_USERNAME</span> page
2. You will see a message stating that your server is launching. If the page has not updated after 10 seconds, simply
refresh the page with the <CTRL> + R or <F5> keys in Windows, or <CMD> + R in macOS
3. Finally, you will be redirected to
<span class="fake-link">https://secure.epcc.ed.ac.uk/WORKSHOP/user/GITHUB_USERNAME/rstudio/</span> and presented with
the RStudio Server UI as shown below

   ![RStudio-Server-Screen](/eidf-docs/images/access/rstudio-server-screen.png){: class="border-img center"}

#### <a id="create-script"></a> 3. Creating a New R Script
Your RStudio Server session has been initialised and all the packages and data required for the workshop have been
loaded into the workspace. All that remains is to create a new R script to hold your workshop's code!

1. In the RStudio Server UI, open the File menu item at the far left of the main menu bar at the top of the page
2. Hover over the ‘New File’ sub-menu item, then select ‘R Script’ from the expanded menu
3. A new window pane will appear in the UI as shown below, and you are now ready to start adding the R code from the 
workshop to your script!

   ![RStudio-Server-Screen-2](/eidf-docs/images/access/rstudio-server-screen-2.png){: class="border-img center"}