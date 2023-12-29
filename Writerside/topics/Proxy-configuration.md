# Proxy configuration


## Overview of env variables

| ENV name               | default    | description                                                                       |
|------------------------|------------|-----------------------------------------------------------------------------------|
| PROXY_BACKEND          |            | (required) The domain name or IP of the backend (i.e. www.example.com)            |
| PROXY_PORT             |            | (required) The port to access the proxy                                           |
|                        |            |                                                                                   |
| PROXY_NAME             |            | A name to use in config files, headers etc                                        |
| PROXY_BACKEND_PROTOCOL | https      | Protocol to access the backend, https or http                                     |
| PROXY_BACKEND_PORT     | (auto set) | The port of the backend. Leavy empty to auto set to 443 or 80                     |
| PROXY_UPLOAD_PRESET    | medium     | Preset for auto configuration of the proxy for different file upload / body sizes |

## Configuring multiple proxies

You can configure multiple proxies by suffexing the configuration variables with a number, i.e.

```
PROXY_BACKEND=www.example.com
PROXY_PORT=8080
PROXY_BACKEND2=www.example.com
PROXY_PORT2=8080
# underscore before number also allowed
PROXY_BACKEND_3=www.example.com
PROXY_PORT_3=8080
```

## Upload presets

By specifying an upload preset, you can configure each proxy with sensible settings for different file uploads.

| Preset    | Max body size | Timeouts | Request buffering |   |
|-----------|---------------|----------|-------------------|---|
| default   | (ngx default) |          |                   |   |
| tiny      | 256K          | 30s      | on                |   |
| small     | 2M            | 60s      | on                |   |
| medium    | 16M           | 120s     | off               |   |
| large     | 128M          | 300s     | off               |   |
| xlarge    | 256M          | 600s     | off               |   |
| xxlarge   | 512M          | 1200s    | off               |   |
| gigas     | 2048M         | 2400s    | off               |   |
| unlimited | no limit      | 3600s    | off               |   |
