# FAQs for the Secure Virtual Desktop Service

## http_proxy and https_proxy environment variables

http_proxy and https_proxy environment variables are used by many command line tools to route traffic via a proxy server. They should be set by default as follows to the Squid proxy server in the Secure Virtual Desktop. Uppercase versions are also required by some tools.

```bash
export http_proxy=http://<proxy address>:3128
export https_proxy=http://<proxy address>:3129
export HTTP_PROXY=http://<proxy address>:3128
export HTTPS_PROXY=http://<proxy address>:3129
```

Where the `<proxy address>` can be found in the EIDF portal under the **Private Project Zone (PPZ)** heading.

These variables are also set by default in the /etc/environment files.

It is always worth checking these are set if you are having trouble with internet access from within a Secure Virtual Desktop VM.

## AWS CLI

If using S3, as well as usual credentials file you must also define the proxy certificate:
by adding to `~/.aws/credentials` the line
`ca_bundle=/usr/local/share/ca-certificates/extra/squid_proxyCA.crt`

```bash
$ aws s3 ls
SSL validation failed for https://s3.eidf.ac.uk/ [SSL: CERTIFICATE_VERIFY_FAILED] certificate verify failed: self signed certificate in certificate chain (_ssl.c:1032)
```

## Docker Service via HTTP Proxy

Typically docker will use the system proxy settings, however to ensure that docker Service uses the HTTP proxy you need to create a systemd drop-in file for the docker service.

Add service at startup

```bash
sudo systemctl enable docker.service
sudo systemctl enable containerd.service
```

This is taken directly from the [Docker documentation](https://docs.docker.com/engine/daemon/proxy/#systemd-unit-file)

```bash
sudo mkdir -p /etc/systemd/system/docker.service.d
```

Add a file called http-proxy.conf

```http-proxy.conf
[Service]
Environment="HTTP_PROXY=http://<proxy address>:3128"
Environment="HTTPS_PROXY=http://<proxy address>:3129"
```

Reload Docker

```bash
sudo systemctl daemon-reload
sudo systemctl restart docker
```

Check added

```bash
sudo systemctl show --property=Environment docker
```

## Git

Git can be configured to work through a proxy by use of the following configuration items in `/etc/gitconfig`:

```gitconfig
[http]
proxy = http://<proxy address>:3128

[https]
proxy = https://<proxy address>:3129
sslCAPath = /etc/pki/ca-trust/source/anchors/squid_proxyCA.crt
```

## Rocky Package manager YUM

To force proxy usage we need to put http proxy into the `/etc/yum.conf` e.g.

```conf
proxy=http://<proxy address>:3128
```

## Firefox add cert

/etc/ssl/ca-certificates/squidProxyCA.crt
