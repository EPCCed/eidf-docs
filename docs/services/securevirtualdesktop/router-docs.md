# Secure Virtual Desktop Router Documentation

## Details of the Secure Virtual Desktop Router

The Secure Virtual Desktop Router is a virtual machine that acts as a gateway for the Secure Virtual Desktop VMs. It is used to manage network access to the Secure Virtual Desktop VMs and to provide a secure connection point for users to access the VMs via SSH.

Secure Virtual Desktop VMs use the Secure Virtual Desktop Router as a proxy for network traffic, as such Secure Virtual Desktop VMs may need some extra options around network access for software that is not installed by default. Many of these are set up on deployment of the service for a project or documented in the [FAQs](./faq.md). For software that is not installed by default the following details may be useful for users to know when setting up software on the VMs.

### Proxy router address

When configuring software on the Secure Virtual Desktop VMs that requires network access, the proxy address to use is given in the EIDF portal for your project under the "Private Project Zone (PPZ)" Proxy address section.

### Proxy ports

HTTP and HTTPS traffic from the secure Virtual Desktop VMs is proxied through the Squid proxy server on the Secure Virtual Desktop Router. The proxy server listens on the following ports:
- HTTP: port 3128
- HTTPS: port 3129

### Certificate when using the proxy for HTTPS traffic

Because the Squid proxy server on the Secure Virtual Desktop Router is intercepting and filtering network traffic from the Secure Virtual Desktop VMs, it uses a self-signed certificate to decrypt and inspect HTTPS traffic. This means that when users are accessing websites over HTTPS from the Secure Virtual Desktop VMs, they may encounter security warnings in their web browsers due to the self-signed certificate used by the Squid proxy. This proxy certificate is stored at `/usr/local/share/ca-certificates/extra/` and must be imported into the browser.

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
