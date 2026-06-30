# Confidential Data Workspace - Using the EIDF GPU Service

## Overview

CDW projects may apply to use the EIDF GPU service, and users should follow the standard [GPU service documentation](../gpuservice/index.md) for basic usage information. There are however some restrictions for CDW projects, which are documented on this page.

## No External Resource Access

In order to ensure project data remain confidential, all external network access is blocked from GPU service pods when running CDW jobs.

All external dependencies e.g., software, data, licences, must therefore be present either in the container image, or in an attached Persistent Volume (PV).

## Restricted Container Registries

You should check with your CDW administrator whether access to external container image registries is restricted. If not, you may only be able to use images stored in the [EIDF Container Image Registry (ECIR)](../registry/index.md).

## kubectl Usage

In order to access the GPU service through the CDW Router, you must supply the local CA certificate with all `kubectl` commands.

The location of the certificate depends on the operating system of the VM; see [this](./router-docs.md##certificate-when-using-the-proxy-for-https-traffic) section in the router docs to determine the file location.

For example, on Ubuntu:

```bash
$ CA_CERTIFICATE="/usr/local/share/ca-certificates/extra/squid_proxyCA.crt"

$ kubectl --certificate-authority="${CA_CERTIFICATE}" get pods -n eidfXXXns
No resources found in eidfXXXns namespace.
```

To simplify this, you can create a shell alias for the command. Add the following lines to the end of your `~/.bashrc` file:

```bash
export CA_CERTIFICATE="/usr/local/share/ca-certificates/extra/squid_proxyCA.crt"
alias kubectl='kubectl --certificate-authority=${CA_CERTIFICATE}'
```

You can then source the file and use `kubectl` without the extra argument:

```bash
$ source ~/.bashrc

$ kubectl get pods -n eidfXXXns
No resources found in eidfXXXns namespace.
```

The alias will be automatically applied to all new shell sessions.
