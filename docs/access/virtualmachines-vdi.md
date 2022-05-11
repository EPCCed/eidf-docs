<style>
.borderimg1 {
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

.fake-link {
    color: blue;
    text-decoration: underline;
    cursor: pointer;
}
</style>

# Virtual Machines (VMs) and the EIDF Virtual Desktop Interface (VDI) 

Using the EIDF VDI, members of EIDF projects can connect to VMs that they have been granted access to. The EIDF VDI is
a web portal that displays the connections to VMs a user has available to them, and then those connections can be easily 
initiated by clicking on them in the user interface. Once connected to the target VM, all interactions are mediated 
through the user's web browser by the EIDF VDI.

## Accessing

In order to access the EIDF VDI and connect to EIDF data science cloud VMs, you need to have an active 
[SAFE](https://safe.epcc.ed.ac.uk) account. If you already have a SAFE account, you can skip ahead to the 
[Request Project Membership](#request-project-membership) instructions. Otherwise, follow the
[Register Account in EPCC SAFE](#register-safe-account) instructions immediately below to create the account.

### <a id="register-safe-account"></a>Register Account in EPCC SAFE
1. Go to [SAFE signup](https://safe.epcc.ed.ac.uk/signup.jsp) and complete the registration form
    1. Mandatory fields are: Email, Nationality, First name, Last name, Institution for reporting, Department, and Gender
    2. Your Email should be the one you used to register for the EIDF service (or Ed-DaSH workshop)
    3. Institution for reporting should always be 'University of Edinburgh'
    4. Department should always be '**EIDF**'

    ![SAFE-signup-screenshot](/eidf-docs/images/SAFE_website_signup.png){: class="borderimg1"}

2. Submit the form, then accept the [SAFE Acceptable Use policy](https://www.archer2.ac.uk/about/policies/safe_acceptable_use_policy.html)
on the next page

    ![SAFE-policy-screenshot](/eidf-docs/images/SAFE_acceptable_use.png){: class="borderimg1"}

3. After you have completed the registration form and accepted the policy, you will receive an email from
<span class="bold">support@archer2.ac.uk</span> with a password reset URL
6. Visit the link in the email and generate a new password, then submit the form
7. You will now be logged into your new account in SAFE

### <a id="request-project-membership"></a>Request Project Membership
1. While logged into SAFE, select the ‘Request Access’ menu item from the 'Projects' menu in the top menu bar
2. This will open the 'Apply for project membership' page
3. Enter the appropriate project ID into the ‘Project’ field and click the ‘Next’ button

    ![SAFE-apply01-screenshot](/eidf-docs/images/SAFE_Apply_Project_01.png){: class="borderimg1"}

4. In the 'Access route' drop down field that appears, select 'Request membership' (not 'Request machine account')

    ![SAFE-apply01-screenshot](/eidf-docs/images/SAFE_Apply_Project_02.png){: class="borderimg1"}

5. The project owner will then receive notification of the application and accept your request

### Login to the EIDF VDI

Once your membership request to join the appropriate EIDF project has been approved, you will be able to login to the
EIDF VDI at [https://eidf-vdi.epcc.ed.ac.uk/vdi](https://eidf-vdi.epcc.ed.ac.uk/vdi). Authentication to the VDI is
provided by SAFE, so if you do not have an active web browser session in SAFE, you will be redirected to the login page
at <span class="fake-link">https://safe.epcc.ed.ac.uk/oauth/authorize?scope=profile+email+openid&response_type=id_token&client_id=eidf-guacamole&redirect_uri=https%3A%2F%2Feidf-vdi.epcc.ed.ac.uk%2Fvdi%2F&nonce=&lt;NONCE_ID&gt;</span>

## Navigating the EIDF VDI

After you have been authenticated through SAFE and logged into the EIDF VDI, if you have multiple connections available 
to you that have been associated with your user (typically in the case of research projects), you will be presented with
the VDI home screen as shown below

   ![VDI-home-screen](/eidf-docs/images/access/vdi-home-screen.png){: class="borderimg1"}

## Connecting to a VM

If you have only one connection associated with you VDI user (typically in the case of workshops), you will be
automatically connected to the target VM's virtual desktop. Once you are connected to the VM, you will be asked for your
username and password as shown below (if you are participating in a workshop, then you may not be asked for credentials)

   ![VM-VDI-connection-login](/eidf-docs/images/access/vm-vdi-connection-login.png){: class="borderimg1"}

Once your credentials have been accepted, you will be connected to your VM's desktop environment. For instance, the
screenshot below shows a resulting connection to a Xubuntu 20.04 VM with the Xfce desktop environment.

   ![VM-VDI-connection](/eidf-docs/images/access/vm-vdi-connection.png){: class="borderimg1"}

## Further information