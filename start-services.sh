#!/bin/bash
# Rundeck Startup Script
# Author: Sergio Rodriguez <sergio.rodriguez@cbba.cloud.org.bo>
# GitHub: https://github.com/Walsen
# Blog: https://blog.walsen.website
# Date: 2026-01-28
set -e

# Remove default nginx site and enable rundeck
rm -f /etc/nginx/sites-enabled/default
ln -sf /etc/nginx/sites-available/rundeck.conf /etc/nginx/sites-enabled/rundeck.conf

# Extract port from RUNDECK_GRAILS_URL (default to 80 if not set or no port specified)
EXTERNAL_PORT=$(echo "${RUNDECK_GRAILS_URL:-http://localhost}" | sed -n 's|.*://[^:/]*:\([0-9]*\).*|\1|p')
EXTERNAL_PORT=${EXTERNAL_PORT:-80}

echo "Configuring nginx for external port: $EXTERNAL_PORT"

# Update nginx proxy_redirect rules with the correct port
if [ "$EXTERNAL_PORT" = "80" ]; then
    sed -i "s|http://localhost:8080/|http://localhost/|g" /etc/nginx/sites-enabled/rundeck.conf
    sed -i "s|X-Forwarded-Host \$host:8080|X-Forwarded-Host \$host|g" /etc/nginx/sites-enabled/rundeck.conf
    sed -i "s|X-Forwarded-Port 8080|X-Forwarded-Port 80|g" /etc/nginx/sites-enabled/rundeck.conf
else
    sed -i "s|:8080|:$EXTERNAL_PORT|g" /etc/nginx/sites-enabled/rundeck.conf
fi

# Test nginx configuration
echo "Testing nginx configuration..."
nginx -t

echo "Starting services via supervisor..."
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
