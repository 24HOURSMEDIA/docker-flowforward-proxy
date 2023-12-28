#!/usr/bin/env sh
set -e
set -o pipefail

echo "*********************************************"
echo "Tango Nginx template parsing"
echo "*********************************************"

tango parse:dir /config-templates/nginx.conf.d /etc/nginx/conf.d

# copy the graceful reload of nginx cron
tango parse:file /config-templates/cronie/reload_nginx.twig > /etc/cron.d/reload_nginx
chmod 755 /etc/cron.d/reload_nginx


