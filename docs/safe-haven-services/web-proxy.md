# Web Proxy

_**Draft - all detail is TBC.**_

The repository mirror web proxy allows Researchers to install packages from specific external repositories such as CRAN and PyPI.

The proxy is configured with a limited allow-list of approved URLs. This list can only be altered at the request of the relevant Information Governance (IG) team. The proxy is set to only allow data ingress to prevent e.g., upload of packages to PyPI.

!!! note "Notes"
    The proxy is not available to all Researchers. Please ask your Research Coordinator if you are unsure.
    <br/><br/>
    Operational time controls are in place; currently Monday - Friday, 09:00 - 17:00 GMT. **The proxy will be unavailable outside of these hours.**

## Usage

Researchers who are permitted to use the proxy will be supplied with proxy credentials in the [`.bashrc`][bashrc] file in their home directory. This file is configured with common environment variables which many applications such as pip will use. These will be set near the end of the file:

```bash
$ cat ~/.bashrc
...
WEB_USER="<username>"
WEB_PASS="<password>"
WEB_PROXY="<proxy-ip>:800"
export HTTP_PROXY="http://${WEB_USER}:${WEB_PASS}@${WEB_PROXY}"
export HTTPS_PROXY=${HTTP_PROXY}
export FTP_PROXY=${HTTP_PROXY}
export http_proxy=${HTTP_PROXY}
export https_proxy=${HTTP_PROXY}
```

The password is not the same as either the VM or VDI password, and there is no need to remember it.

!!! danger
    These credentials should not be shared with anyone under any circumstances.

!!! note
    Firefox does not automatically use these variables, meaning that Researchers cannot access web proxy URLs in the browser. Usually there is no need for this, but Firefox can be configured to make use of the web proxy if desired, following [this][firefox_conf] guide and using the credentials in their [`~/.bashrc`][bashrc] file.

## FAQ

### How can I download a package from site "x"?

Any such requests should be raised directly with your Research Coordinator. Not all requests can be facilitated.

<!-- Links -->
[bashrc]: https://carpentries-incubator.github.io/shell-extras/07-aliases/index.html#bash-customization-files
[firefox_conf]: https://support.mozilla.org/en-US/kb/connection-settings-firefox
