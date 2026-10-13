# Confidential Data Workspace - Router Configuration

The Confidential Data Workspace (CDW) Router is a special Virtual Machine that acts as a gateway for the CDW VMs. It is used to manage network access to the CDW VMs and to provide a secure connection point for users to access the VMs via SSH.

VMs use the CDW Router as a proxy for network traffic, and customer-installed applications on VMs may need some extra options around network access for software that is not installed by default. Many of these are set up on deployment of the service for a project or documented in the [FAQs](./faq.md). For software that is not installed by default the following details may be useful for users to know when setting up software on the VMs.

## Proxy Router Address

When configuring software on the CDW VMs that requires network access, the proxy address to use is given in the EIDF portal for your project under the **Proxy address** section.

### Proxy Ports

HTTP and HTTPS traffic from the CDW VMs is proxied through the Squid service on the project's router. The service listens on the following ports:

- HTTP: 3128
- HTTPS: 3129

## Certificate When Using the Proxy for HTTPS Traffic

For applications that require it, the self-signed certificate used by the Squid service is available on every VM at:

- `/usr/local/share/ca-certificates/extra/squid_proxyCA.crt` for Ubuntu
- `/etc/pki/ca-trust/source/anchors/squid_proxyCA.crt` for Rocky

## SSH Access to the CDW Router

Data Managers and VM Admins can access the CDW Router `<project_code>-router` machine via SSH. This is easiest done using a SSH config file with the appropriate ProxyJump configuration.

This requires users have set up the EIDF Gateway for their user, as this must be jumped through to access the router. An example SSH config file entry for the router is shown below:

```txt
Host eidf-gateway
    HostName eidf-gateway.epcc.ed.ac.uk

Host eidfxxx-router
    HostName <Router IP Address>
    User <VM Admin Username>
    ProxyJump %r@eidf-gateway
    IdentityFile <SSH credential for user>
```

Where the `<Router IP Address>` can be found in the EIDF Portal under the project details page. Note that the CDW Proxy Address is not the IP address that you use to SSH to the router, the address under `machines`, `eidfxxx-router` is the correct address to use for ssh access to the router.

SSH credentials for the router can be added in the EIDF Portal under the project details page, more information on how to do this can be seen in the documentation section on [SSH Credentials in the EIDF Portal](../../access/ssh.md#generate-a-new-ssh-key).

You can then connect to the router using the command:

```bash
ssh eidfxxx-router
```

Where `eidfxxx-router` is the name of the host entry in the SSH config file for the router.

## SSH Access to CDW VMs via the Router

Data Managers and VM Admins can access the CDW VMs via SSH by first connecting to the project router `<project_code>-router` and then jumping from there to the target VM. This is the only way to access the VMs via SSH as direct SSH access to the VMs is disabled. This is most easily achieved by using an SSH config file with the appropriate `ProxyJump` configuration, adding to the existing `~/.ssh/config` entry described above for the router.

```txt
Host eidfxxx-<vm-name>
    HostName <VM IP Address>
    User <VM Admin Username>
    ProxyJump %r@eidfxxx-router
    IdentityFile <SSH credential for user>
```

Where the VM IP Address can be found in the EIDF Portal under the project details page, under the `machines` section for the relevant VM.

SSH credentials for the router can be added in the EIDF Portal under the project details page, more information on how to do this can be seen in the documentation section on [ssh Credentials in the EIDF Portal](../../access/ssh.md#generate-a-new-ssh-key).

You can then connect to the VM using the command:

```bash
ssh eidfxxx-<vm-name>
```

## Updating the list of allowed domains and buckets

The list of domains allows CDW VMs to:

- Access package repositories for operating system updates and software installation
- Access popular container registries for downloading (but not uploading) container images
    - Docker Hub
    - GitHub Container Registry
    - EIDF Container Registry
- Access to common data science software packages:
    - CRAN
    - PyPI
    - Bioconductor

A VM Admin with access to the project router, `<project_code>-router`, can edit the squid access control list. The access control list is available through the `/etc/squid/allowlist_domains.txt` file.

This file contains a detailed list of allowed domains. Entries can be added or removed by opening the file in a text editor and following the syntax of [access control lists defined by Squid](https://wiki.squid-cache.org/SquidFaq/SquidAcl), making special note of the section '[Squid Does Not Match My Subdomains](https://wiki.squid-cache.org/SquidFaq/SquidAcl#squid-doesnt-match-my-subdomains)'.

Read-write access to EIDF S3 buckets is managed separately, via the `/etc/squid/allowlist_buckets.txt` file.

After editing allowlists Squid must be reconfigured using the command:

```bash
sudo squid -k reconfigure
```
