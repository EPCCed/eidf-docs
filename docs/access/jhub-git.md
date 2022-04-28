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

# EIDF JupyterHub Notebook Service Access

Using the EIDF JupyterHub, users can access a range of services including standard interactive Python notebooks as well
as RStudio Server.

## <a id="workshops"></a> Workshops
### Accessing

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

