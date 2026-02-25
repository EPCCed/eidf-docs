# Secure Virtual Desktop Router Documentation

## SSH Access to the Secure Virtual Desktop Router

VM Admins can access the Secure Virtual Desktop Router `<project_code>-router` machine via SSH using the VM Admin user for the project. This is easiest done using a SSH config file with the appropriate ProxyJump configuration.

This requires users have set up the EIDF Gateway for their user as this must be jumped through to access the router. An example SSH config file entry for the router is shown below:

```bash
host eidf-gateway
    Hostname eidf-gateway.epcc.ed.ac.uk
    User bc-eidfstaff
    IdentityFile <SSH credential for user>

Host eidfxxx-router 
    HostName <Router IP Address>
    User ubuntu
    ProxyCommand SSH eidf-gateway -W %h:%p
    IdentityFile <SSH credential for user>
```

Where the `<Router IP Address>` can be found in the EIDF Portal under the project details page. Note that the Private Project Zone Proxy Address is not the IP address that you use to SSH to the router, the address under `machines`, eidfxxx-router is the correct address to use for ssh access to the router.

SSH credentials for the router can be added in the EIDF Portal under the project details page, more information on how to do this can be seen in the documentation section on [SSH Credentials in the EIDF Portal](../../access/ssh.md#generate-a-new-ssh-key).

You can then connect to the router using the command:

```bash
ssh eidfxxx-router
```

Where `eidfxxx-router` is the name of the host entry in the SSH config file for the router.

## SSH Access to Secure Virtual Desktop VMs via the Router

VM Admins can access the Secure Virtual Desktop VMs via SSH by first connecting to the project router `<project_code>-router` and then jumping from there to the target VM. This is the only way to access the VMs via SSH as direct SSH access to the VMs is disabled for security of the service. This is easiest done using a SSH config file with the appropriate ProxyJump configuration, adding to the existing `~/.ssh/config` entry described above for the router.

```bash
Host eidfxxx-VM
    HostName <VM IP Address>
    User <VM Admin Username>
    ProxyCommand  ssh eidfxxx-router -W %h:%p
    IdentityFile <SSH credential for user>
```

Where the VM IP Address can be found in the EIDF Portal under the project details page, under the `machines` section for the relevant VM.

SSH credentials for the router can be added in the EIDF Portal under the project details page, more information on how to do this can be seen in the documentation section on [ssh Credentials in the EIDF Portal](../../access/ssh.md#generate-a-new-ssh-key).


You can then connect to the VM using the command:

```bash
ssh eidfxxx-VM
```


## Updating the allowed access for Secure Virtual Desktop VMs

By default the allowed list of domains allows Secure Virtual Desktop VMs to:

- Access common package repositories for operating system updates and software installation
- Access popular container registries for downloading (but not uploading) container images
    - Docker Hub
    - GitHub Container Registry
    - EIDF Container Registry
- Access common software packages:
    - CRAN
    - PyPI
    - Bioconductor
- Specific EIDF S3 buckets for data transfer

Configuring the allowed list of domains for specific projects can be done only by the VM Admin through access to the Squid Router machine.

The VM Admin with access to the Squid Router `<project_code>-router` machine can edit the squid access control list. The access control list is available through the file

```bash
<project_code>-router$  /etc/squid/allowlist_domains.txt
```

Within this is a detailed list of domains and their reasons for being allowed. The VM Admin can add or remove domain names following the syntax of [access control lists defined by Squid](https://wiki.squid-cache.org/SquidFaq/SquidAcl) making special note of the section '[Squid Does Not Match My Subdomains](https://wiki.squid-cache.org/SquidFaq/SquidAcl#squid-doesnt-match-my-subdomains)'.

S3 bucket access is handled in a different location due to some technical details of allowing EIDF S3 bucket access. The list of allowed S3 buckets is available through the file:

```bash
<project_code>-router$  /etc/squid/allowlist_buckets.txt
```

After editing allowlists Squid must be reconfigured using the command:

```bash
sudo squid -k reconfigure
```
