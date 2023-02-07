# Safe Haven Service Access

Safe Haven services are accessed from a registered network connection address using a browser. The service URL will be "https://shs.epcc.ed.ac.uk/<service\>" where <service\> is the Safe Haven service name. The Safe Haven access process is in three stages from multi-factor authentication to project desktop login. Researchers who are active in many research projects and in more than one Safe Haven will need to pay attention to the service they connect to, the project desktop they login to, and the accounts and identities they are using.

## Safe Haven Login 

The first step in the process prompts the user for a Safe Haven username and then for a session PIN code sent via SMS text to the mobile number registered for the username. Valid PIN code entry allows the user access to all of the Safe Haven service remote desktop gateways for up to 24 hours without entry of a new PIN code. Hence, a user who has successfully entered a PIN code once can access shs.epcc.ed.ac.uk/haven1 and shs.epcc.ed.ac.uk/haven2 without repeating PIN code identity verification. When a valid PIN code is accepted, the user is prompted to accept the service use terms and conditions.

Registration of the user mobile phone number is managed by the Safe Haven IG controller and research project co-ordination teams by submitting and confirming user account changes through the dedicated service help desk via email.

## Remote Desktop Gateway Login

The second step in the access process is for the user to login to the Safe Haven service remote desktop gateway so that a project desktop connection can be chosen. The user is prompted for a Safe Haven service account identity.

   ![VDI-Safe-Haven-Login-Page](/eidf-docs/images/access/UoE-Data-Safe-Haven-VDI-Login.png){: class="border-img"}
   *VDI Safe Haven Service Login Page*

Safe Haven accounts are managed by the Safe Haven IG controller and research project co-ordination teams by submitting and confirming user account changes through the dedicated service help desk via email.

## Project Desktop Connection

The third stage in the process is to select the virtual connection from those available on the account's home page. An example home page is shown below offering two connection options to the same virtual machine. Remote desktop connections will have an \_rdp suffix and SSH terminal connections have an \_ssh suffix. The most recently used connections are shown as screen thumbnails at the top of the page and all the connections available to the user are shown in a tree list below this.

   ![VDI-Connections-Available-Page](/eidf-docs/images/access/vdi-home-screen.png){: class="border-img"}
   *VM connections available home page*

The remote desktop gateway software used in the Safe Haven services in the TRE is the Apache Guacamole web application. Users new to this application can [find the user manual here](https://guacamole.apache.org/doc/gug/using-guacamole.html). It is recommended that users read this short guide, but note that the data sharing features such as copy and paste, connection sharing, and file transfers are disabled on all connections in the TRE Safe Havens. 

A remote desktop or SSH connection is used to access data provided for a specific research project. If a researcher is working on multiple projects within a Safe Haven they can only login to one project at a time. Some connections may allow the user to login to any project and some connections will only allow the user to login into one specific project. This depends on project IG restrictions specified by the Safe Haven and project controllers.  

Project desktop accounts are managed by the Safe Haven IG controller and research project co-ordination teams by submitting and confirming user account changes through the dedicated service help desk via email.
