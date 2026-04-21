# Confidential Data Workspace - FAQs

## Unable to download packages from snap on the CDW VMs

Snap packages are not by default supported on Confidential Data Workspace (CDW) VMs. Snap requires outbound network access to install software packages which, if allowed, could potentially be used to bypass the security of the CDW.

If you require snap packages, the VM Admin can enable them by modifying the router squid configuration to allow the outgoing network traffic required for snap. This is done by adding the following lines near the top of the router config file `/etc/squid/squid.conf`, before any existing `http_access deny` rules:

```txt
acl snap_refresh_method method POST
acl snap_refresh_domain url_regex api\.snapcraft\.io/v2/snaps/refresh
http_access allow snap_refresh_method snap_refresh_domain
```

After modifying the configuration file, restart Squid with `sudo squid -k reconfigure` for the changes to take effect.

## Using the Proxy for Some Common Software on the CDW VMs

Below we outline a number of common software that you may require and how they can be used with the proxy server on the CDW Router from the CDW VMs. You may find a number of these work out of the box. These make use of the proxy address given in the EIDF portal for your project under the **"Confidential Data Workspace (CDW)"** Proxy address section and the proxy ports 3128 for HTTP and 3129 for HTTPS.

Some more general information on using the proxy server on the CDW Router can be found in the documentation section on [Details of the CDW Router](./router-docs.md).

### http_proxy and https_proxy Environment Variables

http_proxy and https_proxy environment variables are used by many command line tools to route traffic via a proxy server. They should be set by default as follows to the Squid proxy server in the CDW. Uppercase versions are also required by some tools.

```bash
export http_proxy=http://<proxy address>:3128
export https_proxy=http://<proxy address>:3129
export HTTP_PROXY=http://<proxy address>:3128
export HTTPS_PROXY=http://<proxy address>:3129
```

Where the `<proxy address>` can be found in the EIDF portal under the **Confidential Data Workspace (CDW)** heading.

These variables are also set by default in the `/etc/environment` file on each CDW VM.

It is always worth checking these are set if you are having trouble with internet access from within a CDW VM.

### AWS CLI

If using the aws CLI, you may see an error like:

```bash
$ aws s3 ls
SSL validation failed for https://s3.eidf.ac.uk/ [SSL: CERTIFICATE_VERIFY_FAILED] certificate verify failed: self signed certificate in certificate chain (_ssl.c:1032)
```

To fix this, you must add the proxy certificate to your `~/.aws/credentials` file:

```txt
ca_bundle=/usr/local/share/ca-certificates/extra/squid_proxyCA.crt
```

### Docker Service via HTTP Proxy

!!! note
    Docker is not installed by default on CDW VMs, so these instructions are only relevant if you have installed Docker yourself.

Typically docker will use the system proxy settings, however to ensure that docker service uses the HTTP proxy you need to create a systemd drop-in file for the docker service. This is taken directly from the [Docker documentation](https://docs.docker.com/engine/daemon/proxy/#systemd-unit-file).

First create this directory:

```bash
sudo mkdir -p /etc/systemd/system/docker.service.d
```

Then add to the newly created directory a file called `http-proxy.conf`, with content:

```unixconfig
[Service]
Environment="HTTP_PROXY=http://<proxy address>:3128"
Environment="HTTPS_PROXY=http://<proxy address>:3129"
```

Finally, reload Docker:

```bash
sudo systemctl daemon-reload
sudo systemctl restart docker
```

Verify that the properties have been added with:

```bash
sudo systemctl show --property=Environment docker
```

Which should show the `HTTP_PROXY` and `HTTPS_PROXY` variables with the correct proxy address.

### Git

Git can be configured to work through a proxy by use of the following configuration items in `/etc/gitconfig`:

```unixconfig
[http]
proxy = http://<proxy address>:3128

[https]
proxy = https://<proxy address>:3129
sslCAPath = /etc/pki/ca-trust/source/anchors/squid_proxyCA.crt
```

While we recommend setting up the HTTP/HTTPS proxy above, only Git remotes using HTTPS URLs (for example, `https://github.com/...`) are permitted through the proxy server. SSH-based Git remotes (for example, `git@github.com:...` or `ssh://...`) are blocked by the SSH firewall restrictions.

!!! note
    GitHub and GitLab are by default not in the proxy allow list for the CDW service. If you want to use Git with these services, you should ask your VM Admin to add them to the allow list. ECDF and EIDF GitLab instances are by default in the allow list.

The following instructions are intended for VM Admins who have access to configure the CDW Router.

To allow read access to GitLab and GitHub on the router, add the following lines to the allow list file `/etc/squid/allowlist_buckets.txt`:

```txt
.github.com
.gitlab.com
```

More information on how to edit the allow list can be found in the documentation section on [Details of the CDW Router](./router-docs.md#updating-the-list-of-allowed-domains-and-buckets).
