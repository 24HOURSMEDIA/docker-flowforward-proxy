# Global configuration

| ENV name          | default | description                                         |
|-------------------|---------|-----------------------------------------------------|
| `KEEPALIVE_CONNS` |         | Number of connections to keepalive for each backend |
| `RELOAD_INTERVAL` | 53      | Gracefully reload the proxy every N minutes         |


## Graceful reloading

With `RELOAD_INTERVAL` you can set the interval in minutes for the proxy to gracefully reload.
When the proxy reloads, resolved ip addresses of backends are renewed.

If you have backends with changing ip addresses (i.e. AWS Application Load Balancer), you
can set the interval to an appropriate value.

If you experience disconnection from backends once in a while, first try to set the interval
to a lower value.
