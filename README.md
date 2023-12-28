# FLOWFORWARD-PROXY

Easy to configure forward proxy with ENV only configuration.

## Getting started

## Run from dockerhub

Start two forward proxies, visit
http://localhost:8772 and http://localhost:8773
to visit the proxied sites.

The first proxy is configured for a https backend. Https is the default since a forward proxy
connects to servers 'far away', for which pretty much always https is the standard.

The second proxy for a http backend (explicitly specify the protocol).

```
docker run --rm \
    -p "8772:8772" \
    -p "8773:8773" \
    -e "PROXY_BACKEND=www.google.com" \
    -e "PROXY_PORT=8772" \
    -e "PROXY_BACKEND2=www.example.com" \
    -e "PROXY_PORT2=8773" \
    -e "PROXY_PROTOCOL2=http" \
    24hoursmedia/flowforward-proxy:1.0.0-nginx1.25-alpine3.18-slim
```

## Development

    docker compose -f docker-compose.test.yml up --build --force-recreate

Helper to check template results in container:

    tango parse:file /config-templates/nginx.conf.d/forward-proxies.conf.twig 