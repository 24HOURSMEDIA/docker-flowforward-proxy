# Examples

## with docker run

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

## with docker compose

docker-compose.yml:
```
version: '3.7'

services:

  forward_proxy:
    image: 24hoursmedia/flowforward-proxy:1-nginx1.25-alpine3.18-slim
    env_file:
      - ./example_env.env
    ports:
      - "4000:4000"
      - "4001:4001"
      - "4002:4002"

  origin1:
    image: nginx:1.25.3-alpine3.18-slim
    
  origin2:
    image: nginx:1.25.3-alpine3.18-slim
```

example_env.env:
```
KEEPALIVE_CONNS=8
RELOAD_NGINX_INTERVAL=27

PROXY_BACKEND=www.24hoursmedia.com
PROXY_PORT=4000
PROXY_UPLOAD_PRESET=large

PROXY_BACKEND2=origin1
PROXY_PORT2=4001
PROXY_BACKEND_PROTOCOL2=http

PROXY_BACKEND3=www.usmarkets.nl
PROXY_PORT3=4002
PROXY_UPLOAD_PRESET3=tiny
```