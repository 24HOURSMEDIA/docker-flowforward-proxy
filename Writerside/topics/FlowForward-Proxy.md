# %product%

<include from="library.md" element-id="app_urls"/>

An easy to configure Nginx based http/https forward proxy.
No configuration files needed, configuration entirely through ENV vars.

## Features

* immediately deployable and usable
* configuration entirely through docker environment variables
* up to 10 proxies in a single container
* SNI (server name indication support) for backends
* configure different file upload settings with presets
* connection pooling
* available as docker image for Intel/AMD64 and ARM based platforms.
* avaible for multiple nginx / alpine versions
* graceful reload every N minutes to renew IP addresses for changing backends (i.e. AWS Loadbalancers etc)

## Getting Started

Set up an https and a http proxy.
Visit http://localhost:8772 and http://localhost:8773 for the proxied domains.

```
docker run --rm \
    -p "8772:8772" \
    -p "8773:8773" \
    -e "PROXY_BACKEND=www.google.com" \
    -e "PROXY_PORT=8772" \
    -e "PROXY_BACKEND2=www.example.com" \
    -e "PROXY_PORT2=8773" \
    -e "PROXY_PROTOCOL2=http" \
    24hoursmedia/flowforward-proxy:1-nginx1.25-alpine3.18-slim
```