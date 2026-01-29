# Rundeck Docker Image
# Author: Sergio Rodriguez <sergio.rodriguez@cbba.cloud.org.bo>
# GitHub: https://github.com/Walsen
# Blog: https://blog.walsen.website
# Date: 2026-01-31

ARG RUNDECK_VERSION=5.15.0
FROM rundeck/rundeck:${RUNDECK_VERSION}

USER root

# Install only essential packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    nginx \
    supervisor \
    curl \
    jq \
    && rm -rf /var/lib/apt/lists/*

# Install rundeck-node-to-node plugin (latest version)
RUN PLUGIN_URL=$(curl -s https://api.github.com/repos/Walsen/rundeck-node-to-node/releases/latest | \
    jq -r '.assets[] | select(.name | endswith(".jar")) | .browser_download_url') && \
    curl -L -o /home/rundeck/libext/rundeck-node-to-node.jar "$PLUGIN_URL" && \
    chown rundeck:root /home/rundeck/libext/rundeck-node-to-node.jar

# Setup nginx directories
RUN mkdir -p /etc/nginx/sites-enabled /etc/nginx/ssl

# Copy configurations
COPY config/nginx.conf /etc/nginx/nginx.conf
COPY config/rundeck-site.conf /etc/nginx/sites-available/rundeck.conf
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY start-services.sh /usr/local/bin/start-services.sh

# Copy realm properties
COPY config/realm.properties /home/rundeck/etc/realm.properties

# Set permissions
RUN chmod +x /usr/local/bin/start-services.sh && \
    chown -R rundeck:root /home/rundeck/etc/ && \
    chmod 600 /home/rundeck/etc/realm.properties

EXPOSE 80

ENTRYPOINT ["/usr/local/bin/start-services.sh"]
