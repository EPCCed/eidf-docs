# Secure Virtual Desktop Router Documentation

## Updating the allowed access for Secure Virtual Desktop VMs

By default the allowed list of domains allows Secure Virtual Desktop VMs to:

- Access common package repositories for operating system updates and software installation
- Access EIDF services including the MFT server for data transfer
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
