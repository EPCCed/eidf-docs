# Access Open OnDemand

Open OnDemand is accessed by running a browser on a host within your safe haven.

To access Open OnDemand:

* Start a remote desktop (RDP) session with a host within your safe haven, as described in [Safe Haven Service Access](../../safe-haven-access/).
* Start a web browser within your safe haven host.
* Enter the Open OnDemand URL for your safe haven:
    - National Safe Haven, https://nsh-ondemand.nsh.loc
    - ODAP, https://odp-ondemand.nsh.loc
    - Smart Data Foundry, https://smartdf-ondemand.nsh.loc
    - DataLoch, https://dap-ondemand.nsh.loc
* If using Falkon and an 'SSL Certificate Error!' dialog appears with text 'Would you like to make an exception for this certificate?', then:
    - Click 'Yes'
* If using Firefox and a 'Warning: Potential Security Risk Ahead' page appears with text 'Error code: SEC_ERROR_UNKNOWN_ISSUER', then
    - Click 'Advanced...'
    - Click 'Accept the Risk and Continue'
* The Open OnDemand log-in page will appear.
* Enter your project username and password. These are the same username and password that you used when logging into your safe haven host.
* Click 'Log in'.
* Open OnDemand's [user interface](./user-interface.md) will open.

**Troubleshooting: Bad Request**

If you see page, 'Bad Request' 'Your browser sent a request that this server could not understand.', then revisit the URL and try to log in again. This can arise if there is information in your browser cache from a previous Open OnDemand session.

**Troubleshooting: Cannot access Open OnDemand**

For any other problems logging into Open OnDemand, first double-check your username and password. If you still have no success, then please contact the [Helpdesk](TODO).
